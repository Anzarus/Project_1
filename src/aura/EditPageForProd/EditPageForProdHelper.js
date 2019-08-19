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
                    cmp.set("v.newName", prod.Name);
                    cmp.set("v.newPrice", prod.Price__c);
                } else {
                    cmp.print("No elements");
                }
            }
        });
        $A.enqueueAction(action);
    },

    updateCurrentProd:function(cmp, helper, newName, newPrice, prodId){
        const rowIndex = cmp.get("v.rowIndex");
        const action = cmp.get("c.setNewParamOfProduct2");
        action.setParams({name: newName, price: newPrice, prodId: prodId});
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const compEvent = cmp.getEvent("needToRefreshRecord");
                compEvent.setParams({rowIndex: rowIndex});

                helper.showToast('Success!','The record was updated!','success');
                compEvent.fire();
                cmp.destroy();
                $A.get('e.force:refreshView').fire();
            } else {
                helper.showToast('Error!','Unexpected error!','error');
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function (title, message, variant) {
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            variant: variant
        });
        toastEvent.fire();
    }
});