---
title: "VizModules: interactivity-first Shiny modules for rapid, customizable data visualization applications in R"
tags:
    - R
    - shiny
    - data visualization
    - plotly
    - plotting modules
    - interactivity
authors:
    - name: Jacob Martin
      affiliation: 1
      orcid: "0009-0007-6896-4796"
    - name: Jared Andrews
      affiliation: 1
      orcid: "0000-0002-0780-6248"
date: 17 June 2026
affiliations:
    - name: Department of Developmental Neurobiology, St. Jude Children's Research Hospital, United States
      index: 1
      ror: 02r3e0967
bibliography: paper.bib
---

## Summary

Interactive data visualization is central to modern data analysis, enabling exploration of complex datasets, hypothesis generation, and communication of results. `VizModules` is an R package that provides a curated library of interactivity-first `shiny` [@shiny] modules for common plot types, including scatter, bar, line, box, violin, density, area, dot, histogram, pie, radar, and more. Every module renders interactive `plotly` [@plotly] graphics with tooltips, hover highlighting, draggable text and shape annotations, and one-click export in multiple formats, while exposing the full aesthetic controls of the underlying plot to users through a point-and-click interface. This allows generation of publication-quality figures without writing code. Each module has a consistent three-function interface, allowing developers to embed it in any `shiny` application in <10 lines of code. Built on `dittoViz` [@dittoViz], `plotthis` [@plotthis], `ggplot2` [@ggplot2], and `plotly` [@plotly], `VizModules` decouples plotting logic from data, accepts inputs ranging from in-memory data frames to uploaded CSV, TSV, and Excel files, and contains a multi-panel "Figure Builder" application for free-form composition and vector (SVG) export of complete figures.

## Statement of need

Developers who want to build fully customizable, interactive plots in `shiny` [@shiny] must implement input controls for every aesthetic, reactive wiring between controls and plots, download handlers, and any necessary interactive refinements. This process is time-consuming, error-prone, and duplicated across projects, and it rarely produces a consistent visual language within or between applications. However, these efforts are necessary so that non-programmers such as bench scientists, analysts, and domain experts are able to effectively explore and visualize their data. These needs place a continual support burden on computational staff and slow the path from data to insight.

`VizModules` addresses both problems with reusable, production-ready visualization building blocks. For developers, it removes visualization plumbing and provides a tested, uniform foundation that can be dropped into existing applications or extended into specialized modules. For non-programmers, it exposes comprehensive plotting and styling controls and, for several modules, statistical testing, directly in the user interface, enabling independent, reproducible data exploration and figure generation. The target audience therefore spans software teams building analysis platforms, analysts assembling bespoke dashboards, and end users who need to visualize data without coding expertise.


## State of the field

R's most common graphics packages (`ggplot2` [@ggplot2] for static graphics and `plotly` [@plotly] for interactivity) provide developers enormous flexibility but operate at a relatively low level. Teams must still design and maintain the controls, layouts, and reactive logic for every new `shiny` application. Several packages raise this floor, but with goals distinct from `VizModules`.

`esquisse` [@esquisse] offers a drag-and-drop interface for building individual `ggplot2` charts and exporting their code. It allows ad-hoc creation of single, static plots, but it does not produce reusable `shiny` modules, emphasize interactivity, or support composing multiple coordinated visualizations within an application. `datamods` [@datamods] provides polished `shiny` modules for importing, validating, and filtering data. It is complementary to `VizModules`, which targets the visualization layer (and includes its own data-filtering module) rather than data ingestion.

Framework-level tools take a heavier approach. `teal` [@teal] is a full exploratory-analysis framework, originally developed for clinical-trial reporting, in which applications are assembled from analysis modules within the `teal` runtime. It is powerful but requires adopting its application architecture and is oriented toward analysis workflows rather than deep, per-plot aesthetic control. `periscope2` [@periscope2] standardizes the scaffolding of `shiny` applications, offering layout, logging, and generic download modules, but does not provide a flexible library of visualization modules. `blockr` [@blockr] enables no-code construction of data-analysis pipelines by wiring together "blocks" into a directed acyclic graph, targeting end-to-end visual programming rather than framework-agnostic modules that can be dropped in to any `shiny` application.

`VizModules` occupies a distinct niche by offering a curated set of interactivity-first, deeply customizable plotting modules that drop into any `shiny` application. Full aesthetic control of each plot is handed to the end user. This focus complements the tools above, as `VizModules` modules can be embedded inside a `periscope2` shell, paired with `datamods` importers, or used to prototype the visual components that a `teal` or `blockr` deployment might later incorporate.

## Software design

`VizModules` adopts a modular architecture layered on established plotting libraries, separating each module into UI, server, and configuration concerns. Every visualization exposes a trio of functions: `*InputsUI()` for controls, `*OutputUI()` for the plot, and `*Server()` for logic. This allows controls and outputs to be placed independently within a layout, and ensures that data are supplied reactively and kept decoupled from the plot. 

To serve both app users and developers, the input functions accept `defaults`, `hide.inputs`, and `hide.tabs` arguments that pre-fill or hide controls without altering server logic, letting developers enforce application-level defaults while reusing the same tested module. A `createModuleApp()` factory turns any module trio into a complete application for simple testing, and the same pattern provides a template for composing higher-level "wrapper" modules that add domain-specific logic while reusing a base module's full functionality.

The package fully embraces `plotly` for interactivity, either converting `ggplot2` objects via `ggplotly()` or constructing `plotly` figures natively. In many cases where `ggplot2` conversion is imperfect, `VizModules` applies targeted `plotly` refinements to preserve original functionality. This enables the usage of existing plotting functions that return `ggplot2` objects, and several modules are built on top of `plotthis` [@plotthis] and `dittoViz` [@dittoViz] plot functions.

`VizModules` is implemented primarily in R, with select JavaScript components such as a custom `multiColorPicker` input for individually mapping colors to discrete variable levels. Documentation tooltips for plotting functions are automatically extracted with `roclang` to attach detailed descriptions to each control on hover. The `BoxPlot`, `ViolinPlot`, and `yPlot` modules add an integrated statistics tab supporting pairwise tests (Wilcoxon rank-sum and paired or unpaired t-tests) and omnibus tests (Kruskal–Wallis and ANOVA), with bracket annotations placed by an interval-packing algorithm, configurable p-value adjustment, and per-facet or nested-group comparisons. Finally, helper functions collect each plot together with its underlying data, the inputs used to generate it, and any statistical results into a single downloadable archive at the click of a button, supporting reproducibility and downstream editing.

## Research impact statement

`VizModules` is available on [CRAN](https://cran.r-project.org/web/packages/VizModules/index.html), actively maintained, well-documented with a `pkgdown` [website](https://j-andrews7.github.io/VizModules/) and vignettes (including clear guides to using modules in your own app, authoring new modules, and extending existing modules), and covered by a `testthat` suite spanning its plotting functions and internal helpers. A hosted [module gallery](https://j-andrews7-vizmodules.share.connect.posit.cloud/) and [Figure Builder application](https://j-andrews7-vizmodulesfigbuilder.share.connect.posit.cloud/) let users evaluate every module and assemble multi-panel figures complete with automatic panel labelling and single-file SVG export directly in the browser.

The package is designed as a foundational layer enabling development of more specialized modules. The base modules can be easily extended to generate more complex modules that operate on specific data structures or analysis outputs. By giving developers a tested, interactivity-first visualization base and providing downstream users a code-free way to explore and visualize their data, `VizModules` shortens the path from raw data to production-ready applications and publication-quality visualizations.

## AI usage disclosure

`VizModules` was developed with assistance from generative AI tools, including GitHub Copilot and Claude Code, for code optimization, debugging, and documentation formatting. The core architecture, module logic, and testing strategy were designed and authored by the developers, and all AI-assisted contributions were manually reviewed and tested.

