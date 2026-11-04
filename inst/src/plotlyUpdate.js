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
//
// When only the layout changed, the server sends just that, in a
// `vizmodules-plotly-layout` message, and cancels the render (see
// .send_layout_only()). It is applied over the traces already drawn, and kept
// in Shiny's copy of the output's last value, which Shiny replays if the
// output is bound again. The listeners stay: no render re-attaches them. If
// there is no plot to update, or an error hides it until a full render clears
// it, the message asks the server for the whole figure instead.
(function($) {
    if (!$ || window.__vizmodulesPlotlyUpdate) {
        return;
    }
    window.__vizmodulesPlotlyUpdate = true;

    $(document).on("shiny:value", function(event) {
        var el = event.target;
        if (!el) {
            return;
        }
        el.__vizmodulesError = false;
        if (typeof el.removeAllListeners !== "function" || !el._fullLayout) {
            return;
        }
        var layout = event.value && event.value.x && event.value.x.layout;
        if (layout && layout.transition) {
            el.removeAllListeners();
        }
    });

    $(document).on("shiny:error", function(event) {
        if (event.target) {
            event.target.__vizmodulesError = true;
        }
    });

    if (!window.Shiny || typeof Shiny.addCustomMessageHandler !== "function") {
        return;
    }
    Shiny.addCustomMessageHandler("vizmodules-plotly-layout", function(msg) {
        var gd = document.getElementById(msg.id);
        if (!gd || !gd._fullLayout || gd.__vizmodulesError || !window.Plotly) {
            if (msg.refresh) {
                Shiny.setInputValue(msg.refresh, Date.now(), {priority: "event"});
            }
            return;
        }
        var layout = msg.layout;
        if (!layout) {
            return;
        }
        // As the widget's renderValue() does, for its resize handler.
        var instance = window.HTMLWidgets && HTMLWidgets.getInstance ? HTMLWidgets.getInstance(gd) : null;
        if (instance) {
            instance.width = layout.width;
            instance.height = layout.height;
            instance.autosize = layout.autosize || true;
        }
        var app = Shiny.shinyapp;
        var last = app && app.$values ? app.$values[msg.id] : null;
        if (last && last.x) {
            last.x.layout = layout;
        }
        Plotly.react(gd, gd.data, layout);
    });
})(window.jQuery);
