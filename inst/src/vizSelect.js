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
