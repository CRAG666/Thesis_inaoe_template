# INAOE Thesis LaTeX Template

**inaoe-tesis** is an unofficial LaTeX template for writing theses at the
**Instituto Nacional de Astrofísica, Óptica y Electrónica (INAOE)**.

This package provides formatting utilities for:

* Thesis cover page
* Chapter styling
* Page layout
* Spanish and English language support
* Thesis metadata configuration

The goal of this template is to simplify the creation of thesis documents while maintaining a professional layout compatible with typical INAOE formatting conventions.

# Author

**Diego Aguilar**

GitHub:
[https://github.com/CRAG666](https://github.com/CRAG666)

# License

This project is distributed under the **GNU General Public License v3.0 (GPLv3)**.

You are free to:

* Use
* Modify
* Distribute

Under the conditions specified in the GPL license.

See the `LICENSE` file for the complete terms.

# Features

* **Cover pages identical to the Typst version** of the template (same
  frame, logos, text positions and spacing): the official thesis cover
  (`\portada`) and the thesis proposal cover used by the Coordinación de
  Ciencias Computacionales (`\portadaPropuesta`). Both are drawn in absolute
  page coordinates through the LaTeX kernel shipout hooks, so they never
  depend on the document margins
* **Spanish and English** document support; names such as *Tabla*, *Índice*
  or *References* are stored with babel's `\setlocalecaption`, so they
  survive `\selectlanguage` and a thesis can include an abstract in the
  other language
* **TeX Gyre Termes** typography, as in the Typst version: `newtxtext` and
  `newtxmath` with `pdflatex`; OpenType fonts through `fontspec` and
  `unicode-math` (TeX Gyre Termes Math) with `lualatex`, `xelatex` or
  `tectonic`, loaded by file name so they need no system installation
* Custom **chapter style**, and a table of contents with dotted leaders on
  every entry
* **Front matter environments** (`dedicatoria`, `agradecimientos`,
  `resumen`) that are added to the table of contents
* The **lists of figures and tables are omitted** when the document has no
  figures or tables
* **Table captions above** the table (`caption`)
* **Bibliography with `biblatex` and `biber`** (IEEE style in the example),
  with `\cite`, `\textcite`, `\citeauthor`, `\citeyear` and `\fullcite`
* Predefined **thesis metadata commands**, also written to the PDF metadata
  when `hyperref` is loaded
* Page layout declared with `geometry`, adjustable with `\geometry{...}`
* **Fast builds**: `latexmk` configuration with a precompiled preamble and
  draft mode

# Requirements

* A LaTeX distribution from 2021-11 or later (TeX Live 2022+, MiKTeX,
  Overleaf, or the default Tectonic bundle). The cover uses the
  `shipout/background` hook of the LaTeX kernel.
* `pdflatex` is the recommended engine. It is the fastest for this
  template and the one used by the provided `.latexmkrc`. The template also
  compiles with `lualatex` (`latexmk -lualatex`) and with `tectonic`, which
  use OpenType fonts.
* `biber` for the bibliography and `latexmk` for building (both bundled
  with TeX Live and MiKTeX).

# Installation

Clone the repository:

```bash
git clone https://github.com/CRAG666/Thesis_inaoe_template.git
```

Place the file `inaoe-tesis.sty` in your project directory or in your local
LaTeX tree. The cover expects the `cover/` directory next to your main file.

Example structure:

```
thesis/
│
├── main.tex
├── inaoe-tesis.sty
├── references.bib
├── .latexmkrc
└── cover/
    ├── Inaoe.pdf
    └── cmyk-original.jpg
```

# Compiling

```bash
latexmk            # build example.tex (pdflatex + biber, minimal passes)
latexmk -lualatex  # build with LuaLaTeX and OpenType fonts
latexmk -pvc       # rebuild automatically whenever a file is saved
latexmk -C         # remove every generated file
tectonic example.tex  # build with Tectonic (runs biber automatically)
```

Tectonic downloads the TeX files it needs on the first run. It runs the
`biber` found on the `PATH`, whose version must match the `biblatex` of the
Tectonic bundle (biber 2.17 for the default TeX Live 2022 bundle).

The `.latexmkrc` file drives the whole build. On the first run it stores the
complete preamble (class, packages, fonts and template) in `example.fmt`
using `mylatexformat`; every following pass loads that format instead of
processing the preamble again, which removes most of the fixed cost of a
compilation. The format is regenerated automatically when the preamble of
`example.tex` (everything before `\begin{document}`), `inaoe-tesis.sty` or
any package used by the preamble changes; editing the body of the thesis
reuses it. The build silently falls back to a normal `pdflatex` run if
`mylatexformat` is not available. To compile without the precompiled preamble:

```bash
latexmk -e '$inaoe_fmt=0'
```

# Fast iteration while writing

* **Draft mode.** `\documentclass[12pt,draft]{report}` skips image loading,
  disables `microtype` and hyperlinks, and marks overfull lines with a black
  box. Remove the option for the final build.
* **Watch mode.** `latexmk -pvc` recompiles on save, running only the passes
  that are needed.
* **Long theses.** If you move each chapter to its own file loaded with
  `\include`, `\includeonly{...}` typesets only the chapters you are
  editing while keeping the page numbers and references of the rest.

# Usage

Load the package in your document preamble.

### English thesis

```latex
\usepackage[english]{inaoe-tesis}
```

### Spanish thesis

```latex
\usepackage[spanish]{inaoe-tesis}
```

# Thesis Metadata

The template provides commands for defining thesis information.

```latex
\tituloTesis{Thesis Title}

\autor{Author Name}

\asesor{Dr. First Advisor \\ Dra. Second Advisor}

\grado{M.S. in Computer Science}

\mes{October}

\anio{2025}        % optional; defaults to the current year
```

Optional commands:

```latex
\requisito{Custom text above the degree}   % \requisito{} removes the line
\departamento{Coordinación de Ciencias Computacionales}  % proposal cover
```

If `hyperref` is loaded, the title and author are also used as PDF metadata
unless `pdftitle` or `pdfauthor` were set explicitly.

# Generating the Cover Page

```latex
\portada            % official thesis cover
\portadaPropuesta   % thesis proposal cover (no rights or reproduction notice)
```

Both commands use the metadata previously defined. They always start on a
fresh page and leave the page style and margins untouched.

# Front Matter

```latex
\pagenumbering{roman}

\tableofcontents
\listoffigures      % omitted when there are no figures
\listoftables       % omitted when there are no tables

\begin{dedicatoria} ... \end{dedicatoria}
\begin{agradecimientos} ... \end{agradecimientos}
\begin{resumen} ... \end{resumen}

\clearpage
\pagenumbering{arabic}
```

The titles follow the language of the thesis (*Dedication* / *Dedicatoria*,
*Acknowledgements* / *Agradecimientos*, *Abstract* / *Resumen*).

# Bibliography

```latex
\usepackage[style=ieee]{biblatex}
\addbibresource{references.bib}
...
\printbibliography[heading=bibintoc]
```

The bibliography is titled *References* / *Referencias*.

| biblatex             | Output              |
|----------------------|---------------------|
| `\cite{key}`         | [1]                 |
| `\textcite{key}`     | L. Lamport [1]      |
| `\citeauthor{key}`   | L. Lamport          |
| `\citeyear{key}`     | 1994                |
| `\cite[p.~10]{key}`  | [1, p. 10]          |

# Customization

* **Margins.** The layout is set with `geometry`; adjust it after loading
  the package with `\geometry{...}`.
* **Language names.** Override them with babel, for example
  `\setlocalecaption{spanish}{bib}{Bibliografía}`.

# Minimal Example

```latex
\documentclass[12pt]{report}

\usepackage[english]{inaoe-tesis}
\usepackage{csquotes}
\usepackage[style=ieee]{biblatex}
\addbibresource{references.bib}

\tituloTesis{Example Thesis}
\autor{John Doe}
\asesor{Dr. Advisor}
\grado{M.S. in Computer Science}
\mes{October}

\begin{document}

\portada

\pagenumbering{roman}
\tableofcontents

\begin{resumen}
  This thesis presents...
\end{resumen}

\clearpage
\pagenumbering{arabic}

\chapter{Introduction}

This is a sample thesis document~\cite{lamport94}.

\printbibliography[heading=bibintoc]

\end{document}
```

# Dependencies

The template loads the following packages:

* `babel`
* `iftex`
* `mathtools` (loads `amsmath`)
* `fontenc`, `newtxtext`, `newtxmath` (pdflatex)
* `unicode-math` (loads `fontspec`; lualatex and xelatex)
* `graphicx`
* `xcolor`
* `caption`
* `geometry`

`example.tex` additionally uses `microtype`, `booktabs`, `threeparttable`,
`algorithm`, `algpseudocode`, `listings`, `csquotes`, `ulem`, `biblatex`
(`biblatex-ieee` style, processed with `biber`) and `hyperref` with
`hypertexnames=false`, which avoids duplicate destination warnings when the
page numbering is restarted after the cover. The precompiled preamble uses
`mylatexformat`.

These packages are included in most LaTeX distributions such as **TeX Live** or **MiKTeX**.

# Repository Structure

```
inaoe-tesis/
│
├── inaoe-tesis.sty          # the template package
├── example.tex              # complete example thesis in a single file
├── .latexmkrc               # build configuration for latexmk
├── references.bib
├── cover/
│   ├── Inaoe.pdf
│   └── cmyk-original.jpg
├── README.md
└── LICENSE
```

# Disclaimer

This template is **not an official template of INAOE**.
It is an independent implementation intended to facilitate thesis writing.

Students should verify that the formatting complies with the current institutional guidelines.

# Contributions

Contributions are welcome.

You can:

* Open an **issue** for bugs
* Submit **pull requests**
* Suggest improvements

Repository:
[https://github.com/CRAG666/Thesis_inaoe_template](https://github.com/CRAG666/Thesis_inaoe_template)
