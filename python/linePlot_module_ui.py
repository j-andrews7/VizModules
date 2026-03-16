"""Input and Output UI components for the linePlot Shiny module (Python).

Mirrors the logic from R/linePlot_module_ui.R using Python Shiny (shiny for Python)
and shinywidgets for plotly output.

Usage
-----
    from linePlot_module_ui import line_plot_inputs_ui, line_plot_output_ui

    # In app UI:
    app_ui = ui.page_fluid(
        line_plot_inputs_ui("myPlot", data=df),
        line_plot_output_ui("myPlot"),
    )

    # In app server:
    from linePlot_module_server import line_plot_server
    def server(input, output, session):
        line_plot_server("myPlot", data=reactive.calc(lambda: df))
"""

from __future__ import annotations

from typing import Any, Dict, List, Optional

import pandas as pd
from shiny import module, ui
from shinywidgets import output_widget


# ---------------------------------------------------------------------------
# Public module UI functions
# ---------------------------------------------------------------------------


@module.ui
def line_plot_inputs_ui(
    data: pd.DataFrame,
    defaults: Optional[Dict[str, Any]] = None,
    title: Optional[str] = None,
    columns: int = 2,
) -> ui.TagList:
    """Input UI components for the linePlot module.

    Mirrors ``linePlotInputsUI()`` in R. Should be placed in the app UI where
    the inputs should be shown, with an ``id`` that matches the ``id`` used in
    ``line_plot_server()`` and ``line_plot_output_ui()``.

    Parameters
    ----------
    data : pd.DataFrame
        The data frame used for plot generation. Used to derive column choices.
    defaults : dict, optional
        Named dict of default values for the inputs. Nearly all parameters for
        ``linePlotPX()`` can be set via these defaults.
    title : str, optional
        An optional title rendered above the tabset panel.
    columns : int
        Number of columns for the UI grid inside each tab. Default is 2.

    Notes
    -----
    Plot parameters available via ``defaults``:

    - ``x`` – X-axis column(s); default: first column
    - ``y`` – Y-axis column(s); default: second column
    - ``group_by`` – Grouping variable; default: first categorical column
    - ``order_by`` – Order by Y values; default: False
    - ``x_adjustment`` – X-axis transformation; default: ""
    - ``y_adjustment`` – Y-axis transformation; default: ""
    - ``facet_col_by`` – Column whose unique values become subplot columns; default: ""
    - ``facet_row_by`` – Column whose unique values become subplot rows; default: ""
    - ``facet_ncols`` – Max subplot columns per row (0 = auto); default: 0
    - ``facet_nrows`` – Max subplot rows per column (0 = auto); default: 0
    - ``facet_scales`` – Facet scale behaviour; default: "fixed"
    - ``plot_mode`` – Plot type; default: "lines"
    - ``line_type`` – Line style; default: "solid"
    - ``axis_showline`` – Show axis borders; default: True
    - ``axis_mirror`` – Mirror axis borders; default: True
    - ``axis_linecolor`` – Axis line colour; default: "black"
    - ``axis_linewidth`` – Axis line width; default: 0.5
    - ``axis_tickfont_size`` – Tick label size; default: 12
    - ``axis_tickfont_color`` – Tick label colour; default: "black"
    - ``axis_tickfont_family`` – Tick label font; default: "Arial"
    - ``axis_tickangle_x`` – X tick angle; default: 0
    - ``axis_tickangle_y`` – Y tick angle; default: 0
    - ``axis_ticks`` – Tick position; default: "outside"
    - ``axis_tickcolor`` – Tick colour; default: "black"
    - ``axis_ticklen`` – Tick length; default: 5
    - ``axis_tickwidth`` – Tick width; default: 1
    - ``show_grid_x`` – Show X gridlines; default: True
    - ``show_grid_y`` – Show Y gridlines; default: True
    - ``title_font_size`` – Title font size; default: 28
    - ``title_font_family`` – Title font family; default: "Arial"
    - ``title_text_color`` – Title text colour; default: "#000000"
    - ``flip_x`` – Flip X axis; default: False
    - ``flip_y`` – Flip Y axis; default: False
    - ``hline_intercepts`` – Horizontal line Y-intercepts; default: ""
    - ``hline_colors`` – Horizontal line colours; default: "#000000"
    - ``hline_widths`` – Horizontal line widths; default: "1"
    - ``hline_linetypes`` – Horizontal line types; default: "dashed"
    - ``hline_opacities`` – Horizontal line opacities; default: "1"
    - ``vline_intercepts`` – Vertical line X-intercepts; default: ""
    - ``vline_colors`` – Vertical line colours; default: "#000000"
    - ``vline_widths`` – Vertical line widths; default: "1"
    - ``vline_linetypes`` – Vertical line types; default: "dashed"
    - ``vline_opacities`` – Vertical line opacities; default: "1"
    - ``abline_slopes`` – Diagonal line slopes; default: ""
    - ``abline_intercepts`` – Diagonal line Y-intercepts; default: ""
    - ``abline_colors`` – Diagonal line colours; default: "#000000"
    - ``abline_widths`` – Diagonal line widths; default: "1"
    - ``abline_linetypes`` – Diagonal line types; default: "dashed"
    - ``abline_opacities`` – Diagonal line opacities; default: "1"

    Returns
    -------
    ui.TagList
        A Shiny TagList containing all UI elements.
    """
    choices = list(data.columns)
    cat_choices = [""] + [
        col for col in data.columns if not pd.api.types.is_numeric_dtype(data[col])
    ]
    adj_choices = ["", "log2", "log", "log10", "neg_log10", "log1p", "abs", "sqrt"]

    data_inputs = ui.TagList(
        ui.tooltip(
            ui.input_select(
                "x_value",
                "Select X values:",
                choices=choices,
                selected=choices[0] if choices else "",
                multiple=True,
            ),
            (
                "X-axis variable(s). If you want error bars the X input must be "
                "a category and the Y input must only be length = 1"
            ),
        ),
        ui.tooltip(
            ui.input_select(
                "y_value",
                "Select Y values:",
                choices=choices,
                selected=(
                    choices[1] if len(choices) > 1 else (choices[0] if choices else "")
                ),
                multiple=True,
            ),
            "Y-axis variable(s).",
        ),
        ui.tooltip(
            ui.input_select(
                "group_by",
                "Group by:",
                choices=cat_choices,
                selected=_get_default(defaults, "group_by", cat_choices[0]),
            ),
            "Grouping variable for colour-coding plot lines.",
        ),
        # Error bar inputs are rendered dynamically by the server to allow
        # hide/show based on whether the X input is categorical.
        ui.output_ui("error_bar_inputs"),
        ui.tooltip(
            ui.input_switch(
                "order_by",
                "Order by Y",
                value=_get_default(defaults, "order_by", False),
            ),
            "Order data by Y values before plotting.",
        ),
        ui.tooltip(
            ui.input_select(
                "x_adjustment",
                "X Adjustment",
                choices=adj_choices,
                selected=_get_default(defaults, "x_adjustment", ""),
            ),
            "Transformation to apply to X-axis values.",
        ),
        ui.tooltip(
            ui.input_select(
                "y_adjustment",
                "Y Adjustment",
                choices=adj_choices,
                selected=_get_default(defaults, "y_adjustment", ""),
            ),
            "Transformation to apply to Y-axis values.",
        ),
    )

    facet_inputs = ui.TagList(
        # ── Facet by columns ──────────────────────────────────────────────────
        ui.h6(
            ui.span("── Facet by Columns ──", style="color: #6c757d; font-size: 0.8rem;")
        ),
        ui.tooltip(
            ui.input_select(
                "facet_col_by",
                "Facet by columns:",
                choices=cat_choices,
                selected=_get_default(defaults, "facet_col_by", ""),
            ),
            (
                "Select a categorical column whose unique values become separate "
                "subplot COLUMNS (left → right). Each unique value gets its own "
                "column of subplots."
            ),
        ),
        ui.tooltip(
            ui.input_numeric(
                "facet_ncols",
                "Max columns per row:",
                value=_get_default(defaults, "facet_ncols", 0),
                min=0,
                step=1,
            ),
            (
                "Maximum subplot columns per row when faceting by columns. "
                "Set to 0 (default) to place all column-facets in a single row."
            ),
        ),
        ui.br(),
        # ── Facet by rows ─────────────────────────────────────────────────────
        ui.h6(
            ui.span("── Facet by Rows ──", style="color: #6c757d; font-size: 0.8rem;")
        ),
        ui.tooltip(
            ui.input_select(
                "facet_row_by",
                "Facet by rows:",
                choices=cat_choices,
                selected=_get_default(defaults, "facet_row_by", ""),
            ),
            (
                "Select a categorical column whose unique values become separate "
                "subplot ROWS (top → bottom). Each unique value gets its own row "
                "of subplots. Can be combined with 'Facet by columns' for a 2-D grid."
            ),
        ),
        ui.tooltip(
            ui.input_numeric(
                "facet_nrows",
                "Max rows per column:",
                value=_get_default(defaults, "facet_nrows", 0),
                min=0,
                step=1,
            ),
            (
                "Maximum subplot rows per column when faceting by rows. "
                "Set to 0 (default) to place all row-facets in a single column."
            ),
        ),
        ui.br(),
        # ── Facet axis scales ─────────────────────────────────────────────────
        ui.tooltip(
            ui.input_select(
                "facet_scales",
                "Facet scales",
                choices=["fixed", "free", "free_x", "free_y"],
                selected=_get_default(defaults, "facet_scales", "fixed"),
            ),
            (
                "Controls axis scaling across all facets: "
                "'fixed' – same scale for all subplots; "
                "'free' – each subplot has its own scale; "
                "'free_x' – only x-axis varies; "
                "'free_y' – only y-axis varies."
            ),
        ),
    )

    aesthetic_inputs = ui.TagList(
        ui.tooltip(
            ui.input_select(
                "plot_type",
                "Plot type:",
                choices=["lines", "markers", "lines+markers"],
                selected=_get_default(defaults, "plot_mode", "lines"),
            ),
            "Plotly mode controlling how data points are drawn.",
        ),
        ui.tooltip(
            ui.input_select(
                "line_type",
                "Line type:",
                choices=["solid", "dot", "dash", "longdash", "dashdot", "longdashdot"],
                selected=_get_default(defaults, "line_type", "solid"),
            ),
            "Line dash style.",
        ),
        # Palette colour picker is rendered dynamically by the server so that
        # its colour slots reflect the current groups on the plot.
        ui.output_ui("palette_selection"),
    )

    inputs: Dict[str, ui.TagList] = {
        "Data": data_inputs,
        "Facet": facet_inputs,
        "Aesthetics": aesthetic_inputs,
        "Axes": _uniform_axes_inputs_ui(
            defaults, include_rotate=False, include_flip=True
        ),
        "Lines": _uniform_lines_inputs_ui(defaults),
    }

    return _organize_inputs(
        inputs,
        tab_id="linePlotTabsetPanel",
        title=title,
        tack=_module_tack_ui(defaults),
        columns=columns,
    )


def line_plot_output_ui(id: str) -> ui.Tag:
    """Output UI component for the linePlot module.

    Mirrors ``linePlotOutputUI()`` in R. Place this in the app UI where the
    plot should appear. The ``id`` must match the ``id`` used in
    ``line_plot_inputs_ui()`` and ``line_plot_server()``.

    A CSS ``resize: both`` wrapper gives the user a drag handle (bottom-right
    corner) to resize the plot container, similar to ``jqui_resizable()`` in R.

    Parameters
    ----------
    id : str
        The module ID.

    Returns
    -------
    ui.Tag
        A shinywidgets ``output_widget`` for the plotly linePlot, wrapped in
        a resizable container.
    """
    # Python Shiny namespaces module outputs as "{module_id}-{output_id}"
    return ui.div(
        output_widget(f"{id}-linePlot"),
        style=(
            "resize: both;"
            " overflow: auto;"
            " min-height: 450px;"
            " min-width: 300px;"
            " border: 1px solid #dee2e6;"
            " border-radius: 4px;"
            " padding: 4px;"
        ),
    )


# ---------------------------------------------------------------------------
# Helper / internal functions  (kept at the bottom per convention)
# ---------------------------------------------------------------------------


def _get_default(
    defaults: Optional[Dict[str, Any]],
    key: str,
    fallback: Any,
    validator=None,
) -> Any:
    """Resolve a default value from a named dict.

    Mirrors ``.get_default()`` in R. Looks up ``key`` in ``defaults`` and
    returns the stored value if it passes ``validator``; otherwise returns
    ``fallback``.

    Parameters
    ----------
    defaults : dict or None
        A named dict of default values.
    key : str
        The key to look up.
    fallback : Any
        Value returned when ``key`` is absent or fails validation.
    validator : callable, optional
        Single-argument predicate; value is returned only if ``validator(value)``
        is truthy.

    Returns
    -------
    Any
        Resolved default value or ``fallback``.
    """
    if defaults is not None and key in defaults:
        value = defaults[key]
        if validator is None or validator(value):
            return value
    return fallback


def _uniform_axes_inputs_ui(
    defaults: Optional[Dict[str, Any]] = None,
    include_rotate: bool = False,
    include_flip: bool = False,
) -> ui.TagList:
    """Generate uniform axis input UI elements.

    Mirrors ``.uniform_axes_inputs_ui()`` in R. Creates a standardised
    TagList of axis-related inputs for use in plot modules.

    Parameters
    ----------
    defaults : dict, optional
        Named dict of default values.
    include_rotate : bool
        Whether to include a "Rotate (swap X/Y)" toggle. Default False.
    include_flip : bool
        Whether to include "Flip X Axis" / "Flip Y Axis" toggles. Default False.

    Returns
    -------
    ui.TagList
        Axis input UI elements.
    """
    font_choices = [
        "Arial",
        "Balto",
        "Courier New",
        "Droid Sans",
        "Droid Serif",
        "Droid Sans Mono",
        "Gravitas One",
        "Old Standard TT",
        "Open Sans",
        "Overpass",
        "PT Sans Narrow",
        "Raleway",
        "Times New Roman",
        "Verdana",
        "sans-serif",
        "serif",
        "monospace",
    ]

    elements: List[Any] = []

    if include_rotate:
        elements.append(
            ui.input_switch(
                "rotate",
                "Rotate (swap X/Y)",
                value=_get_default(defaults, "rotate", False),
            )
        )

    if include_flip:
        elements.extend(
            [
                ui.input_switch(
                    "flip_x",
                    "Flip X Axis",
                    value=_get_default(defaults, "flip_x", False),
                ),
                ui.input_switch(
                    "flip_y",
                    "Flip Y Axis",
                    value=_get_default(defaults, "flip_y", False),
                ),
            ]
        )

    elements.extend(
        [
            ui.input_select(
                "title_font_family",
                "Title Font",
                choices=font_choices,
                selected=_get_default(defaults, "title_font_family", "Arial"),
            ),
            ui.tooltip(
                ui.input_text(
                    "text_colour",
                    "Title Color",
                    value=_get_default(defaults, "text_colour", "#000000"),
                ),
                "Hex colour string for the plot title, e.g. '#000000'.",
            ),
            ui.input_numeric(
                "axis_title_font_size",
                "Axis Title Size",
                value=_get_default(defaults, "axis_title_font_size", 18),
                min=1,
                step=1,
            ),
            ui.tooltip(
                ui.input_text(
                    "axis_title_font_color",
                    "Axis Title Color",
                    value=_get_default(defaults, "axis_title_font_color", "#000000"),
                ),
                "Hex colour string for axis title text.",
            ),
            ui.input_select(
                "axis_title_font_family",
                "Axis Title Font",
                choices=font_choices,
                selected=_get_default(defaults, "axis_title_font_family", "Arial"),
            ),
            ui.input_checkbox(
                "axis_showline",
                "Show Axis Borders",
                value=_get_default(defaults, "axis_showline", True),
            ),
            ui.input_checkbox(
                "axis_mirror",
                "Mirror Axis Borders",
                value=_get_default(defaults, "axis_mirror", True),
            ),
            ui.input_checkbox(
                "show_grid_x",
                "Show X Gridlines",
                value=_get_default(defaults, "show_grid_x", True),
            ),
            ui.input_checkbox(
                "show_grid_y",
                "Show Y Gridlines",
                value=_get_default(defaults, "show_grid_y", True),
            ),
            ui.tooltip(
                ui.input_text(
                    "axis_linecolor",
                    "Axis Line Color",
                    value=_get_default(defaults, "axis_linecolor", "black"),
                ),
                "Colour name or hex string for axis border lines.",
            ),
            ui.input_numeric(
                "axis_linewidth",
                "Axis Line Width",
                value=_get_default(defaults, "axis_linewidth", 0.5),
                min=0,
                step=0.1,
            ),
            ui.input_numeric(
                "axis_tickfont_size",
                "Tick Label Size",
                value=_get_default(defaults, "axis_tickfont_size", 12),
                min=1,
                step=1,
            ),
            ui.tooltip(
                ui.input_text(
                    "axis_tickfont_color",
                    "Tick Label Color",
                    value=_get_default(defaults, "axis_tickfont_color", "black"),
                ),
                "Colour name or hex string for axis tick labels.",
            ),
            ui.input_select(
                "axis_tickfont_family",
                "Tick Label Font",
                choices=font_choices,
                selected=_get_default(defaults, "axis_tickfont_family", "Arial"),
            ),
            ui.input_numeric(
                "axis_tickangle_x",
                "X Tick Label Angle",
                value=_get_default(defaults, "axis_tickangle_x", 0),
                min=-180,
                max=180,
                step=15,
            ),
            ui.input_numeric(
                "axis_tickangle_y",
                "Y Tick Label Angle",
                value=_get_default(defaults, "axis_tickangle_y", 0),
                min=-180,
                max=180,
                step=15,
            ),
            ui.input_select(
                "axis_ticks",
                "Tick Position",
                choices={"outside": "Outside", "inside": "Inside", "": "None"},
                selected=_get_default(defaults, "axis_ticks", "outside"),
            ),
            ui.tooltip(
                ui.input_text(
                    "axis_tickcolor",
                    "Tick Mark Color",
                    value=_get_default(defaults, "axis_tickcolor", "black"),
                ),
                "Colour name or hex string for tick marks.",
            ),
            ui.input_numeric(
                "axis_ticklen",
                "Tick Mark Length",
                value=_get_default(defaults, "axis_ticklen", 5),
                min=0,
                step=1,
            ),
            ui.input_numeric(
                "axis_tickwidth",
                "Tick Mark Width",
                value=_get_default(defaults, "axis_tickwidth", 1),
                min=0,
                step=0.1,
            ),
        ]
    )

    return ui.TagList(*elements)


def _uniform_lines_inputs_ui(
    defaults: Optional[Dict[str, Any]] = None,
    include_fit_lines: bool = False,
) -> ui.TagList:
    """Generate uniform reference-line input UI elements.

    Mirrors ``.uniform_lines_inputs_ui()`` in R. Creates inputs for
    horizontal, vertical, and diagonal reference lines.

    Parameters
    ----------
    defaults : dict, optional
        Named dict of default values.
    include_fit_lines : bool
        Whether to include best-fit line inputs (scatter plots only). Default False.

    Returns
    -------
    ui.TagList
        Reference-line input UI elements.
    """
    intercept_tip = (
        "For categorical or factor axes, enter the index (position) of the "
        "category rather than its name. For example, if the axis categories "
        "are 'Audi', 'Mercedes', 'Bugatti', enter 2 to place a line at 'Mercedes'."
    )

    elements: List[Any] = [
        # ── Horizontal lines ──────────────────────────────────────────────
        ui.h6(
            ui.span("─── Horizontal Lines (H-Lines) ───", style="color: #6c757d; font-size: 0.8rem;")
        ),
        ui.tooltip(
            ui.input_text(
                "hline_intercepts",
                "Y-intercepts",
                value=_get_default(defaults, "hline_intercepts", ""),
                placeholder="e.g. 2, -2",
            ),
            intercept_tip,
        ),
        ui.input_text(
            "hline_colors",
            "H-Line Colors",
            value=_get_default(defaults, "hline_colors", "#000000"),
        ),
        ui.input_text(
            "hline_widths",
            "H-Line Widths",
            value=_get_default(defaults, "hline_widths", "1"),
        ),
        ui.input_text(
            "hline_linetypes",
            "H-Line Types",
            value=_get_default(defaults, "hline_linetypes", "dashed"),
            placeholder="solid, dashed, dotted, ...",
        ),
        ui.input_text(
            "hline_opacities",
            "H-Line Opacities (0-1)",
            value=_get_default(defaults, "hline_opacities", "1"),
        ),
        ui.br(),
        # ── Vertical lines ────────────────────────────────────────────────
        ui.h6(
            ui.span("─── Vertical Lines (V-Lines) ───", style="color: #6c757d; font-size: 0.8rem;")
        ),
        ui.tooltip(
            ui.input_text(
                "vline_intercepts",
                "X-intercepts",
                value=_get_default(defaults, "vline_intercepts", ""),
                placeholder="e.g. 2, -2",
            ),
            intercept_tip,
        ),
        ui.input_text(
            "vline_colors",
            "V-Line Colors",
            value=_get_default(defaults, "vline_colors", "#000000"),
        ),
        ui.input_text(
            "vline_widths",
            "V-Line Widths",
            value=_get_default(defaults, "vline_widths", "1"),
        ),
        ui.input_text(
            "vline_linetypes",
            "V-Line Types",
            value=_get_default(defaults, "vline_linetypes", "dashed"),
            placeholder="solid, dashed, dotted, ...",
        ),
        ui.input_text(
            "vline_opacities",
            "V-Line Opacities (0-1)",
            value=_get_default(defaults, "vline_opacities", "1"),
        ),
        ui.br(),
        # ── Diagonal (abline) lines ───────────────────────────────────────
        ui.h6(
            ui.span("─── Diagonal Lines (Ablines) ───", style="color: #6c757d; font-size: 0.8rem;")
        ),
        ui.tooltip(
            ui.input_text(
                "abline_slopes",
                "Slopes",
                value=_get_default(defaults, "abline_slopes", ""),
                placeholder="e.g. 1, 0.5",
            ),
            "Slope(s) for diagonal reference lines (rise over run).",
        ),
        ui.input_text(
            "abline_intercepts",
            "Ab-Line Y-intercepts",
            value=_get_default(defaults, "abline_intercepts", ""),
        ),
        ui.input_text(
            "abline_colors",
            "Ab-Line Colors",
            value=_get_default(defaults, "abline_colors", "#000000"),
        ),
        ui.input_text(
            "abline_widths",
            "Ab-Line Widths",
            value=_get_default(defaults, "abline_widths", "1"),
        ),
        ui.input_text(
            "abline_linetypes",
            "Ab-Line Types",
            value=_get_default(defaults, "abline_linetypes", "dashed"),
            placeholder="solid, dashed, dotted, ...",
        ),
        ui.input_text(
            "abline_opacities",
            "Ab-Line Opacities (0-1)",
            value=_get_default(defaults, "abline_opacities", "1"),
        ),
    ]

    return ui.TagList(*elements)


def _module_tack_ui(defaults: Optional[Dict[str, Any]] = None) -> ui.TagList:
    """Create the standard control tack UI for a VizModules module.

    Mirrors ``module_tack_ui()`` in R. Renders Auto Update toggle, Update
    button, Reset button, Save Interactive download button, and Download
    Format selector.

    Parameters
    ----------
    defaults : dict, optional
        Supports ``download_format`` key ("svg" or "png").

    Returns
    -------
    ui.TagList
        Standard control buttons and inputs.
    """
    download_format = _get_default(defaults, "download_format", "svg")
    if download_format not in ("svg", "png"):
        download_format = "svg"

    return ui.TagList(
        ui.layout_columns(
            ui.div(
                ui.input_switch("auto_update", "Auto Update", value=True),
                style="margin-top: 25px;",
            ),
            ui.div(
                ui.input_action_button("update", "Update", width="100%"),
                style="margin-top: 25px;",
            ),
            ui.div(
                ui.input_action_button(
                    "reset",
                    "Reset",
                    class_="btn-secondary",
                    width="100%",
                ),
                style="margin-top: 25px;",
            ),
            ui.div(
                ui.download_button(
                    "download_interactive",
                    "Save Interactive",
                    class_="btn-secondary",
                    width="100%",
                ),
                style="margin-top: 25px;",
            ),
            ui.div(
                ui.input_select(
                    "download_format",
                    "Download Format",
                    choices=["png", "svg"],
                    selected=download_format,
                    width="100%",
                ),
            ),
            col_widths=[2, 2, 2, 3, 3],
        ),
        ui.br(),
    )


def _organize_inputs(
    inputs: Dict[str, ui.TagList],
    tab_id: Optional[str] = None,
    title: Optional[str] = None,
    tack: Optional[Any] = None,
    columns: int = 2,
) -> ui.TagList:
    """Organise a dict of named TagLists into a tabset panel with grid layouts.

    Mirrors ``organize_inputs()`` in R. Each dict key becomes a tab; inputs
    within each tab are laid out in a CSS grid with ``columns`` columns.

    Parameters
    ----------
    inputs : dict
        Mapping of tab-name str → TagList of UI inputs.
    tab_id : str, optional
        ID for the tabset panel.
    title : str, optional
        Optional title rendered above the tabset.
    tack : Any, optional
        Additional UI element appended after the tabset.
    columns : int
        Number of grid columns per tab.

    Returns
    -------
    ui.TagList
        Organised UI.
    """
    nav_panels = []
    for tab_name, tab_inputs in inputs.items():
        content = _inputs_to_grid(tab_inputs, columns=columns)
        nav_panels.append(ui.nav_panel(tab_name, content))

    kwargs: Dict[str, Any] = {}
    if tab_id is not None:
        kwargs["id"] = tab_id

    tabset = ui.navset_card_pill(*nav_panels, **kwargs)

    parts: List[Any] = [tabset]
    if tack is not None:
        parts.append(tack)

    result: Any = ui.TagList(*parts)

    if title is not None:
        result = ui.TagList(ui.h3(title), result)

    return result


def _inputs_to_grid(tag_list: ui.TagList, columns: int = 2) -> ui.TagList:
    """Arrange a TagList of inputs into a row/column grid.

    Mirrors the grid layout logic in ``organize_inputs()`` from R's
    ``ui_utils.R``.

    Parameters
    ----------
    tag_list : ui.TagList
        Flat list of UI inputs to arrange.
    columns : int
        Number of columns. Default 2.

    Returns
    -------
    ui.TagList
        Grid of inputs wrapped in ``ui.row`` / ``ui.column`` elements.
    """
    children = list(tag_list)
    if not children:
        return ui.TagList()

    col_width = max(1, 12 // columns)
    rows = []
    for i in range(0, len(children), columns):
        row_items = children[i : i + columns]
        cols = [ui.column(col_width, item) for item in row_items]
        rows.append(ui.row(*cols))

    return ui.TagList(*rows)
