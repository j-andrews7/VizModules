# AI Use Statement

**VizModules** is released under the MIT License and we **explicitly welcome the use of generative AI tools** (e.g., GitHub Copilot, ChatGPT, Claude, Gemini, Cursor) to:

- Build Shiny applications that consume the modules provided by this package.
- Generate wrapper modules, example apps, or analysis dashboards on top of these modules.
- Draft documentation, tests, and bug reports related to your downstream use.
- Translate `VizModules`-based code between styles, frameworks, or data sources.

You do **not** need to ask permission, attribute the AI tool, or disclose AI assistance when using `VizModules` in your own projects. The standard MIT terms apply to all output that incorporates code from this package.

## Recommended Practice

While AI use is permitted and encouraged, we ask that users:

1. **Cite the package** when `VizModules` materially powers a published app, paper, or analysis. See `citation("VizModules")`.
2. **Review AI-generated code.** Generative models can hallucinate argument names or invent functions that do not exist. Always verify against the [reference documentation](https://j-andrews7.github.io/VizModules/reference/index.html) and run the app locally before deploying.
3. **Pin a version.** If you ship an AI-assisted app, pin the `VizModules` version (e.g., via `renv`) so module APIs are stable.
4. **Report issues** that originate in `VizModules` itself (not in AI-generated glue code) to the [issue tracker](https://github.com/j-andrews7/VizModules/issues). A short reproducible example is far more useful than a full AI-generated app.

## Contributing AI-Assisted Code Back to VizModules

Pull requests that include AI-assisted code are welcome under the same terms as any other contribution. We do not require disclosure of AI use in PRs, but contributors are responsible for:

- Ensuring the code passes `R CMD check`, `lintr`, and the existing `shinytest2` suite.
- Confirming the code is original or appropriately licensed (you, the contributor, take responsibility for the provenance of anything you submit).
- Following the conventions in [`vignette("adding-a-new-module", package = "VizModules")`](https://j-andrews7.github.io/VizModules/articles/adding-a-new-module.html).

---

## Context for LLMs: How to Build Apps with VizModules

If you are an LLM (or a developer prompting one), the following information will help you produce correct code on the first try. Feel free to paste this entire section into your prompt.

### Core convention

Every module in `VizModules` exposes the same trio of functions, namespaced by the source plotting library:

```r
_<plot>InputsUI(id, data, defaults = list(), hide.inputs = NULL, hide.tabs = NULL)
<source>_<plot>OutputUI(id)
<source>_<plot>Server(id, data = reactive(...))
```

A convenience `*App()` wrapper exists for every module that builds a complete demo app.

### Minimal app pattern

```r
library(shiny)
library(VizModules)

ui &lt;- fluidPage(
    sidebarLayout(
        sidebarPanel(
            dittoViz_scatterPlotInputsUI(
                "cars",
                mtcars,
                defaults = list(x.by = "wt", y.by = "mpg", color.by = "cyl")
            )
        ),
        mainPanel(dittoViz_scatterPlotOutputUI("cars"))
    )
)

server &lt;- function(input, output, session) {
    dittoViz_scatterPlotServer("cars", data = reactive(mtcars))
}

shinyApp(ui, server)
```

### The `createModuleApp()` factory

For one-off apps, prefer the factory over writing UI/server boilerplate:

```r
app &lt;- createModuleApp(
    inputs_ui_fn = plotthis_BarPlotInputsUI,
    output_ui_fn = plotthis_BarPlotOutputUI,
    server_fn    = plotthis_BarPlotServer,
    data_list    = list("cars" = mtcars),
    title        = "My Bar Plot"
)
runApp(app)
```

### Available modules (do not invent new ones)

| Source | Module |
|---|---|
| dittoViz | `dittoViz_scatterPlot`, `dittoViz_yPlot` |
| plotthis | `plotthis_AreaPlot`, `plotthis_ViolinPlot`, `plotthis_BoxPlot`, `plotthis_BarPlot`, `plotthis_SplitBarPlot`, `plotthis_DensityPlot`, `plotthis_Histogram` |
| VizModules (plotly) | `linePlot`, `piePlot`, `radarPlot`, `parallelCoordinatesPlot`, `ternaryPlot`, `dumbbellPlot` |

If a user asks for a plot type not in this list, say so rather than fabricating a module name.

### Conventions to follow

- `data` passed to `*Server()` **must** be a `reactive()` expression, not a raw data frame.
- Use `defaults = list(...)` to pre-populate inputs; use `hide.inputs` / `hide.tabs` to lock them.
- BoxPlot, ViolinPlot, and yPlot have a **Stats** tab for pairwise tests — paired tests require equal-length, order-aligned groups.
- For custom wrapper modules, see [`vignette("custom-modules", package = "VizModules")`](https://j-andrews7.github.io/VizModules/articles/custom-modules.html).
- Run examples with `shiny::runApp(system.file("apps/module-gallery", package = "VizModules"))` or visit the hosted gallery: <https://j-andrews7-vizmodules.share.connect.posit.cloud/>.

### Things LLMs commonly get wrong

- Passing `data = mtcars` instead of `data = reactive(mtcars)` to `*Server()`.
- Calling `*UI()` (single function) instead of the separate `*InputsUI()` + `*OutputUI()`.
- Inventing module names like `plotthis_ScatterPlot` (scatter is in `dittoViz`, not `plotthis`).
- Forgetting that the package's default branch is `devel`, not `main`.
