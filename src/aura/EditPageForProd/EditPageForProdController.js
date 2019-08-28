/**
 * Created by AntonAntoniuk on 16.08.2019.
 */

({
    cancel: function (cmp) {
        cmp.destroy();
    },

    handleSuccess: function (cmp) {
        const toastCmp = cmp.find("toastCmp");

        toastCmp.showToast($A.get("$Label.c.success"), $A.get("$Label.c.ProdUpdated"), "success");
        $A.get('e.force:refreshView').fire();
    }
});