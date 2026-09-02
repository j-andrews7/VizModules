// Bootstrap 3's modal keeps focus trapped inside the dialog: any focusin on an
// element outside the modal is bounced straight back to it. viz_select_input()
// renders its dropdown on <body> (so it is not clipped by panels or tabsets),
// which means the dropdown's search box lives outside the modal and would be
// impossible to type into. Bootstrap receives that focusin as a jQuery
// simulated event, which a native listener cannot intercept, so patch
// enforceFocus to whitelist the dropdown instead.
(function ($) {
    if (!$) {
        return;
    }

    // Deferred to DOM ready so Bootstrap's own script has been evaluated.
    $(function () {
        if (!$.fn.modal || !$.fn.modal.Constructor) {
            return;
        }

        var proto = $.fn.modal.Constructor.prototype;
        if (typeof proto.enforceFocus !== "function") {
            return;
        }

        proto.enforceFocus = function () {
            var modal = this;
            $(document)
                .off("focusin.bs.modal")
                .on("focusin.bs.modal", function (e) {
                    var target = e.target;
                    if (
                        target &&
                        typeof target.closest === "function" &&
                        target.closest(".vscomp-dropbox-container")
                    ) {
                        return;
                    }
                    if (
                        document !== target &&
                        modal.$element[0] !== target &&
                        !modal.$element.has(target).length
                    ) {
                        modal.$element.trigger("focus");
                    }
                });
        };
    });
})(window.jQuery);

// shinyWidgets' virtual-select binding subscribes to `change` only when
// data-update == "change"; otherwise it listens for `afterClose`/`reset` alone
// (see its virtual-select.js). viz_select_input() deliberately uses "close" for
// multi-selects so ticking several boxes in one visit costs one reactive update
// rather than one per tick.
//
// But a multi-select also renders its values as tags, and the x on a tag (and
// the clear-all x) mutates the selection *without* ever opening the dropdown.
// Those fire `change` and nothing else, so with updateOn "close" the removal was
// silently dropped: the control showed the value gone while the server still
// held the old selection.
//
// This has to be a **capture-phase** listener. virtual-select's own handler runs
// `e.stopPropagation()` before removing the value:
//
//     if (t.closest(".vscomp-value-tag-clear-button"))
//         return e.stopPropagation(), void this.removeValue(...)
//
// so a bubble-phase (or jQuery-delegated) listener on document never sees the
// click at all. Capture runs on the way down, before the target's own handler,
// so stopPropagation cannot suppress it.
(function ($) {
    if (!$ || !document.addEventListener) {
        return;
    }

    document.addEventListener(
        "click",
        function (e) {
            var target = e.target;
            if (!target || typeof target.closest !== "function") {
                return;
            }
            var button = target.closest(
                ".vscomp-value-tag-clear-button, .vscomp-clear-button"
            );
            if (!button) {
                return;
            }
            var el = button.closest(".virtual-select");
            // "change" selects already report every mutation themselves.
            if (!el || el.getAttribute("data-update") === "change") {
                return;
            }
            // Deferred so virtual-select has applied the removal first; the
            // binding reads the element's current value when notified.
            setTimeout(function () {
                $(el).trigger("afterClose");
            }, 0);
        },
        true
    );
})(window.jQuery);
