/**
 * Created by AntonAntoniuk on 16.08.2019.
 */

({
    cancel: function (cmp) {
        cmp.destroy();
    },

    handleSuccess: function (cmp, event, helper) {
        helper.showToast($A.get("$Label.c.success"), $A.get("$Label.c.ProdUpdated"), "success");
        $A.get('e.force:refreshView').fire();
    },

    handleError: function (cmp, event, helper) {
        let errorMessage = event.getParam("message");
        if (errorMessage === '') errorMessage = $A.get("$Label.c.GenErr");
        helper.showToast($A.get("$Label.c.err"), errorMessage, 'error');
    }
});