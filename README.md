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

* Automatic thesis **cover generation**, drawn in absolute page coordinates
  through the LaTeX kernel shipout hooks, so it never depends on the
  document margins
* **Spanish and English** document support; names such as *Tabla* or
  *References* survive `\selectlanguage`, so a thesis can include an abstract
  in the other language
* Preconfigured **typography similar to Times** (TeX Gyre Termes, Heros and
  Cursor with `newtxmath`)
* Custom **chapter style**
* Predefined **thesis metadata commands**, also written to the PDF metadata
  when `hyperref` is loaded
* Page layout declared with `geometry`, adjustable with `\geometry{...}`
* **Fast builds**: `latexmk` configuration with a precompiled preamble and
  draft mode

# Requirements

* A LaTeX distribution from 2020-10 or later (TeX Live 2020+, MiKTeX,
  Overleaf). The cover uses the `shipout/background` hook of the LaTeX
  kernel.
* `pdflatex` is the recommended engine. It is the fastest for this
  template and the one used by the provided `.latexmkrc`. The template also
  compiles with `lualatex`.
* `latexmk` (bundled with TeX Live and MiKTeX) for building.

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
latexmk            # build example.tex (pdflatex + bibtex, minimal passes)
latexmk -pvc       # rebuild automatically whenever a file is saved
latexmk -C         # remove every generated file
```

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

\asesor{Advisor Name}

\grado{M.S. in Computer Science}

\mes{October}

\anio{2025}
```

If `hyperref` is loaded, the title and author are also used as PDF metadata
unless `pdftitle` or `pdfauthor` were set explicitly.

# Generating the Cover Page

To generate the official cover page:

```latex
\portada
```

This command automatically uses the metadata previously defined. It always
starts on a fresh page and leaves the page style and margins untouched.

# Customization

* **Margins.** The layout is set with `geometry`; adjust it after loading
  the package with `\geometry{...}`.
* **Chapter titles.** Numbered chapter titles are set in bold. To use bold
  small capitals instead, add `\scshape` before `#1` in
  `\@makechapterhead` (see the comment in `inaoe-tesis.sty`).
* **Language names.** The names of chapters, tables, figures and lists are
  added to `\captionsspanish` / `\captionsenglish`; override them the same
  way, for example `\addto\captionsspanish{\renewcommand{\bibname}{Bibliografía}}`.

# Minimal Example

```latex
\documentclass{report}

\usepackage[english]{inaoe-tesis}

\tituloTesis{Example Thesis}
\autor{John Doe}
\asesor{Dr. Advisor}
\grado{M.S. in Computer Science}
\mes{October}
\anio{2025}

\begin{document}

\portada

\tableofcontents

\chapter{Introduction}

This is a sample thesis document.

\end{document}
```

# Dependencies

The template loads the following packages:

* `babel`
* `fontenc`
* `tgtermes`, `tgheros`, `tgcursor`
* `amsmath`
* `newtxmath`
* `geometry`
* `graphicx`
* `xcolor`

`example.tex` additionally uses `microtype`, `mathtools`, `booktabs`,
`threeparttable`, `algorithm`, `algpseudocode`, `listings`, `csquotes`,
`ulem`, `natbib` (required by the `unsrtnat` bibliography style, with the
`numbers` option for numeric citations like `[1]`) and `hyperref` with
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
