# module_registry <- list(
#     area = list(
#         label = "Area Plot", dataset = "example_sales",
#         inputs_ui = plotthis_AreaPlotInputsUI,
#         output_ui = plotthis_AreaPlotOutputUI,
#         server_fn = plotthis_AreaPlotServer,
#         defaults = list("x.data" = "year", "y.data" = "revenue",
#                         "group.by" = "product_line")
#     ),
#     bar = list(
#         label = "Bar Plot", dataset = "example_bar",
#         inputs_ui = plotthis_BarPlotInputsUI,
#         output_ui = plotthis_BarPlotOutputUI,
#         server_fn = plotthis_BarPlotServer,
#         defaults = list("x.data" = "Group", "y.data" = "Values",
#                         "group.by" = "Type")
#     ),
#     box = list(
#         label = "Box Plot", dataset = "example_demographics",
#         inputs_ui = plotthis_BoxPlotInputsUI,
#         output_ui = plotthis_BoxPlotOutputUI,
#         server_fn = plotthis_BoxPlotServer,
#         defaults = list("x.data" = "department", "y.data" = "salary")
#     ),
#     density = list(
#         label = "Density Plot", dataset = "example_demographics",
#         inputs_ui = plotthis_DensityPlotInputsUI,
#         output_ui = plotthis_DensityPlotOutputUI,
#         server_fn = plotthis_DensityPlotServer,
#         defaults = list("x.data" = "salary", "group.by" = "department")
#     ),
#     dotplot = list(
#         label = "Dot Plot", dataset = "example_markers",
#         inputs_ui = plotthis_DotPlotInputsUI,
#         output_ui = plotthis_DotPlotOutputUI,
#         server_fn = plotthis_DotPlotServer,
#         defaults = list("x.data" = "gene", "y.data" = "cell_type",
#                         "size.by" = "pct_expressed", "fill.by" = "avg_expression")
#     ),
#     dumbbell = list(
#         label = "Dumbbell Plot", dataset = "example_school_earnings",
#         inputs_ui = dumbbellPlotInputsUI,
#         output_ui = dumbbellPlotOutputUI,
#         server_fn = dumbbellPlotServer,
#         defaults = list()
#     ),
#     histogram = list(
#         label = "Histogram", dataset = "example_demographics",
#         inputs_ui = plotthis_HistogramInputsUI,
#         output_ui = plotthis_HistogramOutputUI,
#         server_fn = plotthis_HistogramServer,
#         defaults = list("x.data" = "salary")
#     ),
#     line = list(
#         label = "Line Plot", dataset = "example_sales",
#         inputs_ui = linePlotInputsUI,
#         output_ui = linePlotOutputUI,
#         server_fn = linePlotServer,
#         defaults = list("x.value" = "product_line", "y.value" = "units")
#     ),
#     parallel = list(
#         label = "Parallel Coordinates", dataset = "example_sales",
#         inputs_ui = parallelCoordinatesPlotInputsUI,
#         output_ui = parallelCoordinatesPlotOutputUI,
#         server_fn = parallelCoordinatesPlotServer,
#         defaults = list("color.by" = "product_line")
#     ),
#     pie = list(
#         label = "Pie Plot", dataset = "sales_by_product",
#         inputs_ui = piePlotInputsUI,
#         output_ui = piePlotOutputUI,
#         server_fn = piePlotServer,
#         defaults = list("labels" = "product_line", "values" = "revenue")
#     ),
#     radar = list(
#         label = "Radar Plot", dataset = "example_skills",
#         inputs_ui = radarPlotInputsUI,
#         output_ui = radarPlotOutputUI,
#         server_fn = radarPlotServer,
#         defaults = list("theta" = "category", "r" = "value", "group" = "player")
#     ),
#     scatter = list(
#         label = "Scatter Plot", dataset = "example_sales",
#         inputs_ui = dittoViz_scatterPlotInputsUI,
#         output_ui = dittoViz_scatterPlotOutputUI,
#         server_fn = dittoViz_scatterPlotServer,
#         defaults = list("x.by" = "revenue", "y.by" = "units",
#                         "color.by" = "product_line")
#     ),
#     splitbar = list(
#         label = "Split Bar Plot", dataset = "example_bar",
#         inputs_ui = plotthis_SplitBarPlotInputsUI,
#         output_ui = plotthis_SplitBarPlotOutputUI,
#         server_fn = plotthis_SplitBarPlotServer,
#         defaults = list("x.data" = "Score", "y.data" = "Group")
#     ),
#     ternary = list(
#         label = "Ternary Plot", dataset = "example_roles",
#         inputs_ui = ternaryPlotInputsUI,
#         output_ui = ternaryPlotOutputUI,
#         server_fn = ternaryPlotServer,
#         defaults = list("a" = "journalist", "b" = "developer",
#                         "c" = "designer", "group" = "team")
#     ),
#     violin = list(
#         label = "Violin Plot", dataset = "example_demographics",
#         inputs_ui = plotthis_ViolinPlotInputsUI,
#         output_ui = plotthis_ViolinPlotOutputUI,
#         server_fn = plotthis_ViolinPlotServer,
#         defaults = list("x.data" = "department", "y.data" = "salary")
#     ),
#     yplot = list(
#         label = "yPlot", dataset = "example_demographics",
#         inputs_ui = dittoViz_yPlotInputsUI,
#         output_ui = dittoViz_yPlotOutputUI,
#         server_fn = dittoViz_yPlotServer,
#         defaults = list("var" = "salary", "group.by" = "department")
#     )
# )

# module_choices <- stats::setNames(
#     names(module_registry),
#     vapply(module_registry, function(m) m$label, character(1))
# )