"""Server logic for the linePlot Shiny module (Python).

Mirrors the logic from R/linePlot_module_server.R and R/linePlot.R using
Python Shiny (shiny for Python) and Plotly.

The public plotting function is ``linePlotPX``, which is the Python equivalent
of ``linePlot()`` in R. All parameter names match the R version (with dots
replaced by underscores, which is the Python convention).

Usage
-----
    from linePlot_module_server import line_plot_server

    # In app server:
    def server(input, output, session):
        data = reactive.calc(lambda: my_dataframe)
        line_plot_server("myPlot", data=data)
"""

from __future__ import annotations

import math
import warnings
from typing import Any, Callable, Dict, List, Optional, Sequence, Union

import numpy as np
import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots
from shiny import module, reactive, render, req, ui
from shinywidgets import render_widget


# ---------------------------------------------------------------------------
# Public module server function
# ---------------------------------------------------------------------------


@module.server
def line_plot_server(
    input,
    output,
    session,
    data: Callable[[], pd.DataFrame],
    hide_inputs: Optional[List[str]] = None,
    hide_tabs: Optional[List[str]] = None,
) -> None:
    """Server logic for the linePlot module.

    Mirrors ``linePlotServer()`` in R. Call this inside your app's server
    function with an ``id`` that matches the ``id`` used in
    ``line_plot_inputs_ui()`` and ``line_plot_output_ui()``.

    Parameters
    ----------
    data : callable
        A ``reactive.calc`` (or any zero-argument callable) that returns the
        ``pd.DataFrame`` to plot.
    hide_inputs : list of str, optional
        Input IDs to hide on startup. The inputs are still initialised and
        their values passed to ``linePlotPX``; they are simply not visible.
    hide_tabs : list of str, optional
        Tab names to hide on startup (e.g. ``["Facet", "Lines"]``).
    """

    # ------------------------------------------------------------------
    # Reactive: determine colour-palette groups
    # ------------------------------------------------------------------

    @reactive.calc
    def palette_groups() -> List[str]:
        """Compute the list of groups that need distinct colours.

        Mirrors the ``palette_groups`` reactive in R.
        """
        df = data()
        if df is None or df.empty:
            return []

        x_vals: List[str] = list(input.x_value())
        y_vals: List[str] = list(input.y_value())
        group_col: str = input.group_by()
        multi_axis = (len(x_vals) > 1) != (len(y_vals) > 1)  # xor

        if multi_axis:
            if len(x_vals) > 1:
                return x_vals
            if len(y_vals) > 1:
                return y_vals

        if group_col and group_col in df.columns:
            return df[group_col].dropna().unique().tolist()

        if x_vals:
            return [x_vals[0]]
        if y_vals:
            return [y_vals[0]]

        return []

    # ------------------------------------------------------------------
    # Rendered UI: error-bar inputs (show/hide based on X selection)
    # ------------------------------------------------------------------

    @render.ui
    def error_bar_inputs():
        """Render error-bar inputs only when applicable.

        Mirrors the ``observeEvent(input$x.value, ...)`` hide/show logic in R.
        Error bars are only available when X is a single categorical column.
        """
        x_vals = list(input.x_value())
        df = data()

        show_error_bar = (
            len(x_vals) == 1
            and x_vals[0] in df.columns
            and not pd.api.types.is_numeric_dtype(df[x_vals[0]])
        )

        if not show_error_bar:
            return ui.TagList()

        return ui.TagList(
            ui.input_switch("errorBar", "Error Bars:", value=True),
            ui.input_numeric("errorBarWidth", "Error Bar Width", value=1, min=0.1),
            ui.input_text("errorBarColour", "Error Bar Colour", value="#000000"),
        )

    # ------------------------------------------------------------------
    # Rendered UI: palette / colour picker
    # ------------------------------------------------------------------

    @render.ui
    def palette_selection():
        """Render a simplified palette selector for the active groups.

        The R version uses a custom ``multiColorPicker`` widget. Here we
        provide a select-based colour palette chooser as the closest Python
        Shiny equivalent.
        """
        groups = palette_groups()
        if not groups:
            return None

        palette_choices = [
            "Set1", "Set2", "Set3",
            "Pastel1", "Pastel2",
            "Dark2", "Paired",
            "viridis", "magma", "inferno", "plasma",
        ]
        return ui.input_select(
            "palette_colours",
            "Plot colors",
            choices=palette_choices,
            selected="Set2",
        )

    # ------------------------------------------------------------------
    # Reset: restore all inputs to their defaults
    # ------------------------------------------------------------------

    @reactive.effect
    @reactive.event(input.reset)
    def _handle_reset():
        """Reset all inputs to their initial defaults.

        Mirrors the ``observeEvent(input$reset, ...)`` block in R.
        """
        df = data()
        cols = list(df.columns) if df is not None else []

        ui.update_select("x_value", selected=[cols[0]] if cols else [])
        ui.update_select(
            "y_value", selected=[cols[1]] if len(cols) > 1 else ([cols[0]] if cols else [])
        )
        ui.update_select("plot_type", selected="lines")
        ui.update_select("line_type", selected="solid")
        ui.update_switch("order_by", value=False)
        ui.update_switch("flip_x", value=False)
        ui.update_switch("flip_y", value=False)
        ui.update_select("group_by", selected="")
        ui.update_select("facet_by", selected="")
        ui.update_select("facet_scales", selected="fixed")
        ui.update_select("x_adjustment", selected="")
        ui.update_select("y_adjustment", selected="")

        # Axes
        ui.update_select("title_font_family", selected="Arial")
        ui.update_text("text_colour", value="#000000")
        ui.update_numeric("axis_title_font_size", value=18)
        ui.update_text("axis_title_font_color", value="#000000")
        ui.update_select("axis_title_font_family", selected="Arial")
        ui.update_checkbox("axis_showline", value=True)
        ui.update_checkbox("axis_mirror", value=True)
        ui.update_checkbox("show_grid_x", value=True)
        ui.update_checkbox("show_grid_y", value=True)
        ui.update_text("axis_linecolor", value="black")
        ui.update_numeric("axis_linewidth", value=0.5)
        ui.update_numeric("axis_tickfont_size", value=12)
        ui.update_text("axis_tickfont_color", value="black")
        ui.update_select("axis_tickfont_family", selected="Arial")
        ui.update_numeric("axis_tickangle_x", value=0)
        ui.update_numeric("axis_tickangle_y", value=0)
        ui.update_select("axis_ticks", selected="outside")
        ui.update_text("axis_tickcolor", value="black")
        ui.update_numeric("axis_ticklen", value=5)
        ui.update_numeric("axis_tickwidth", value=1)

        # Reference lines
        ui.update_text("hline_intercepts", value="")
        ui.update_text("hline_colors", value="#000000")
        ui.update_text("hline_widths", value="1")
        ui.update_text("hline_linetypes", value="dashed")
        ui.update_text("hline_opacities", value="1")
        ui.update_text("vline_intercepts", value="")
        ui.update_text("vline_colors", value="#000000")
        ui.update_text("vline_widths", value="1")
        ui.update_text("vline_linetypes", value="dashed")
        ui.update_text("vline_opacities", value="1")
        ui.update_text("abline_slopes", value="")
        ui.update_text("abline_intercepts", value="")
        ui.update_text("abline_colors", value="#000000")
        ui.update_text("abline_widths", value="1")
        ui.update_text("abline_linetypes", value="dashed")
        ui.update_text("abline_opacities", value="1")

    # ------------------------------------------------------------------
    # Reactive: generate the linePlot figure
    # ------------------------------------------------------------------

    @reactive.calc
    def generate_line_plot() -> go.Figure:
        """Build and return the plotly linePlot figure.

        Mirrors the ``generate_linePlot`` reactive in R. Respects the
        auto-update / manual-update toggle via ``_get_isolated_value``.
        """
        auto_update: bool = input.auto_update()

        # If auto-update is off, depend on the Update button instead of
        # individual inputs changing (mirrors setup_auto_update_logic in R).
        if not auto_update:
            input.update()

        def get(fn: Callable) -> Any:
            """Return fn() directly (reactive) or isolated (manual update)."""
            if auto_update:
                return fn()
            with reactive.isolate():
                return fn()

        df = data()
        x_input: List[str] = list(get(input.x_value))
        y_input: List[str] = list(get(input.y_value))

        # Resolve colour palette
        palette_name: str = _safe_input(input, "palette_colours", "Set2")
        palette_selection: List[str] = _get_plotly_palette(palette_name)

        # Determine grouping / legend visibility
        group_by_col: str = get(input.group_by)
        show_legend = False
        colour_group_by: Any = palette_selection[0] if palette_selection else "#000000"

        if group_by_col and len(x_input) == 1 and len(y_input) == 1:
            colour_group_by = group_by_col
            show_legend = True
        elif len(x_input) > 1 or len(y_input) > 1:
            show_legend = True

        # Axis ordering
        order_by = x_input if not get(input.order_by) else y_input

        # Sort data
        sort_col = order_by[0] if order_by and order_by[0] in df.columns else None
        if sort_col and pd.api.types.is_numeric_dtype(df[sort_col]):
            df = df.sort_values(by=sort_col)

        # Axis titles
        x_title = x_input[0] if len(x_input) == 1 else "Value"
        y_title = y_input[0] if len(y_input) == 1 else "Value"

        # Axis adjustments
        y_adjustment: Optional[str] = get(input.y_adjustment) or None
        x_adjustment: Optional[str] = get(input.x_adjustment) or None

        # Only apply numeric transformations when all columns are numeric
        if x_adjustment and not all(
            pd.api.types.is_numeric_dtype(df[c]) for c in x_input if c in df.columns
        ):
            x_adjustment = None
        if y_adjustment and not all(
            pd.api.types.is_numeric_dtype(df[c]) for c in y_input if c in df.columns
        ):
            y_adjustment = None

        facet_by_val: str = get(input.facet_by)
        facet_by: Optional[str] = facet_by_val if facet_by_val else None

        # Error-bar inputs (may not exist if hidden)
        error_bar: bool = _safe_input(input, "errorBar", False)
        error_colour: str = _safe_input(input, "errorBarColour", "#000000")
        error_width: float = _safe_input(input, "errorBarWidth", 1.0)

        fig = linePlotPX(
            data=df,
            x=x_input,
            y=y_input,
            plot_mode=get(input.plot_type),
            line_type=get(input.line_type),
            colour_group_by=colour_group_by,
            palette_selection=palette_selection,
            show_legend=show_legend,
            facet_by=facet_by,
            facet_scales=get(input.facet_scales),
            order_by=order_by,
            axis_showline=get(input.axis_showline),
            axis_mirror=get(input.axis_mirror),
            axis_linecolor=get(input.axis_linecolor),
            axis_linewidth=get(input.axis_linewidth),
            axis_tickfont_size=get(input.axis_tickfont_size),
            axis_tickfont_color=get(input.axis_tickfont_color),
            axis_tickfont_family=get(input.axis_tickfont_family),
            axis_tickangle_x=get(input.axis_tickangle_x),
            axis_tickangle_y=get(input.axis_tickangle_y),
            axis_ticks=get(input.axis_ticks),
            axis_tickcolor=get(input.axis_tickcolor),
            axis_ticklen=get(input.axis_ticklen),
            axis_tickwidth=get(input.axis_tickwidth),
            show_grid_x=get(input.show_grid_x),
            show_grid_y=get(input.show_grid_y),
            title_font_size=get(input.axis_title_font_size),
            title_font_family=get(input.title_font_family),
            title_text_color=get(input.text_colour),
            x_title=x_title,
            y_title=y_title,
            flip_x=get(input.flip_x),
            flip_y=get(input.flip_y),
            x_adjustment=x_adjustment,
            y_adjustment=y_adjustment,
            error_colour=error_colour,
            error_width=error_width,
            error_bar=error_bar,
        )

        # Add reference lines
        fig = _add_reference_lines(
            fig,
            hline_intercepts=get(input.hline_intercepts),
            hline_colors=get(input.hline_colors),
            hline_widths=get(input.hline_widths),
            hline_linetypes=get(input.hline_linetypes),
            hline_opacities=get(input.hline_opacities),
            vline_intercepts=get(input.vline_intercepts),
            vline_colors=get(input.vline_colors),
            vline_widths=get(input.vline_widths),
            vline_linetypes=get(input.vline_linetypes),
            vline_opacities=get(input.vline_opacities),
            abline_slopes=get(input.abline_slopes),
            abline_intercepts=get(input.abline_intercepts),
            abline_colors=get(input.abline_colors),
            abline_widths=get(input.abline_widths),
            abline_linetypes=get(input.abline_linetypes),
            abline_opacities=get(input.abline_opacities),
        )

        return fig

    # ------------------------------------------------------------------
    # Render: plotly output
    # ------------------------------------------------------------------

    @render_widget
    def linePlot() -> go.Figure:
        """Render the linePlot widget.

        Mirrors ``output$linePlot <- renderPlotly({...})`` in R. Validates
        inputs and shows an informative empty plot on error conditions.
        """
        df = data()
        x_input: List[str] = list(input.x_value())
        y_input: List[str] = list(input.y_value())

        # Validation flags (mirrors error-check section in R server)
        x_is_cat = (
            len(x_input) == 1
            and x_input[0] in df.columns
            and not pd.api.types.is_numeric_dtype(df[x_input[0]])
        )
        y_is_cat = (
            len(y_input) == 1
            and y_input[0] in df.columns
            and not pd.api.types.is_numeric_dtype(df[y_input[0]])
        )
        x_empty = len(x_input) == 0
        y_empty = len(y_input) == 0
        multi_axis = (len(x_input) > 1) != (len(y_input) > 1)
        dual_multi_axis = len(x_input) > 1 and len(y_input) > 1
        x_pure = _is_pure_type(x_input, df)
        y_pure = _is_pure_type(y_input, df)

        return_empty = False
        messages: List[str] = []

        if x_is_cat and y_is_cat:
            return_empty = True
            messages.append("X and Y categories cannot both be discrete data types")
        elif x_empty or y_empty:
            return_empty = True
            messages.append(
                "Both X and Y variable inputs must not be empty. "
                "Please select a variable input."
            )
        elif not x_pure or not y_pure:
            return_empty = True
            messages.append(
                "Can't have a discrete and non-discrete data input on the same axis."
            )
        elif dual_multi_axis:
            return_empty = True
            messages.append(
                "You cannot have multiple inputs for both X and Y inputs simultaneously"
            )
        elif multi_axis and input.group_by():
            return_empty = True
            messages.append(
                "You cannot have multiple inputs on x and y axis and group by at the same time"
            )

        if return_empty:
            return _empty_plot(text="\n".join(messages))

        fig = generate_line_plot()
        fig = fig.update_layout(
            margin=dict(t=100, l=90, r=90, b=100, autoexpand=True)
        )
        return fig

    # ------------------------------------------------------------------
    # Download: interactive HTML plot
    # ------------------------------------------------------------------

    @render.download(filename="linePlot.html")
    def download_interactive():
        """Download the current plot as an interactive HTML file.

        Mirrors ``.create_plot_download_handler()`` in R.
        """
        fig = generate_line_plot()
        return fig.to_html(full_html=True, include_plotlyjs="cdn")


# ---------------------------------------------------------------------------
# Public plotting function
# ---------------------------------------------------------------------------


def linePlotPX(
    data: pd.DataFrame,
    x: List[str],
    y: List[str],
    plot_mode: str,
    line_type: str,
    colour_group_by: Any,
    palette_selection: List[str],
    show_legend: bool,
    facet_by: Optional[str] = None,
    facet_scales: str = "fixed",
    order_by: Optional[List[str]] = None,
    axis_showline: bool = True,
    axis_mirror: bool = True,
    axis_linecolor: str = "black",
    axis_linewidth: float = 0.5,
    axis_tickfont_size: float = 12,
    axis_tickfont_color: str = "black",
    axis_tickfont_family: str = "Arial",
    axis_tickangle_x: float = 0,
    axis_tickangle_y: float = 0,
    axis_ticks: str = "outside",
    axis_tickcolor: str = "black",
    axis_ticklen: float = 5,
    axis_tickwidth: float = 1,
    show_grid_x: bool = True,
    show_grid_y: bool = True,
    title_text: str = "",
    title_font_size: float = 14,
    title_font_family: str = "Arial",
    title_text_color: str = "black",
    y_title: Optional[str] = None,
    x_title: Optional[str] = None,
    flip_x: bool = False,
    flip_y: bool = False,
    x_adjustment: Optional[str] = None,
    y_adjustment: Optional[str] = None,
    color_adjustment: Optional[str] = None,
    error_colour: Optional[str] = None,
    error_width: Optional[float] = None,
    error_bar: bool = False,
) -> go.Figure:
    """Create an interactive line plot using Plotly.

    Python equivalent of ``linePlot()`` in R. All parameter names match the R
    version (dots replaced by underscores). Vectors ``c()`` in R are passed as
    ``[]`` lists in Python.

    Parameters
    ----------
    data : pd.DataFrame
        Data frame containing the data to plot.
    x : list of str
        Column name(s) for the x-axis. Multiple columns create separate traces.
    y : list of str
        Column name(s) for the y-axis. Multiple columns create separate traces.
    plot_mode : str
        Plotly mode: ``"lines"``, ``"markers"``, or ``"lines+markers"``.
    line_type : str
        Line dash style: ``"solid"``, ``"dot"``, ``"dash"``, ``"longdash"``,
        ``"dashdot"``, or ``"longdashdot"``.
    colour_group_by : str or list
        Column name to group lines by colour. Pass a column-name string when
        grouping by a categorical column; pass a hex colour string (e.g.
        ``"#1B9E77"``) to apply a single colour to all traces.
    palette_selection : list of str
        Hex colour strings used to assign colours to groups / traces.
    show_legend : bool
        Whether to display the legend.
    facet_by : str, optional
        Column name to facet plots by. Creates subplots for each unique value.
    facet_scales : str
        Controls axis scaling across facets: ``"fixed"``, ``"free"``,
        ``"free_x"``, or ``"free_y"``. Default ``"fixed"``.
    order_by : list of str, optional
        Column name(s) used to sort data before plotting. Default ``None``
        (uses ``x``).
    axis_showline : bool
        Show axis border lines. Default ``True``.
    axis_mirror : bool
        Mirror axis lines on the opposite side. Default ``True``.
    axis_linecolor : str
        Colour for axis lines. Default ``"black"``.
    axis_linewidth : float
        Width of axis lines in pixels. Default ``0.5``.
    axis_tickfont_size : float
        Font size for axis tick labels. Default ``12``.
    axis_tickfont_color : str
        Colour for axis tick labels. Default ``"black"``.
    axis_tickfont_family : str
        Font family for axis tick labels. Default ``"Arial"``.
    axis_tickangle_x : float
        Rotation angle for x-axis tick labels (degrees). Default ``0``.
    axis_tickangle_y : float
        Rotation angle for y-axis tick labels (degrees). Default ``0``.
    axis_ticks : str
        Position of tick marks: ``"outside"``, ``"inside"``, or ``""``.
        Default ``"outside"``.
    axis_tickcolor : str
        Colour for tick marks. Default ``"black"``.
    axis_ticklen : float
        Length of tick marks in pixels. Default ``5``.
    axis_tickwidth : float
        Width of tick marks in pixels. Default ``1``.
    show_grid_x : bool
        Show x-axis gridlines. Default ``True``.
    show_grid_y : bool
        Show y-axis gridlines. Default ``True``.
    title_text : str
        Main title text for the plot. Default ``""``.
    title_font_size : float
        Font size for the plot title. Default ``14``.
    title_font_family : str
        Font family for the plot title. Default ``"Arial"``.
    title_text_color : str
        Colour for the plot title text. Default ``"black"``.
    y_title : str, optional
        Y-axis label. Auto-generated from column name if ``None``.
    x_title : str, optional
        X-axis label. Auto-generated from column name if ``None``.
    flip_x : bool
        Reverse the x-axis direction. Default ``False``.
    flip_y : bool
        Reverse the y-axis direction. Default ``False``.
    x_adjustment : str, optional
        Transformation to apply to x values. Allowed: ``"log2"``, ``"log"``,
        ``"log10"``, ``"neg_log10"``, ``"log1p"``, ``"abs"``, ``"sqrt"``.
    y_adjustment : str, optional
        Transformation to apply to y values. Same options as ``x_adjustment``.
    color_adjustment : str, optional
        Transformation to apply to the colour grouping variable. Same options.
    error_colour : str, optional
        Hex colour for error bars.
    error_width : float, optional
        Thickness of error-bar whiskers.
    error_bar : bool
        Whether to show error bars (mean ± SD) when X is categorical and Y is
        a single numeric column. Default ``False``.

    Returns
    -------
    go.Figure
        Interactive plotly figure.
    """
    # Identify categorical columns (mirrors cat.choices in R)
    cat_cols = [
        col
        for col in data.columns
        if not pd.api.types.is_numeric_dtype(data[col])
    ]

    # Apply axis value adjustments
    if x_adjustment:
        data = _adjust_column_values(data, x_cols=x, adj_fun=x_adjustment)
        x = [
            f"{c}.adj" if f"{c}.adj" in data.columns else c
            for c in x
        ]

    if y_adjustment:
        data = _adjust_column_values(data, y_cols=y, adj_fun=y_adjustment)
        y = [
            f"{c}.adj" if f"{c}.adj" in data.columns else c
            for c in y
        ]

    # Compute SD/mean when X is a single categorical column (for error bars)
    if len(x) == 1 and x[0] in cat_cols:
        group_vars = [x[0]]
        if facet_by and facet_by in data.columns:
            group_vars = [facet_by, x[0]]
        agg_dict: Dict[str, Any] = {}
        for col in y:
            agg_dict[col] = pd.NamedAgg(column=col, aggfunc="mean")
        grouped = data.groupby(group_vars, as_index=False).agg(**agg_dict)
        if len(y) == 1:
            grouped["sd_y"] = (
                data.groupby(group_vars, as_index=False)[y[0]]
                .std(ddof=1)[y[0]]
                .values
            )
        data = grouped
    else:
        data = data.copy()
        data["sd_y"] = float("nan")

    # Determine sort column
    order_cols = order_by if order_by else x
    sort_col = order_cols[0] if order_cols and order_cols[0] in data.columns else None
    if sort_col and pd.api.types.is_numeric_dtype(data[sort_col]):
        data = data.sort_values(by=sort_col)

    multi_axis = (len(x) > 1) != (len(y) > 1)  # xor

    # Build base axis style dicts (mirrors xaxis_style in R)
    xaxis_style = dict(
        showline=axis_showline,
        mirror=axis_mirror,
        linecolor=axis_linecolor,
        linewidth=axis_linewidth,
        tickfont=dict(
            size=axis_tickfont_size,
            color=axis_tickfont_color,
            family=axis_tickfont_family,
        ),
        tickangle=axis_tickangle_x,
        ticks=axis_ticks,
        tickcolor=axis_tickcolor,
        ticklen=axis_ticklen,
        tickwidth=axis_tickwidth,
        title=x_title,
        autorange=True,
        showgrid=show_grid_x,
    )

    yaxis_style = {**xaxis_style}
    yaxis_style["tickangle"] = axis_tickangle_y
    yaxis_style["title"] = y_title
    yaxis_style["showgrid"] = show_grid_y

    if flip_x:
        xaxis_style["autorange"] = "reversed"
    if flip_y:
        yaxis_style["autorange"] = "reversed"

    # Clear per-axis titles when faceting (added as annotations instead)
    if facet_by and facet_by != "":
        xaxis_style["title"] = None
        yaxis_style["title"] = None

    # ------------------------------------------------------------------
    # Build figure
    # ------------------------------------------------------------------

    if facet_by and facet_by != "" and not multi_axis:
        facet_levels = data[facet_by].unique().tolist()
        share_x, share_y = _resolve_facet_sharing(facet_scales)
        plots = []
        for level in facet_levels:
            facet_data = data[data[facet_by] == level].copy()
            sub_fig = _build_single_trace(
                facet_data, x, y, plot_mode, line_type,
                colour_group_by, palette_selection, show_legend,
                error_bar, error_colour, error_width,
            )
            plots.append(sub_fig)

        fig = _combine_subplots(plots, share_x=share_x, share_y=share_y)
        annotations = _build_facet_annotations(
            facet_levels, x_title=x_title, y_title=y_title
        )
        fig.update_layout(annotations=annotations)

    elif facet_by and facet_by != "" and multi_axis:
        facet_levels = data[facet_by].unique().tolist()
        share_x, share_y = _resolve_facet_sharing(facet_scales)
        plots = []
        first_facet = True
        for level in facet_levels:
            facet_data = data[data[facet_by] == level].copy()
            sub_fig = go.Figure()
            _add_multi_axis_traces(
                sub_fig, facet_data, x, y, order_cols,
                plot_mode, line_type, palette_selection,
                show_legend=first_facet,
            )
            plots.append(sub_fig)
            first_facet = False

        fig = _combine_subplots(plots, share_x=share_x, share_y=share_y)
        annotations = _build_facet_annotations(
            facet_levels, x_title=x_title, y_title=y_title
        )
        fig.update_layout(annotations=annotations)

    elif multi_axis:
        fig = go.Figure()
        _add_multi_axis_traces(
            fig, data, x, y, order_cols,
            plot_mode, line_type, palette_selection,
            show_legend=True,
        )

    else:
        fig = _build_single_trace(
            data, x, y, plot_mode, line_type,
            colour_group_by, palette_selection, show_legend,
            error_bar, error_colour, error_width,
        )

    # Apply layout
    fig.update_layout(
        title=dict(
            text=title_text,
            font=dict(
                size=title_font_size,
                family=title_font_family,
                color=title_text_color,
            ),
            x=0.47,
            xanchor="center",
            y=0.95,
            yanchor="top",
            pad=dict(t=20),
        ),
        margin=dict(t=70),
        showlegend=True,
        xaxis=xaxis_style,
        yaxis=yaxis_style,
    )

    # Apply axis styling to all subplot axes
    _apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

    return fig


# ---------------------------------------------------------------------------
# Helper / internal functions  (kept at the bottom per convention)
# ---------------------------------------------------------------------------


def _build_single_trace(
    data: pd.DataFrame,
    x: List[str],
    y: List[str],
    plot_mode: str,
    line_type: str,
    colour_group_by: Any,
    palette_selection: List[str],
    show_legend: bool,
    error_bar: bool,
    error_colour: Optional[str],
    error_width: Optional[float],
) -> go.Figure:
    """Build a single-panel plotly figure with one set of x/y traces.

    Mirrors the single-axis branch of ``linePlot()`` in R.
    """
    fig = go.Figure()
    color_col = colour_group_by if isinstance(colour_group_by, str) and colour_group_by in data.columns else None

    if color_col:
        groups = data[color_col].dropna().unique().tolist()
        for i, grp in enumerate(groups):
            grp_data = data[data[color_col] == grp]
            color = palette_selection[i % len(palette_selection)] if palette_selection else "#000000"
            trace_kw: Dict[str, Any] = dict(
                x=grp_data[x[0]],
                y=grp_data[y[0]],
                name=str(grp),
                mode=plot_mode,
                marker=dict(color=color),
                showlegend=show_legend,
            )
            if plot_mode in ("lines", "lines+markers"):
                trace_kw["line"] = dict(dash=line_type, color=color)
            if (
                error_bar
                and "sd_y" in grp_data.columns
                and grp_data["sd_y"].notna().any()
            ):
                trace_kw["error_y"] = dict(
                    type="data",
                    array=grp_data["sd_y"].tolist(),
                    color=error_colour or "#000000",
                    thickness=error_width if error_width else 1,
                    visible=True,
                )
            fig.add_trace(go.Scatter(**trace_kw))
    else:
        # No grouping – single trace with flat colour
        color = (
            colour_group_by
            if isinstance(colour_group_by, str) and colour_group_by.startswith("#")
            else (palette_selection[0] if palette_selection else "#000000")
        )
        trace_kw = dict(
            x=data[x[0]],
            y=data[y[0]],
            mode=plot_mode,
            marker=dict(color=color),
            showlegend=show_legend,
        )
        if plot_mode in ("lines", "lines+markers"):
            trace_kw["line"] = dict(dash=line_type, color=color)
        if (
            error_bar
            and "sd_y" in data.columns
            and data["sd_y"].notna().any()
        ):
            trace_kw["error_y"] = dict(
                type="data",
                array=data["sd_y"].tolist(),
                color=error_colour or "#000000",
                thickness=error_width if error_width else 1,
                visible=True,
            )
        fig.add_trace(go.Scatter(**trace_kw))

    return fig


def _add_multi_axis_traces(
    fig: go.Figure,
    data: pd.DataFrame,
    x: List[str],
    y: List[str],
    order_cols: Optional[List[str]],
    plot_mode: str,
    line_type: str,
    palette_selection: List[str],
    show_legend: bool = True,
) -> None:
    """Add multiple traces to ``fig`` for multi-axis mode (many X or many Y).

    Mirrors ``.add_multi_axis_traces()`` in R. Mutates ``fig`` in-place.
    """
    sort_col = order_cols[0] if order_cols and order_cols[0] in data.columns else None
    if sort_col and pd.api.types.is_numeric_dtype(data[sort_col]):
        data = data.sort_values(by=sort_col)

    if len(x) > 1:
        # Multiple X columns, single Y
        for i, x_col in enumerate(x):
            color = palette_selection[i % len(palette_selection)] if palette_selection else "#000000"
            trace_kw: Dict[str, Any] = dict(
                x=data[x_col],
                y=data[y[0]],
                name=x_col,
                mode=plot_mode,
                marker=dict(color=color),
                showlegend=show_legend,
            )
            if plot_mode in ("lines", "lines+markers"):
                trace_kw["line"] = dict(dash=line_type, color=color)
            fig.add_trace(go.Scatter(**trace_kw))
    else:
        # Single X, multiple Y columns
        for i, y_col in enumerate(y):
            color = palette_selection[i % len(palette_selection)] if palette_selection else "#000000"
            trace_kw = dict(
                x=data[x[0]],
                y=data[y_col],
                name=y_col,
                mode=plot_mode,
                marker=dict(color=color),
                showlegend=show_legend,
            )
            if plot_mode in ("lines", "lines+markers"):
                trace_kw["line"] = dict(dash=line_type, color=color)
            fig.add_trace(go.Scatter(**trace_kw))


def _combine_subplots(
    figures: List[go.Figure],
    share_x: bool = True,
    share_y: bool = True,
) -> go.Figure:
    """Combine a list of single-panel figures into a subplot grid.

    Mirrors the ``subplot()`` calls in R.

    Parameters
    ----------
    figures : list of go.Figure
        Sub-figures to combine.
    share_x : bool
        Whether to share the x-axis across subplots.
    share_y : bool
        Whether to share the y-axis across subplots.

    Returns
    -------
    go.Figure
        Combined subplot figure.
    """
    n = len(figures)
    if n == 0:
        return go.Figure()

    combined = make_subplots(
        rows=1,
        cols=n,
        shared_xaxes=share_x,
        shared_yaxes=share_y,
        horizontal_spacing=0.05,
    )

    for col_idx, sub_fig in enumerate(figures, start=1):
        for trace in sub_fig.data:
            combined.add_trace(trace, row=1, col=col_idx)

    return combined


def _build_facet_annotations(
    facet_levels: List[Any],
    x_title: Optional[str] = None,
    y_title: Optional[str] = None,
) -> List[Dict[str, Any]]:
    """Build plotly annotations for subplot titles and shared axis labels.

    Mirrors ``.build_facet_annotations()`` in R.

    Parameters
    ----------
    facet_levels : list
        Unique values of the faceting variable.
    x_title : str, optional
        Shared x-axis label.
    y_title : str, optional
        Shared y-axis label.

    Returns
    -------
    list of dict
        Plotly annotation dicts.
    """
    n = len(facet_levels)
    annotations = []

    # Subplot title annotations
    for i, level in enumerate(facet_levels):
        x_pos = (i + 0.5) / n
        annotations.append(
            dict(
                text=str(level),
                x=x_pos,
                y=1.05,
                xref="paper",
                yref="paper",
                showarrow=False,
                font=dict(size=12),
            )
        )

    # Shared x-axis label
    if x_title:
        annotations.append(
            dict(
                text=x_title,
                x=0.5,
                y=-0.1,
                xref="paper",
                yref="paper",
                showarrow=False,
                font=dict(size=12),
            )
        )

    # Shared y-axis label
    if y_title:
        annotations.append(
            dict(
                text=y_title,
                x=-0.07,
                y=0.5,
                xref="paper",
                yref="paper",
                showarrow=False,
                textangle=-90,
                font=dict(size=12),
            )
        )

    return annotations


def _resolve_facet_sharing(facet_scales: str) -> tuple:
    """Convert a ``facet_scales`` string to (share_x, share_y) booleans.

    Mirrors ``.resolve_facet_sharing()`` in R.

    Parameters
    ----------
    facet_scales : str
        One of ``"fixed"``, ``"free"``, ``"free_x"``, ``"free_y"``.

    Returns
    -------
    tuple
        ``(share_x, share_y)``
    """
    mapping = {
        "fixed": (True, True),
        "free": (False, False),
        "free_x": (False, True),
        "free_y": (True, False),
    }
    return mapping.get(facet_scales, (True, True))


def _apply_subplot_axis_styling(
    fig: go.Figure,
    xaxis_style: Dict[str, Any],
    yaxis_style: Dict[str, Any],
) -> None:
    """Apply axis styling to all subplot axes in a plotly figure.

    Mirrors ``.apply_subplot_axis_styling()`` in R. Mutates ``fig`` in-place.

    Parameters
    ----------
    fig : go.Figure
        The plotly figure to update.
    xaxis_style : dict
        Axis style properties for x-axes.
    yaxis_style : dict
        Axis style properties for y-axes.
    """
    layout_dict = fig.to_dict().get("layout", {})

    xaxis_keys = [k for k in layout_dict if k.startswith("xaxis")]
    yaxis_keys = [k for k in layout_dict if k.startswith("yaxis")]

    if not xaxis_keys:
        xaxis_keys = ["xaxis"]
    if not yaxis_keys:
        yaxis_keys = ["yaxis"]

    updates: Dict[str, Any] = {}
    for key in xaxis_keys:
        updates[key] = xaxis_style
    for key in yaxis_keys:
        updates[key] = yaxis_style

    fig.update_layout(**updates)


def _add_reference_lines(
    fig: go.Figure,
    hline_intercepts: Optional[str] = None,
    hline_colors: Optional[str] = None,
    hline_widths: Optional[str] = None,
    hline_linetypes: Optional[str] = None,
    hline_opacities: Optional[str] = None,
    vline_intercepts: Optional[str] = None,
    vline_colors: Optional[str] = None,
    vline_widths: Optional[str] = None,
    vline_linetypes: Optional[str] = None,
    vline_opacities: Optional[str] = None,
    abline_slopes: Optional[str] = None,
    abline_intercepts: Optional[str] = None,
    abline_colors: Optional[str] = None,
    abline_widths: Optional[str] = None,
    abline_linetypes: Optional[str] = None,
    abline_opacities: Optional[str] = None,
) -> go.Figure:
    """Add horizontal, vertical, and diagonal reference lines to a figure.

    Mirrors ``.add_reference_lines()`` in R.

    Parameters
    ----------
    fig : go.Figure
        Target plotly figure.
    hline_intercepts : str, optional
        Comma-separated Y-intercept values for horizontal lines.
    hline_colors : str, optional
        Comma-separated hex colours for horizontal lines.
    hline_widths : str, optional
        Comma-separated widths for horizontal lines.
    hline_linetypes : str, optional
        Comma-separated dash styles for horizontal lines.
    hline_opacities : str, optional
        Comma-separated opacities (0–1) for horizontal lines.
    vline_intercepts : str, optional
        Comma-separated X-intercept values for vertical lines.
    vline_colors : str, optional
        Comma-separated hex colours for vertical lines.
    vline_widths : str, optional
        Comma-separated widths for vertical lines.
    vline_linetypes : str, optional
        Comma-separated dash styles for vertical lines.
    vline_opacities : str, optional
        Comma-separated opacities (0–1) for vertical lines.
    abline_slopes : str, optional
        Comma-separated slopes for diagonal lines.
    abline_intercepts : str, optional
        Comma-separated Y-intercepts for diagonal lines.
    abline_colors : str, optional
        Comma-separated hex colours for diagonal lines.
    abline_widths : str, optional
        Comma-separated widths for diagonal lines.
    abline_linetypes : str, optional
        Comma-separated dash styles for diagonal lines.
    abline_opacities : str, optional
        Comma-separated opacities (0–1) for diagonal lines.

    Returns
    -------
    go.Figure
        The figure with reference lines added as layout shapes.
    """
    shapes = list(fig.layout.shapes) if fig.layout.shapes else []

    # Horizontal lines
    h_intercepts = _parse_numeric_list(hline_intercepts)
    if h_intercepts:
        h_colors = _parse_str_list(hline_colors, "#000000")
        h_widths = _parse_numeric_list(hline_widths) or [1.0]
        h_linetypes = _string_to_linetypes(hline_linetypes)
        h_opacities = _parse_numeric_list(hline_opacities) or [1.0]
        for i, intercept in enumerate(h_intercepts):
            shapes.append(
                dict(
                    type="line",
                    xref="paper",
                    yref="y",
                    x0=0,
                    x1=1,
                    y0=intercept,
                    y1=intercept,
                    line=dict(
                        color=h_colors[i % len(h_colors)],
                        width=h_widths[i % len(h_widths)],
                        dash=h_linetypes[i % len(h_linetypes)],
                    ),
                    opacity=h_opacities[i % len(h_opacities)],
                )
            )

    # Vertical lines
    v_intercepts = _parse_numeric_list(vline_intercepts)
    if v_intercepts:
        v_colors = _parse_str_list(vline_colors, "#000000")
        v_widths = _parse_numeric_list(vline_widths) or [1.0]
        v_linetypes = _string_to_linetypes(vline_linetypes)
        v_opacities = _parse_numeric_list(vline_opacities) or [1.0]
        for i, intercept in enumerate(v_intercepts):
            shapes.append(
                dict(
                    type="line",
                    xref="x",
                    yref="paper",
                    x0=intercept,
                    x1=intercept,
                    y0=0,
                    y1=1,
                    line=dict(
                        color=v_colors[i % len(v_colors)],
                        width=v_widths[i % len(v_widths)],
                        dash=v_linetypes[i % len(v_linetypes)],
                    ),
                    opacity=v_opacities[i % len(v_opacities)],
                )
            )

    # Diagonal (ab) lines
    ab_slopes = _parse_numeric_list(abline_slopes)
    ab_intercepts_vals = _parse_numeric_list(abline_intercepts)
    if ab_slopes and ab_intercepts_vals:
        ab_colors = _parse_str_list(abline_colors, "#000000")
        ab_widths = _parse_numeric_list(abline_widths) or [1.0]
        ab_linetypes = _string_to_linetypes(abline_linetypes)
        ab_opacities = _parse_numeric_list(abline_opacities) or [1.0]
        # Represent ablines as annotations with arrows disabled
        for i, (slope, intercept) in enumerate(zip(ab_slopes, ab_intercepts_vals)):
            shapes.append(
                dict(
                    type="line",
                    xref="x",
                    yref="y",
                    x0=0,
                    y0=intercept,
                    x1=1,
                    y1=slope + intercept,
                    line=dict(
                        color=ab_colors[i % len(ab_colors)],
                        width=ab_widths[i % len(ab_widths)],
                        dash=ab_linetypes[i % len(ab_linetypes)],
                    ),
                    opacity=ab_opacities[i % len(ab_opacities)],
                )
            )

    fig.update_layout(shapes=shapes)
    return fig


def _empty_plot(text: Optional[str] = None) -> go.Figure:
    """Return an empty plotly figure with an optional message.

    Mirrors ``.empty_plot(plotly = TRUE)`` in R.

    Parameters
    ----------
    text : str, optional
        Message to display in the centre of the empty plot.

    Returns
    -------
    go.Figure
        Blank plotly figure.
    """
    fig = go.Figure()
    if text:
        fig.add_annotation(
            text=text,
            x=0.5,
            y=0.5,
            xref="paper",
            yref="paper",
            showarrow=False,
            font=dict(size=14),
        )
    fig.update_layout(
        xaxis=dict(
            showgrid=False,
            zeroline=False,
            showticklabels=False,
            showline=False,
        ),
        yaxis=dict(
            showgrid=False,
            zeroline=False,
            showticklabels=False,
            showline=False,
        ),
        plot_bgcolor="white",
        showlegend=False,
        margin=dict(l=0, r=0, b=0, t=0),
    )
    return fig


def _is_pure_type(inputs: List[str], df: pd.DataFrame) -> bool:
    """Check whether a list of column names are all the same broad type.

    Mirrors ``is_pure_type()`` in R. Returns ``True`` if all columns are
    numeric OR all are categorical; ``False`` for mixed types.

    Parameters
    ----------
    inputs : list of str
        Column names to validate.
    df : pd.DataFrame
        Data frame containing those columns.

    Returns
    -------
    bool
        ``True`` if pure type, ``False`` if mixed.
    """
    cols = [c for c in inputs if c and c in df.columns]
    if len(cols) <= 1:
        return True

    def _classify(col: str) -> str:
        if pd.api.types.is_numeric_dtype(df[col]):
            return "numeric"
        return "categorical"

    ref_type = _classify(cols[0])
    return all(_classify(c) == ref_type for c in cols[1:])


def _adjust_column_values(
    df: pd.DataFrame,
    x_cols: Optional[List[str]] = None,
    y_cols: Optional[List[str]] = None,
    adj_fun: Optional[str] = None,
) -> pd.DataFrame:
    """Apply a named transformation to specified columns, adding ``{col}.adj``.

    Mirrors ``.adjust_column_values()`` in R.

    Parameters
    ----------
    df : pd.DataFrame
        Source data frame.
    x_cols : list of str, optional
        X-axis columns to transform.
    y_cols : list of str, optional
        Y-axis columns to transform.
    adj_fun : str, optional
        Transformation name: ``"log2"``, ``"log"``, ``"log10"``,
        ``"neg_log10"``, ``"log1p"``, ``"abs"``, ``"sqrt"``.

    Returns
    -------
    pd.DataFrame
        Data frame with additional ``{col}.adj`` columns.
    """
    if not adj_fun:
        return df

    fn = _resolve_adj_function(adj_fun)
    if fn is None:
        return df

    df = df.copy()
    cols = list(x_cols or []) + list(y_cols or [])
    for col in cols:
        if col in df.columns:
            # Use vectorized operation directly on the Series for performance
            df[f"{col}.adj"] = fn(df[col])
    return df


def _resolve_adj_function(fn_name: str) -> Optional[Callable]:
    """Resolve a transformation name to a Python callable.

    Mirrors ``safe_resolve_adj_fxn()`` in R.

    Parameters
    ----------
    fn_name : str
        One of the allowed transformation names.

    Returns
    -------
    callable or None
        The corresponding function, or ``None`` if not recognised.
    """
    allowed: Dict[str, Callable] = {
        "log2": np.log2,
        "log": np.log,
        "log10": np.log10,
        "neg_log10": lambda x: -np.log10(x),
        "log1p": np.log1p,
        "abs": np.abs,
        "sqrt": np.sqrt,
    }
    if fn_name not in allowed:
        warnings.warn(f"Unrecognised adjustment function: {fn_name!r}")
        return None
    return allowed[fn_name]


def _get_plotly_palette(palette_name: str) -> List[str]:
    """Return a list of hex colour strings for a named palette.

    Provides a subset of common named palettes as Python lists, mirroring the
    R palette options available via ``default_palettes()``.

    Parameters
    ----------
    palette_name : str
        Name of the colour palette.

    Returns
    -------
    list of str
        Hex colour strings.
    """
    palettes: Dict[str, List[str]] = {
        "Set1": [
            "#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
            "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999",
        ],
        "Set2": [
            "#66C2A5", "#FC8D62", "#8DA0CB", "#E78AC3",
            "#A6D854", "#FFD92F", "#E5C494", "#B3B3B3",
        ],
        "Set3": [
            "#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072",
            "#80B1D3", "#FDB462", "#B3DE69", "#FCCDE5",
            "#D9D9D9", "#BC80BD", "#CCEBC5", "#FFED6F",
        ],
        "Pastel1": [
            "#FBB4AE", "#B3CDE3", "#CCEBC5", "#DECBE4",
            "#FED9A6", "#FFFFCC", "#E5D8BD", "#FDDAEC", "#F2F2F2",
        ],
        "Pastel2": [
            "#B3E2CD", "#FDCDAC", "#CBD5E8", "#F4CAE4",
            "#E6F5C9", "#FFF2AE", "#F1E2CC", "#CCCCCC",
        ],
        "Dark2": [
            "#1B9E77", "#D95F02", "#7570B3", "#E7298A",
            "#66A61E", "#E6AB02", "#A6761D", "#666666",
        ],
        "Paired": [
            "#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C",
            "#FB9A99", "#E31A1C", "#FDBF6F", "#FF7F00",
            "#CAB2D6", "#6A3D9A", "#FFFF99", "#B15928",
        ],
        "viridis": [
            "#440154", "#482878", "#3E4989", "#31688E",
            "#26828E", "#1F9E89", "#35B779", "#6DCD59",
            "#B4DE2C", "#FDE725",
        ],
        "magma": [
            "#000004", "#180F3E", "#451077", "#721F81",
            "#9F2F7F", "#CD4071", "#F0605D", "#FD9668",
            "#FECF92", "#FCFDBF",
        ],
        "inferno": [
            "#000004", "#1B0C42", "#4B0C6B", "#781C6D",
            "#A52C60", "#CF4446", "#ED6925", "#FB9A06",
            "#F7D03C", "#FCFFA4",
        ],
        "plasma": [
            "#0D0887", "#47039F", "#7301A8", "#9C179E",
            "#BD3786", "#D8576B", "#ED7953", "#FA9E3B",
            "#FDC926", "#F0F921",
        ],
    }
    return palettes.get(palette_name, palettes["Set2"])


def _parse_numeric_list(x: Optional[str]) -> Optional[List[float]]:
    """Parse a comma-separated string of numbers to a list of floats.

    Mirrors ``.parse_numeric_list()`` in R.

    Parameters
    ----------
    x : str or None
        Comma-separated numeric string, e.g. ``"1, 2.5, -3"``.

    Returns
    -------
    list of float or None
        Parsed values, or ``None`` if ``x`` is empty / unparseable.
    """
    if not x or not x.strip():
        return None
    parts = [p.strip() for p in x.split(",") if p.strip()]
    result = []
    for p in parts:
        try:
            result.append(float(p))
        except ValueError:
            pass
    return result if result else None


def _parse_str_list(x: Optional[str], fallback: str = "#000000") -> List[str]:
    """Parse a comma-separated string of values to a list of strings.

    Parameters
    ----------
    x : str or None
        Comma-separated string, e.g. ``"#FF0000, #00FF00"``.
    fallback : str
        Value used when ``x`` is empty or None.

    Returns
    -------
    list of str
    """
    if not x or not x.strip():
        return [fallback]
    return [p.strip() for p in x.split(",") if p.strip()]


def _string_to_linetypes(x: Optional[str]) -> List[str]:
    """Parse a comma-separated string of dash styles, validating each entry.

    Mirrors ``.string_to_linetypes()`` in R. Invalid entries fall back to
    ``"solid"`` with a warning.

    Parameters
    ----------
    x : str or None
        Comma-separated dash styles, e.g. ``"solid, dashed"``.

    Returns
    -------
    list of str
        Validated dash styles.
    """
    valid = {"solid", "dot", "dash", "longdash", "dashdot", "longdashdot"}
    if not x or not x.strip():
        return ["solid"]
    parts = [p.strip().lower() for p in x.split(",") if p.strip()]
    result = []
    for p in parts:
        if p in valid:
            result.append(p)
        else:
            warnings.warn(
                f"Invalid dash style {p!r}; using 'solid'. "
                f"Valid options: {', '.join(sorted(valid))}"
            )
            result.append("solid")
    return result if result else ["solid"]


def _safe_input(input: Any, name: str, default: Any) -> Any:
    """Safely retrieve a Shiny input value, returning ``default`` if absent.

    Used to access inputs that may not exist in the DOM (e.g. error-bar
    inputs that are conditionally rendered).

    Parameters
    ----------
    input : shiny Inputs
        The module's input object.
    name : str
        Input ID.
    default : Any
        Fallback value when the input does not exist or raises an error.

    Returns
    -------
    Any
        Input value or ``default``.
    """
    try:
        val = getattr(input, name)()
        return val if val is not None else default
    except Exception:
        return default
