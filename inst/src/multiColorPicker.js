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

    if (/^#[0-9a-fA-F]{3,4}$/.test(val)) {
      const body = val.slice(1).split("").map((c) => c + c).join("");
      val = `#${body}`;
    }

    if (!/^#[0-9a-fA-F]{6}([0-9a-fA-F]{2})?$/.test(val)) {
      return "";
    }

    const upper = val.toUpperCase();
    if (upper.length === 9) {
      return `#${upper.slice(1, 7)}`;
    }

    return upper;
  };

  const stripAlpha = (hex) => {
    const norm = normalizeHex(hex);
    if (!norm) return "";
    if (norm.length === 9) return `#${norm.slice(1, 7)}`;
    return norm;
  };

  const readableTextColor = (hex) => {
    const val = normalizeHex(hex) || "#000000";
    const r = parseInt(val.substr(1, 2), 16);
    const g = parseInt(val.substr(3, 2), 16);
    const b = parseInt(val.substr(5, 2), 16);
    const luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    return luminance > 0.6 ? "#111111" : "#ffffff";
  };

  const getData = (el) => {
    if (!el._multiColorData) {
      el._multiColorData = {
        palettes: parseJSON(el.dataset.palettes || "{}", {}),
        initial: parseJSON(el.dataset.initial || "{}", {}),
        groups: parseJSON(el.dataset.groups || "[]", []),
        defaultPalette: el.dataset.defaultPalette || null,
        compact: (el.dataset.compact || "false") === "true"
      };
    }
    return el._multiColorData;
  };

  const getSelectedPalette = (el) => {
    const select = el.querySelector(".mc-palette-select");
    if (select && select._mcSelectize) {
      const val = select._mcSelectize.getValue();
      if (val) return val;
    }
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
      const value = (row.dataset.value || colorInput.value || "").toUpperCase();
      textInput.value = value;
    }
  };

  const setRowColor = (row, color, triggerChange = false) => {
    const normalized = normalizeHex(color) || "#000000";
    const colorInput = row.querySelector(".mc-color-input");
    const textInput = row.querySelector(".mc-text-input");
    const opaqueHex = normalized.length === 9 ? `#${normalized.slice(1, 7)}` : normalized;

    row.dataset.value = normalized;

    if (colorInput) {
      colorInput.value = opaqueHex;
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
      if (select._mcSelectize) {
        select._mcSelectize.setValue(paletteName, true);
      } else {
        select.value = paletteName;
      }
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
      swatch.dataset.color = stripAlpha(color);
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
    const data = getData(el);

    rows.forEach((row) => {
      const group = row.dataset.group || "";
      const initial = data.initial[group] || (row.querySelector(".mc-color-input") || {}).value || "#000000";
      setRowColor(row, initial, false);
    });

    markActiveRow(rows[0], el);
    const defaultPalette = getSelectedPalette(el);
    renderSwatches(el, defaultPalette);
  };

  const enhancePaletteSelect = (el) => {
    const select = el.querySelector(".mc-palette-select");
    const hasSelectize = typeof $ !== "undefined" && $.fn && $.fn.selectize;
    if (!select || select._mcEnhanced || !hasSelectize) return;

    const data = getData(el);
    const palettes = data.palettes || {};
    const optgroups = [];
    const seenGroups = new Set();
    const options = [];

    select.querySelectorAll("option").forEach((opt) => {
      const parent = opt.parentElement;
      const group = parent && parent.tagName.toLowerCase() === "optgroup"
        ? parent.getAttribute("label")
        : null;
      const colors = (palettes[opt.value] || []).map(stripAlpha).filter(Boolean);

      if (group && !seenGroups.has(group)) {
        optgroups.push({ value: group, label: group });
        seenGroups.add(group);
      }

      options.push({
        value: opt.value,
        text: opt.textContent,
        optgroup: group,
        colors,
        headColor: colors[0] || "#6c757d"
      });
    });

    const instance = $(select).selectize({
      options,
      optgroups,
      optgroupField: "optgroup",
      labelField: "text",
      searchField: ["text"],
      dropdownParent: "body",
      render: {
        option: function (item, escape) {
          const swatches = (item.colors || [])
            .map((color) => `<span class="mc-option-swatch" style="background:${color}" title="${color}"></span>`)
            .join("");

          return `
            <div class="mc-palette-option">
              <span class="mc-palette-name" style="color:${readableTextColor(item.headColor)};">${escape(item.text)}</span>
              <span class="mc-palette-bar">${swatches}</span>
            </div>
          `;
        },
        item: function (item, escape) {
          const swatches = (item.colors || [])
            .map((color) => `<span class="mc-option-swatch" style="background:${color}" title="${color}"></span>`)
            .join("");

          return `
            <div class="mc-selected-item">
              <span class="mc-palette-name" style="color:${readableTextColor(item.headColor)};">${escape(item.text)}</span>
              <span class="mc-palette-bar">${swatches}</span>
            </div>
          `;
        }
      },
      onInitialize() {
        select._mcEnhanced = true;
      },
      onChange(value) {
        renderSwatches(el, value);
      },
      onDropdownOpen() {
        const width = select.getBoundingClientRect().width;
        if (instance.$dropdown && width) {
          instance.$dropdown.css("min-width", `${width}px`);
        }
        if (instance.$dropdown && data.compact) {
          instance.$dropdown.addClass("mc-compact");
        }
      }
    })[0].selectize;

    const defaultPalette = getSelectedPalette(el);
    if (defaultPalette) {
      instance.setValue(defaultPalette, true);
    }

    select._mcSelectize = instance;
  };

  const binding = new Shiny.InputBinding();

  $.extend(binding, {
    find: function (scope) {
      return $(scope).find(".multi-color-picker");
    },
    initialize: function (el) {
      initializeRows(el);
      enhancePaletteSelect(el);
    },
    getValue: function (el) {
      const rows = el.querySelectorAll(".mc-color-row");
      return Array.prototype.map.call(rows, (row) => ({
        name: row.dataset.group || "",
        value: row.dataset.value || (row.querySelector(".mc-color-input") || {}).value || ""
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
        row.dataset.value = (evt.currentTarget.value || "").toUpperCase();
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
