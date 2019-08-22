/**
 * Created by AntonAntoniuk on 22.08.2019.
 */

({
    showToast: function (title, message, variant) {
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: variant
        });
        toastEvent.fire();
    }
});