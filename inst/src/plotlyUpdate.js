// VizModules: update plotly figures in place.
//
// The plotly htmlwidget purges and recreates its graph on every re-render
// unless the figure's layout has a `transition`, in which case it calls
// Plotly.react() on the same graph div instead: faster, and the view (zoom,
// pan, toggled legend entries) survives under a constant layout.uirevision.
// The modules set both (see finalize_manual_edits()).
//
// The one catch: the binding, and any onRender() hooks, attach their event
// listeners on every render, and purge() was what used to clear the previous
// render's. Re-rendered in place they would stack up, so that one click or
// selection reached the server once per render so far. Shiny announces each
// new value with a `shiny:value` event on the output element just before
// rendering it, so drop the graph's listeners there; the render re-attaches
// its own. plotly.js keeps its internal listeners elsewhere (_internalEv), so
// they are untouched.
(function($) {
    if (!$ || window.__vizmodulesPlotlyUpdate) {
        return;
    }
    window.__vizmodulesPlotlyUpdate = true;

    $(document).on("shiny:value", function(event) {
        var el = event.target;
        if (!el || typeof el.removeAllListeners !== "function" || !el._fullLayout) {
            return;
        }
        var layout = event.value && event.value.x && event.value.x.layout;
        if (layout && layout.transition) {
            el.removeAllListeners();
        }
    });
})(window.jQuery);
