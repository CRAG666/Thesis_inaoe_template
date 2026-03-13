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

* Automatic thesis **cover generation**
* **Spanish and English** document support
* Preconfigured **typography similar to Times**
* Custom **chapter style**
* Predefined **thesis metadata commands**
* Clean page layout suitable for academic theses

# Installation

Clone the repository:

```bash
git clone https://github.com/CRAG666/Thesis_inaoe_template.git
```

Place the file `inaoe-tesis.sty` in your project directory or in your local LaTeX tree.

Example structure:

```
thesis/
│
├── main.tex
├── inaoe-tesis.sty
├── references.bib
└── cover/
    ├── Inaoe.pdf
    └── cmyk-original.jpg
```

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

# Generating the Cover Page

To generate the official cover page:

```latex
\portada
```

This command automatically uses the metadata previously defined.

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

The template uses several LaTeX packages, including:

* `babel`
* `graphicx`
* `fancyhdr`
* `xcolor`
* `newtxmath`
* `tgtermes`
* `tgheros`
* `tgcursor`

These packages are included in most LaTeX distributions such as **TeX Live** or **MiKTeX**.

# Repository Structure

```
inaoe-tesis/
│
├── inaoe-tesis.sty
├── README.md
├── LICENSE
├── example.tex
└── cover/
    ├── Inaoe.pdf
    └── cmyk-original.jpg
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

