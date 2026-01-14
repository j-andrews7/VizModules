(function () {
  if (typeof window.Shiny === "undefined") {
    return;
  }

  const parseJSON = (value, fallback) => {
    try {
      return JSON.parse(value);
    } catch (e) {
      return fallback;
    }
  };

  const normalizeHex = (value) => {
    if (value === null || value === undefined) return "";
    let val = String(value).trim();

    if (/^#[0-9a-fA-F]{3}$/.test(val)) {
      val = "#" + val.slice(1).split("").map((c) => c + c).join("");
    }

    if (!/^#[0-9a-fA-F]{6}$/.test(val)) {
      return "";
    }

    return val.toUpperCase();
  };

  const getData = (el) => {
    if (!el._multiColorData) {
      el._multiColorData = {
        palettes: parseJSON(el.dataset.palettes || "{}", {}),
        initial: parseJSON(el.dataset.initial || "{}", {}),
        groups: parseJSON(el.dataset.groups || "[]", []),
        defaultPalette: el.dataset.defaultPalette || null
      };
    }
    return el._multiColorData;
  };

  const getSelectedPalette = (el) => {
    const select = el.querySelector(".mc-palette-select");
    if (select && select.value) return select.value;
    const data = getData(el);
    return data.defaultPalette || Object.keys(data.palettes || {})[0] || null;
  };

  const markActiveRow = (row, el) => {
    if (!row) return;
    const rows = el.querySelectorAll(".mc-color-row");
    rows.forEach((r) => r.classList.remove("is-active"));
    row.classList.add("is-active");
  };

  const syncTextFromColor = (row) => {
    const colorInput = row.querySelector(".mc-color-input");
    const textInput = row.querySelector(".mc-text-input");
    if (colorInput && textInput) {
      textInput.value = (colorInput.value || "").toUpperCase();
    }
  };

  const setRowColor = (row, color, triggerChange = false) => {
    const normalized = normalizeHex(color) || "#000000";
    const colorInput = row.querySelector(".mc-color-input");
    const textInput = row.querySelector(".mc-text-input");

    if (colorInput) {
      colorInput.value = normalized;
      if (triggerChange) colorInput.dispatchEvent(new Event("change", { bubbles: true }));
    }
    if (textInput) {
      textInput.value = normalized;
      if (triggerChange) textInput.dispatchEvent(new Event("change", { bubbles: true }));
    }
  };

  const resetColors = (el) => {
    const data = getData(el);
    const rows = el.querySelectorAll(".mc-color-row");
    rows.forEach((row) => {
      const group = row.dataset.group || "";
      const color = data.initial[group];
      setRowColor(row, color, false);
    });
    const paletteName = data.defaultPalette || getSelectedPalette(el);
    const select = el.querySelector(".mc-palette-select");
    if (select && paletteName) {
      select.value = paletteName;
    }
    renderSwatches(el, paletteName);
  };

  const renderSwatches = (el, paletteName) => {
    const data = getData(el);
    const swatchRow = el.querySelector(".mc-swatch-row");
    if (!swatchRow) return;
    swatchRow.innerHTML = "";

    const palette = (data.palettes || {})[paletteName] || [];
    palette.forEach((color) => {
      const swatch = document.createElement("button");
      swatch.type = "button";
      swatch.className = "mc-swatch";
      swatch.dataset.color = normalizeHex(color);
      swatch.title = swatch.dataset.color;
      swatch.style.backgroundColor = swatch.dataset.color;
      swatch.setAttribute("aria-label", `Set color ${swatch.dataset.color}`);
      swatchRow.appendChild(swatch);
    });
  };

  const applyPalette = (el, paletteName) => {
    const data = getData(el);
    const palette = (data.palettes || {})[paletteName] || [];
    if (!palette || palette.length === 0) return;
    const rows = el.querySelectorAll(".mc-color-row");

    rows.forEach((row, idx) => {
      const color = palette[idx % palette.length];
      setRowColor(row, color, false);
    });
  };

  const initializeRows = (el) => {
    const rows = el.querySelectorAll(".mc-color-row");
    if (!rows.length) return;

    rows.forEach((row) => {
      const colorInput = row.querySelector(".mc-color-input");
      const textInput = row.querySelector(".mc-text-input");
      if (colorInput) {
        const normalized = normalizeHex(colorInput.value) || "#000000";
        colorInput.value = normalized;
        if (textInput) textInput.value = normalized;
      }
    });

    markActiveRow(rows[0], el);
    const defaultPalette = getSelectedPalette(el);
    renderSwatches(el, defaultPalette);
  };

  const binding = new Shiny.InputBinding();

  $.extend(binding, {
    find: function (scope) {
      return $(scope).find(".multi-color-picker");
    },
    initialize: function (el) {
      initializeRows(el);
    },
    getValue: function (el) {
      const rows = el.querySelectorAll(".mc-color-row");
      return Array.prototype.map.call(rows, (row) => ({
        name: row.dataset.group || "",
        value: (row.querySelector(".mc-color-input") || {}).value || ""
      }));
    },
    setValue: function (el, value) {
      const normalized = Array.isArray(value)
        ? value
        : Object.keys(value || {}).map((key) => ({ name: key, value: value[key] }));

      normalized.forEach((item) => {
        const row = el.querySelector(`.mc-color-row[data-group='${item.name}']`);
        if (row) setRowColor(row, item.value, false);
      });
    },
    receiveMessage: function (el, data) {
      if (data && data.value) {
        this.setValue(el, data.value);
      }
    },
    subscribe: function (el, callback) {
      const $el = $(el);

      $el.on("click.multiColorPicker", ".mc-color-row", function () {
        markActiveRow(this, el);
      });

      $el.on("input.multiColorPicker change.multiColorPicker", ".mc-color-input", function (evt) {
        const row = evt.currentTarget.closest(".mc-color-row");
        if (!row) return;
        syncTextFromColor(row);
        callback();
      });

      $el.on("input.multiColorPicker change.multiColorPicker", ".mc-text-input", function (evt) {
        const row = evt.currentTarget.closest(".mc-color-row");
        if (!row) return;
        const normalized = normalizeHex(evt.currentTarget.value);
        if (normalized) {
          setRowColor(row, normalized, false);
          callback();
        }
      });

      $el.on("change.multiColorPicker", ".mc-palette-select", function (evt) {
        renderSwatches(el, evt.target.value);
      });

      $el.on("click.multiColorPicker", ".mc-swatch", function (evt) {
        evt.preventDefault();
        const active = el.querySelector(".mc-color-row.is-active") || el.querySelector(".mc-color-row");
        if (!active) return;
        const color = evt.currentTarget.dataset.color;
        if (color) {
          setRowColor(active, color, false);
          callback();
        }
      });

      $el.on("click.multiColorPicker", ".mc-apply-palette", function (evt) {
        evt.preventDefault();
        applyPalette(el, getSelectedPalette(el));
        callback();
      });

      $el.on("click.multiColorPicker", ".mc-reset-palette", function (evt) {
        evt.preventDefault();
        resetColors(el);
        callback();
      });
    },
    unsubscribe: function (el) {
      $(el).off(".multiColorPicker");
    },
    getType: function () {
      return "vizModules.multiColorPicker";
    }
  });

  Shiny.inputBindings.register(binding, "vizModules.multiColorPicker");
})();
