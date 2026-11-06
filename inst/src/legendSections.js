// VizModules: legend sections for a plot mapping both colour and shape.
//
// .split_color_shape_legend() draws such a plot's legend in two sections, one
// entry per colour level and one per shape level, in place of ggplotly's entry
// per combination. Every trace it touched carries its levels in
// meta.vizmodules_legend ({color, shape}), and an entry also says which
// section it is in ({entry: "color" | "shape"}).
//
// plotly's own legend clicks would only toggle the entry itself, so clicks on
// an entry are handled here: a click hides or shows that level, a double-click
// shows only that level within its section (or, when it is already the only
// one shown, all of them). A trace is shown while neither its colour nor its
// shape is hidden. Clicks on any other legend entry are left to plotly.
//
// The change is made as plotly makes its own legend clicks, as a GUI edit, so
// it survives a re-render under the same layout.uirevision and resets with it.
(function() {
    if (window.VizModulesLegend) {
        return;
    }

    function tag(trace) {
        return trace && trace.meta && trace.meta.vizmodules_legend;
    }

    function restyle(gd, update, indices) {
        var full = gd._fullLayout;
        if (full) {
            full._guiEditing = true;
        }
        try {
            return window.Plotly.restyle(gd, update, indices);
        } finally {
            if (full) {
                full._guiEditing = false;
            }
        }
    }

    function entryOf(gd, event) {
        var clicked = tag((gd.data || [])[event.curveNumber]);
        return clicked && clicked.entry && window.Plotly ? clicked : null;
    }

    function apply(gd, clicked, isolate) {
        var data = gd.data || [];
        var section = clicked.entry;
        var level = clicked[section];

        // What is hidden now, read from the entries.
        var hidden = {color: {}, shape: {}};
        var levels = [];
        data.forEach(function(trace) {
            var t = tag(trace);
            if (t && t.entry) {
                if (trace.visible === "legendonly") {
                    hidden[t.entry][t[t.entry]] = true;
                }
                if (t.entry === section) {
                    levels.push(t[section]);
                }
            }
        });

        if (isolate) {
            var others = levels.filter(function(l) { return l !== level; });
            var alone = !hidden[section][level] && others.every(function(l) { return hidden[section][l]; });
            hidden[section] = {};
            if (!alone) {
                others.forEach(function(l) { hidden[section][l] = true; });
            }
        } else if (hidden[section][level]) {
            delete hidden[section][level];
        } else {
            hidden[section][level] = true;
        }

        var indices = [];
        var visible = [];
        data.forEach(function(trace, i) {
            var t = tag(trace);
            if (!t) {
                return;
            }
            var off = (t.color !== undefined && hidden.color[t.color]) ||
                (t.shape !== undefined && hidden.shape[t.shape]);
            indices.push(i);
            visible.push(off ? "legendonly" : true);
        });
        if (indices.length) {
            restyle(gd, {visible: visible}, indices);
        }
    }

    window.VizModulesLegend = {
        // Called from the figure's onRender() hook, so on every render.
        attach: function(gd) {
            if (!gd || typeof gd.on !== "function") {
                return;
            }
            // Returning false from plotly_legendclick stops plotly's own toggle, but
            // also its plotly_legenddoubleclick, which it only fires when the click
            // was let through. So a double-click is told apart here as plotly does:
            // a second click on the same entry within the double-click delay. A
            // click is applied once that delay has passed without one.
            var pending = null;
            var flush = function() {
                if (pending) {
                    clearTimeout(pending.timer);
                    var last = pending;
                    pending = null;
                    return last;
                }
                return null;
            };
            gd.on("plotly_legendclick", function(event) {
                var clicked = entryOf(gd, event);
                if (!clicked) {
                    return true;
                }
                var last = flush();
                if (last && last.curve === event.curveNumber) {
                    apply(gd, clicked, true);
                    return false;
                }
                if (last && gd._fullLayout) {
                    // A click on another entry: the first one still counts.
                    apply(gd, last.clicked, false);
                }
                var delay = (gd._context && gd._context.doubleClickDelay) || 300;
                pending = {curve: event.curveNumber, clicked: clicked, timer: setTimeout(function() {
                    var due = flush();
                    if (due && gd._fullLayout) {
                        apply(gd, due.clicked, false);
                    }
                }, delay)};
                return false;
            });
            // Never reached for an entry while the clicks are stopped above, but
            // should plotly ever fire it anyway, its default must not run too.
            gd.on("plotly_legenddoubleclick", function(event) {
                return entryOf(gd, event) ? false : true;
            });
        }
    };
})();
