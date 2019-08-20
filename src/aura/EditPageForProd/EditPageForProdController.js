/**
 * Created by AntonAntoniuk on 16.08.2019.
 */

({
    cancel: function (cmp) {
        cmp.destroy();
    },

    handleSuccess: function (cmp, event, helper) {
        helper.showToast("Success!", "Product was updated!", "success");
        $A.get('e.force:refreshView').fire();
    },

    handleError: function (cmp, event, helper) {
        helper.showToast("Error!", "Unexpected error!", "error");
    }
});