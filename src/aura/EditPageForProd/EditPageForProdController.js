/**
 * Created by AntonAntoniuk on 16.08.2019.
 */

({
    doInit: function (cmp, event, helper) {
        helper.getProduct2(cmp);
    },

    cancel: function (cmp, event, helper) {
        const compEvent = cmp.getEvent("needToRefreshRecord");
        cmp.destroy();
        compEvent.fire();
    },

    handleSubmit: function (cmp, event, helper) {
        helper.showToast("Success!", "Product was updated!", "success");
    }
});