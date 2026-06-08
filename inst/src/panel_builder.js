function pbDownloadSVG() {
    var canvas = document.getElementById('pb_canvas');
    if (!canvas) { return; }
    var cards = canvas.querySelectorAll('.viz-panel-card');
    if (!cards.length) {
        alert('Add at least one plot before downloading.');
        return;
    }
    var W = canvas.clientWidth, H = canvas.clientHeight;
    var canvasRect = canvas.getBoundingClientRect();
    var tasks = [];
    cards.forEach(function(card) {
        var cardRect = card.getBoundingClientRect();
        var x = cardRect.left - canvasRect.left + canvas.scrollLeft;
        var y = cardRect.top - canvasRect.top + canvas.scrollTop;
        var w = cardRect.width, h = cardRect.height;
        var body = card.querySelector('.viz-panel-body');
        var gd = card.querySelector('.js-plotly-plot');
        var pw = body ? body.clientWidth : w;
        var ph = body ? body.clientHeight : h;
        var meta = { x: x, y: y, w: w, h: h, pw: pw, ph: ph, url: null };
        if (gd && window.Plotly) {
            tasks.push(
                Plotly.toImage(gd, { format: 'svg', width: pw, height: ph })
                    .then(function(url) { meta.url = url; return meta; })
                    .catch(function() { return meta; })
            );
        } else {
            tasks.push(Promise.resolve(meta));
        }
    });
    Promise.all(tasks).then(function(items) {
        var parts = [];
        parts.push('<?xml version=\"1.0\" encoding=\"UTF-8\"?>');
        parts.push('<svg xmlns=\"http://www.w3.org/2000/svg\" ' +
            'xmlns:xlink=\"http://www.w3.org/1999/xlink\" ' +
            'width=\"' + W + '\" height=\"' + H + '\" ' +
            'viewBox=\"0 0 ' + W + ' ' + H + '\">');
        parts.push('<rect x=\"0\" y=\"0\" width=\"' + W + '\" height=\"' + H +
            '\" fill=\"#ffffff\"/>');
        items.forEach(function(it) {
            parts.push('<g>');
            if (it.url) {
                parts.push('<image x=\"' + (it.x + 6) + '\" y=\"' +
                    (it.y + 6) + '\" width=\"' + it.pw +
                    '\" height=\"' + it.ph + '\" xlink:href=\"' + it.url + '\"/>');
            }
            parts.push('</g>');
        });
        parts.push('</svg>');
        var blob = new Blob([parts.join('\\n')], { type: 'image/svg+xml' });
        var a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = 'vizmodules-panel.svg';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(a.href);
    });
}

// Keep each plot sized to its card so dragging the resize handle changes the
// plot's height as well as its width. jQuery UI resizable only resizes the
// card div, so we watch each card body and ask Plotly to relayout to fit.
var pbCardObservers = new WeakMap();
function pbResizePlot(card) {
    var gd = card.querySelector('.js-plotly-plot');
    if (gd && window.Plotly) { Plotly.Plots.resize(gd); }
}
function pbObserveCard(card) {
    if (pbCardObservers.has(card) || !window.ResizeObserver) { return; }
    var body = card.querySelector('.viz-panel-body');
    if (!body) { return; }
    var ro = new ResizeObserver(function() { pbResizePlot(card); });
    ro.observe(body);
    pbCardObservers.set(card, ro);
}
function pbUnobserveCard(card) {
    var ro = pbCardObservers.get(card);
    if (ro) { ro.disconnect(); pbCardObservers.delete(card); }
}
function pbFindCard(node) {
    if (node.nodeType !== 1) { return null; }
    if (node.classList && node.classList.contains('viz-panel-card')) { return node; }
    if (node.querySelector) { return node.querySelector('.viz-panel-card'); }
    return null;
}
$(function() {
    var canvas = document.getElementById('pb_canvas');
    if (!canvas) { return; }
    // Attach observers to cards added at runtime and tear them down on removal
    // so detached cards do not leak their ResizeObserver.
    var mo = new MutationObserver(function(mutations) {
        mutations.forEach(function(m) {
            m.addedNodes.forEach(function(node) {
                var card = pbFindCard(node);
                if (card) { pbObserveCard(card); }
            });
            m.removedNodes.forEach(function(node) {
                var card = pbFindCard(node);
                if (card) { pbUnobserveCard(card); }
            });
        });
    });
    mo.observe(canvas, { childList: true, subtree: true });
});