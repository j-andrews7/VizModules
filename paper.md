---
title: "VizModules: customizable, extendable R Shiny modules for rapid development of interactive applications" 
tags:
    - R
authors:
    - name: Jacob Martin
      affiliation: 1
      orcid: "0009-0007-6896-4796"
    - name: Jared Andrews
      affiliation: 1
      orcid: "0000-0002-0780-6248"
date: 10 March 2026
affiliations:
    - name: Department of Developmental Neurobiology, St. Jude Children's Research Hospital
      index: 1
      ror: 02r3e0967
---

## Summary

Interactive data visualization is essential for modern day analytical workflows, enabling analysts to explore complex datasets in a personalized fashion. VizModules is an R package developed to provide ready made, reusable building blocks for interactive applications that accelerate application development, data exploration, and high-quality figure generation. Modules facilitate stats tests and customization while delivering interactive features such as tooltips and hover effects for an engaging user experience. Modules include, but are not limited to, scatter, density, bar, line, and box plots, providing a flexible set of options for diverse data visualization needs. VizModules building blocks enable downstream development of specialized analysis applications, such as bulk RNA sequencing analysis explorers. VizModules is designed to work with standard R data frames, while a separate data import module enables support for formats such as Excel and CSV, ensuring accessibility for users with varying levels of coding experience. By standardizing visual components of analysis tools, it eliminates repetitive coding that wastes the time of many researchers.

## Statement of need

VizModules empowers software engineers across disciplines to build unified visual analysis applications while enabling non-computational personel to customize and visualize their data without coding expertise. Non-computational personel currently face significant barriers to independently exploring their datasets, placing heavy demands on computational staff and wasting time on repetitive visualization tasks. Furthermore, the lack of unified visualization approaches within specific analysis workflows leads to inconsistent and non-reproducible outputs. VizModules bridges this gap by providing standardized building blocks for visual analysis pipelines.

VizModules accelerates creation of meaningful data observations while maintaining flexibility for field-specific visual components. Additionally, these modules are easily editable to suit specialized analysis tasks such as bulk RNA sequencing analysis or genomic annotations. They provide testable, production-ready components that reduce time spent debugging and coding.

The target audience includes analysts with varying coding expertise, non technical data explorers, and software development teams building interactive analysis applications across industries. VizModules reduces time spent on visualization plumbing, enabling users to focus on data interpretation and actionable insights. The package supports extensibility through vignettes that guide developers in creating custom modules using established templates.

## State of the field

R's foundational plotting packages, such as ggplot2 provide programmers with extensive capabilities for static data visualization. Building on these core tools, libraries like plotly and shiny allow developers to create interactive platforms with dynamic graphics and a wide range of customization [@Sievert2020]. However these technologies operate at a relatively low level. Developers must still design, implement, and maintain custom plotting modules and user interfaces for new applications, often duplicating similar logic across projects. 

Several packages try and lower this barrier for development by providing users with custom plaftforms to perform specific analysis work or to create custom plots. Packages like **esquisse** enable interactive ggplot2 chart creation through drag and drop interfaces, but lack the ability to generate reusable, standardized Shiny modules. While useful for rapidly creating single static plots, esquisse does not support quick data switching or the composition of multiple visualization types within cohesive analysis applications.

VizModules is designed to fill this gap rather than duplicate existing functionality. Instead of introducing yet another static plotting engine, it contributes a curated set of dynamic pre-built modules that wrap existing static plotting code bases. Furthermore, this package adopts a distinct focus, complementing existing tools that already excel at drawing plots and defining their layouts. By shifting to this focus, VizModules enables rapid app development by providing key plotting code to create multi plot analysis tools for integrated data insight. Consistent visual language across modules eliminates visualization plumbing and improves reproduciblilty. VizModules' dataFilter module ability to accept diverse table formats (Excel, CSV, data frames) eliminates data preprocessing barriers, enabling analysts and non-coders to directly visualize their data without R expertise. 

VizModules advances the field with its stats UI component in select modules, offering extensive customization of test types, significance thresholds, aesthetics like line colors and annotation offsets, p-value adjustments, and pairwise comparisons. By providing stats customization to target modules, this delivers efficient first insights into data statistical significance without manual test execution or post plot annotation. 

## Software design

VizModules adopts a modular architecture built on top of established plotting libraries like plotthis, dittoViz, and plotly, separating modules into distinct UI, server, and configuration components. This design enables seamless customization while ensuring consistent behaviour and reproducibility across all visualization functions. VizModules implements standardized Shiny modules featuring DT table interface modules for data input and configuration alongside plotly outputs for interactive visualization. The package is primarily implemented in R, with select JavaScript components for enhanced interactivity, such as a novel multiColorPicker input for granular color mapping of variables with discrete levels. 

This package fully embraces plotly for interactive visualization, utilizing either `ggplotly()` to convert ggplot2 objects or constructing plotly plots natively. When ggplotly conversion is imperfect, VizModules applies additional refinements directly with plotly to ensure optimal interactivity and presentation. 

VizModules provides developers with the ability to restrict the plot input controls without comprimising the underlying server logic through the `hide.inputs`, `defaults`, and `hide.tabs` parameters built into the UI function. The clear separation of each module into `module_app`, `module_server`, and `module_ui` components establishes a robust template for future custom module development. Internal utility functions streamline repetitive server and UI logic, reducing boilerplate code while maintaining architectural consistency. More specific software design points include `organize_input` and `module_tack_ui` functions which establish a standardized layout and controls format. Documentation tooltips powered by the `roclang` package deliver detailed descriptions for each UI input, enhancing user guidance.

## Research impact statement

The package delivers production ready modules already powering specialized applications, such as volcano plots in the SciVizModules package built directly on the scatter plot module in VizModules. The package provides a complete GitHub repository featuring comprehensive testthat coverage for all plotting functions and internal helpers, ensuring robust reliability. VizModules serves as the foundational layer for SciVizModules, providing specialized extensions of core modules for anaylsis applications such as RNA-seq explorers. The aim is to create analysis applications with unified plotting modules to enable bench scientists to explore and analyse their data in a customizable environment. 

The package contains clear vignettes, providing users and developers with clear guidance for creating new VizModules, to benefit their research. Additionally, the package equips modules with the ability to import external data formats (Excel, CSV) via the dataFilter module, while select modules feature integrated stats customization for rapid statistical insights without manual testing or annotation. CRAN ready and actively maintained, with submission coinciding with publication. 

## AI usage disclosure

VizModules was developed with assistance of generative AI tools such as GitHub copilot. AI usuage was limited to code optimization, debugging, and documentation formatting. Core architecture, module logic, testing strategy were authored by the developers. All contributions were manually reviewed and rigorously tested before integration into the main branch. 


