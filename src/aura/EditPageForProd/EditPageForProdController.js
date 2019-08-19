/**
 * Created by AntonAntoniuk on 16.08.2019.
 */

({
    doInit: function (cmp, event, helper) {
        helper.getProduct2(cmp);
    },

    cancel: function (cmp, event, helper) {
        cmp.destroy();
    },

    saveNewVariantOfProd: function (cmp, event, helper) {
        const oldProd = cmp.get("v.prod");
        const newName = cmp.get("v.newName");
        const newPrice = cmp.get("v.newPrice");
        if (oldProd.Price__c !== newPrice || oldProd.Name !== newName) {
            helper.updateCurrentProd(cmp, helper, newName, newPrice, oldProd.Id);
        } else {
            helper.showToast('Info', 'The record was not updated', 'info');
            cmp.cancel();
        }
    }
});