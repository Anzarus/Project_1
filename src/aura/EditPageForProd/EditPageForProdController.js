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
    }
});