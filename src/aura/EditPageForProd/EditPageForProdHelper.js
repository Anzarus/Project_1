/**
 * Created by AntonAntoniuk on 16.08.2019.
 */

({
    getProduct2: function (cmp) {
        const prodId = cmp.get("v.prodId");
        const action = cmp.get("c.getCurrentProd");
        action.setParams({prodId: prodId});

        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const prod = response.getReturnValue();
                if (prod != null) {
                    cmp.set("v.prod", prod);
                } else {
                    this.showToast('Error!', 'Unexpected error!', 'error');
                }
            }
        });
        $A.enqueueAction(action);
    },

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