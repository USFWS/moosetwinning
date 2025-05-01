
<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

# twinning <a href="https://github.com/USFWS/twinning"><img src="man/figures/logo.png" align="right" height="150" style="float:right; height:150px;" alt="twinning github repository"/></a>

## Overview

This R package imports moose twinning data, estimates twinning rates,
generates plots and summary tables, and produces a survey report.
Originally developed for [Tetlin National Wildlife Refuge’s moose
twinning
survey](https://iris.fws.gov/APPS/ServCat/Reference/Profile/145850), but
could be adopted to other similar surveys. Generates a report that
follows the [AK Refuge Report Series
template](https://github.com/USFWS/akrreport).

## Installation

To use `twinning` and generate reports, you’ll need:

1.  **R version \>4.0** Available through FWS Apps-to-Go

2.  **Rtools version \>4.0** Available through FWS Apps-to-Go

3.  A version of [RStudio](https://posit.co/download/rstudio-desktop/)
    that includes [Quarto](https://quarto.org/)

To install `twinning`:

``` r
if (!require("devtools")) install.packages("devtools")  
devtools::install_github("USFWS/twinning", ref = "main", build_vignettes = TRUE)  

library(twinning)
```

## Usage

To generate a moose twinning report:

``` r
library(twinning)
create_report(dat)
```

For more information, check out the package [GitHub
page](usfws.github.io/twinning/).

## Getting help

Contact the [project maintainer](emailto:mccrea_cobb@fws.gov) for help
with this repository.

## Contribute

Contact the [project maintainer](emailto:mccrea_cobb@fws.gov) for
information about contributing to this repository template. Submit a
[GitHub Issue](https://github.com/USFWS/twinning/issues) to report a bug
or request a feature or enhancement.

------------------------------------------------------------------------

![](https://i.creativecommons.org/l/zero/1.0/88x31.png) This work is
licensed under a [Creative Commons Zero Universal v1.0
License](https://creativecommons.org/publicdomain/zero/1.0/).
