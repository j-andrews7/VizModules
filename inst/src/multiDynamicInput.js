(function () {

  const parseJSON = (value, fallback) => {
    try {
      return JSON.parse(value);
    } catch (e) {
      return fallback;
    }
  };

  const getData = (el) => {
    if (!el._mdiData) {
      el._mdiData = {
        keys: parseJSON(el.dataset.keys || "[]", []),
        initial: parseJSON(el.dataset.initial || "[]", []),
        inputId: el.dataset.inputId || el.id,
        counter: 0
      };
    }
    return el._mdiData;
  };

  const rowsContainer = (el) => el.querySelector(".mdi-rows");
  const templateEl = (el) => el.querySelector(".mdi-row-template");

  // Read a single field's value by deferring to its registered Shiny binding,
  // so any properly-registered input type reports correctly.
  const readField = (fieldEl) => {
    const bound = fieldEl.querySelector(".shiny-bound-input");
    const target = bound || fieldEl.querySelector("input, select, textarea");
    if (!target) return null;

    if (target.shinyInputBinding && typeof target.shinyInputBinding.getValue === "function") {
      try {
        return target.shinyInputBinding.getValue(target);
      } catch (e) { /* fall through */ }
    }
    if (target.type === "checkbox") return target.checked;
    return target.value;
  };

  const readValue = (el) => {
    const prefix = el.dataset.rowPrefix || "row";
    const rows = el.querySelectorAll(".mdi-rows > .mdi-row");
    return {
      _prefix: prefix,
      rows: Array.prototype.map.call(rows, (row) => {
        const fields = row.querySelectorAll(".mdi-field[data-key]");
        return {
          fields: Array.prototype.map.call(fields, (f) => ({
            key: f.dataset.key,
            value: readField(f)
          }))
        };
      })
    };
  };

  // Build one row DOM node from the template, stamping a fresh row index into
  // every placeholder id so Shiny can bind each field uniquely.
  const buildRow = (el, rowIdx) => {
    const tpl = templateEl(el);
    if (!tpl) return null;
    const frag = tpl.content.cloneNode(true);
    const row = frag.querySelector(".mdi-row");
    row.dataset.rowIdx = String(rowIdx);

    row.querySelectorAll("[id]").forEach((node) => {
      node.id = node.id.replace(/__ROWIDX__/g, rowIdx);
    });
    row.querySelectorAll("[for]").forEach((node) => {
      node.setAttribute("for", node.getAttribute("for").replace(/__ROWIDX__/g, rowIdx));
    });
    // Some inputs (e.g. colourpicker) carry ids in data-* attributes.
    row.querySelectorAll("*").forEach((node) => {
      Array.prototype.forEach.call(node.attributes || [], (attr) => {
        if (attr.value && attr.value.indexOf("__ROWIDX__") !== -1) {
          node.setAttribute(attr.name, attr.value.replace(/__ROWIDX__/g, rowIdx));
        }
      });
    });

    return row;
  };

  const applyFieldValues = (row, fields) => {
    (fields || []).forEach((f) => {
      const fieldEl = row.querySelector(`.mdi-field[data-key='${f.key}']`);
      if (!fieldEl) return;
      const target = fieldEl.querySelector("input, select, textarea");
      if (!target) return;
      if (target.type === "checkbox") {
        target.checked = !!f.value;
      } else {
        target.value = f.value;
      }
    });
  };

  const safeBind = (node) => {
    if (typeof Shiny !== "undefined" && Shiny.bindAll) {
      try { Shiny.bindAll(node); } catch (e) {
        console.warn("[multiDynamicInput] bindAll error:", e);
      }
    }
  };
  const safeUnbind = (node) => {
    if (typeof Shiny !== "undefined" && Shiny.unbindAll) {
      try { Shiny.unbindAll(node); } catch (e) {
        console.warn("[multiDynamicInput] unbindAll error:", e);
      }
    }
  };

  // After Shiny.bindAll, some JS-heavy inputs (colourpicker, sliderInput)
  // need an extra nudge to initialize their widget UI on dynamically added DOM.
  const initSpecialInputs = (row) => {
    // colourpicker: if bindAll didn't fully initialize (no colourpicker-initialized
    // data), manually trigger it. The binding uses _jqid(el.id) which requires
    // the element to be in the DOM with a valid id.
    row.querySelectorAll("input.shiny-colour-input").forEach((input) => {
      if (typeof $ !== "undefined" && $.fn && $.fn.colourpicker && !$(input).data("colourpicker-initialized")) {
        var opts = {
          changeDelay: 0,
          showColour: $(input).attr("data-show-colour") || "both",
          palette: $(input).attr("data-palette") || "square",
          allowAlpha: $(input).attr("data-allow-alpha"),
          returnName: $(input).attr("data-return-name"),
          closeOnClick: $(input).attr("data-close-on-click")
        };
        var allowedCols = $(input).attr("data-allowed-cols");
        if (allowedCols) {
          try { opts.allowedCols = JSON.parse(allowedCols); } catch(e) {}
        }
        $(input).colourpicker(opts);
        var initVal = $(input).attr("data-init-value") || input.value || "#000000";
        $(input).colourpicker("value", initVal);
      }
    });
  };

  const addRow = (el, fields, callback) => {
    const data = getData(el);
    data.counter += 1;
    const row = buildRow(el, data.counter);
    if (!row) return;
    rowsContainer(el).appendChild(row);
    // Apply values before binding so JS-heavy inputs pick them up on init.
    if (fields) applyFieldValues(row, fields);
    safeBind(row);
    // Defer special input init slightly to ensure DOM is settled and
    // bindings have had a chance to run.
    setTimeout(function() { initSpecialInputs(row); }, 0);
    if (callback) setTimeout(callback, 10);
  };

  const removeRow = (row, callback) => {
    safeUnbind(row);
    row.remove();
    if (callback) callback();
  };

  const clearRows = (el, callback) => {
    const container = rowsContainer(el);
    Array.prototype.slice.call(container.querySelectorAll(".mdi-row"))
      .forEach((row) => {
        safeUnbind(row);
        row.remove();
      });
    if (callback) callback();
  };

  const setValue = (el, rows, callback) => {
    clearRows(el, null);
    (rows || []).forEach((r) => addRow(el, r.fields, null));
    if (callback) callback();
  };

  var _registerBinding = function () {
    if (typeof Shiny === "undefined" || !Shiny.InputBinding) {
      setTimeout(_registerBinding, 50);
      return;
    }
    var binding = new Shiny.InputBinding();

    $.extend(binding, {
      find: function (scope) {
        return $(scope).find(".multi-dynamic-input");
      },
      initialize: function (el) {
        // Defer seeding initial rows until after Shiny's first bind pass so we
        // don't call bindAll re-entrantly during initialization (which can
        // abort client init and blank out every output on the page).
        const data = getData(el);
        if ((data.initial || []).length) {
          setTimeout(function () {
            data.initial.forEach((r) => addRow(el, r.fields, null));
          }, 0);
        }
      },
      getValue: function (el) {
        return readValue(el);
      },
      setValue: function (el, value) {
        setValue(el, value, null);
      },
      receiveMessage: function (el, data) {
        if (data && data.clear) {
          clearRows(el, null);
        } else if (data && data.value) {
          setValue(el, data.value, null);
        }
        Shiny.setInputValue(
          el.id + ":VizModules.multiDynamicInput",
          readValue(el)
        );
      },
      subscribe: function (el, callback) {
        const $el = $(el);

        $el.on("click.multiDynamicInput", ".mdi-add", function (evt) {
          evt.preventDefault();
          addRow(el, null, callback);
        });

        $el.on("click.multiDynamicInput", ".mdi-delete", function (evt) {
          evt.preventDefault();
          const row = evt.currentTarget.closest(".mdi-row");
          if (row) removeRow(row, callback);
        });

        // Any field change inside a live row re-collects the value.
        $el.on("input.multiDynamicInput change.multiDynamicInput",
          ".mdi-rows input, .mdi-rows select, .mdi-rows textarea",
          function () { callback(); });
      },
      unsubscribe: function (el) {
        $(el).off(".multiDynamicInput");
      },
      getType: function () {
        return "VizModules.multiDynamicInput";
      }
    });

    Shiny.inputBindings.register(binding, "VizModules.multiDynamicInput");
  };
  _registerBinding();
})();
