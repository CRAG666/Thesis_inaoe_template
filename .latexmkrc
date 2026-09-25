# Configuración de latexmk para la plantilla INAOE.
#
#   latexmk                     compila example.tex con las pasadas mínimas
#   latexmk -pvc                recompila automáticamente al guardar
#   latexmk -C                  elimina todo lo generado (incluido el .fmt)
#   latexmk -e '$inaoe_fmt=0'   compila sin preámbulo precompilado
#
# Preámbulo precompilado
# ----------------------
# La primera compilación vuelca el preámbulo completo (clase, paquetes,
# fuentes y plantilla) en example.fmt mediante mylatexformat. Las pasadas
# siguientes cargan ese formato en lugar de reprocesar el preámbulo, lo que
# elimina la mayor parte del costo fijo de cada compilación.
#
# En example.fmtdeps quedan anotados una huella del preámbulo de
# example.tex (todo lo anterior a \begin{document}) y los archivos que
# intervinieron en el formato. Al iniciar latexmk se comprueba si el
# preámbulo o alguno de esos archivos cambió y, de ser así, el formato se
# regenera; editar solo el cuerpo del documento no lo regenera. Además, el
# formato hace que cada pasada registre los archivos locales del preámbulo
# (por ejemplo inaoe-tesis.sty) como entradas, de modo que latexmk -pvc
# también reacciona a sus cambios.
#
# Si mylatexformat no está disponible o el formato falla, se compila de la
# forma habitual sin intervención del usuario.

use Digest::MD5 qw(md5_hex);

$pdf_mode   = 1;   # pdflatex: el motor más rápido para esta plantilla
$bibtex_use = 2;   # ejecuta bibtex solo cuando cambian .bib o las citas
@default_files = ('example.tex');
$clean_ext  = 'synctex.gz run.xml bbl fmt fmtdeps fmtdeps.tex';

our $inaoe_fmt = 1;
$pdflatex = 'internal inaoe_pdflatex %O %S';

# Al iniciar: descarta el formato si cambió algo de lo que contiene
for my $src (@default_files, grep { /\.tex\z/ } @ARGV) {
    (my $base = $src) =~ s/\.tex\z//;
    next unless -e "$base.fmt";
    if (inaoe_fmt_stale($base)) {
        unlink "$base.fmt";
        $go_mode = 1;
    }
}

sub inaoe_pdflatex {
    my @args = @_;
    my $src  = $args[-1];
    (my $base = $src) =~ s/\.tex\z//;
    my @opts = ('-interaction=nonstopmode', '-file-line-error', '-synctex=1');

    return system('pdflatex', @opts, @args) unless $inaoe_fmt;

    my $fmt = "$base.fmt";
    if (!-e $fmt || inaoe_fmt_stale($base)) {
        print "inaoe: generando preámbulo precompilado $fmt\n";
        my $hash = inaoe_preamble_hash($src);
        # El gancho hace que cada pasada abra los archivos locales del
        # preámbulo, para que latexmk los vigile aunque vivan en el formato
        my $hook = "\\AtBeginDocument{\\InputIfFileExists{$base.fmtdeps.tex}{}{}}"
                 . "\\input mylatexformat.ltx $src";
        my $rc = system('pdflatex', '-ini', '-recorder', '-interaction=nonstopmode',
                        "-jobname=$base", '&pdflatex', $hook);
        if ($rc != 0 || !-e $fmt) {
            warn "inaoe: no se pudo generar $fmt; se compila sin él\n";
            unlink $fmt, "$base.fmtdeps", "$base.fmtdeps.tex";
            return system('pdflatex', @opts, @args);
        }
        my @deps = grep { $_ ne $src && $_ ne "./$src" } inaoe_fmt_inputs("$base.fls", $src);
        inaoe_write_lines("$base.fmtdeps", "preamble:$hash", @deps);
        my @local = grep { !m{^[A-Za-z]:|^/} } @deps;
        inaoe_write_lines("$base.fmtdeps.tex", map { "\\IfFileExists{$_}{}{}" } @local);
    }

    my ($rc, $fmt_error) = inaoe_run('pdflatex', "-fmt=$base", @opts, @args);
    if ($fmt_error) {
        # Formato de otra versión de TeX: se descarta y se vuelve a intentar
        warn "inaoe: $fmt no es compatible con este pdflatex; se regenera\n";
        unlink $fmt, "$base.fmtdeps", "$base.fmtdeps.tex";
        return inaoe_pdflatex(@args);
    }
    return $rc;
}

# ¿Cambió el preámbulo, falta la lista de dependencias o alguna de ellas
# es más reciente que el formato?
sub inaoe_fmt_stale {
    my ($base) = @_;
    my $fmt   = "$base.fmt";
    my @lines = inaoe_read_lines("$base.fmtdeps");
    return 1 unless @lines;
    my ($hash) = map { /^preamble:(\S+)/ ? $1 : () } @lines;
    return 1 unless defined $hash && $hash eq inaoe_preamble_hash("$base.tex");
    my @deps = grep { !/^preamble:/ } @lines;
    return scalar grep { !-e $_ || (stat $_)[9] > (stat $fmt)[9] } @deps;
}

# Huella del preámbulo: todo lo anterior a \begin{document} (o \endofdump)
sub inaoe_preamble_hash {
    my ($src) = @_;
    open(my $fh, '<', $src) or return '';
    my $text = do { local $/; <$fh> };
    close $fh;
    $text = $1 if $text =~ /\A(.*?)(?:\\begin\s*\{document\}|\\endofdump)/s;
    return md5_hex($text);
}

# Archivos leídos al generar el formato, según el .fls de la pasada -ini
sub inaoe_fmt_inputs {
    my ($fls, $src) = @_;
    my (%seen, @in);
    for (inaoe_read_lines($fls)) {
        next unless /^INPUT\s+(.+?)\s*\z/;
        my $f = $1;
        next if $f =~ /\.fmt\z/ || $seen{$f}++;
        push @in, $f;
    }
    return @in ? @in : ($src);
}

# Ejecuta pdflatex mostrando su salida y detecta fallos de carga del formato
sub inaoe_run {
    my @cmd = @_;
    my $fmt_error = 0;
    open(my $fh, '-|', @cmd) or return (system(@cmd), 0);
    while (my $line = <$fh>) {
        print $line;
        $fmt_error = 1 if $line =~ /format file error|can't find the format file/i;
    }
    close $fh;
    return ($? >> 8, $fmt_error);
}

sub inaoe_read_lines {
    my ($f) = @_;
    open(my $fh, '<', $f) or return ();
    chomp(my @l = <$fh>);
    close $fh;
    return @l;
}

# Escribe solo si el contenido cambia, para no disparar pasadas de más
sub inaoe_write_lines {
    my ($f, @l) = @_;
    my $new = join('', map { "$_\n" } @l);
    my $old = join('', map { "$_\n" } inaoe_read_lines($f));
    return if -e $f && $old eq $new;
    open(my $fh, '>', $f) or return;
    print $fh $new;
    close $fh;
}
