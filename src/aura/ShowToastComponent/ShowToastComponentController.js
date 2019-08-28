/**
 * Created by AntonAntoniuk on 28.08.2019.
 */

({
    showToast:function (cmp, event, helper) {
        const parameters = event.getParam("arguments");
        const title = parameters.title;
        const message = parameters.message;
        const variant =parameters.variant;
        helper.showToast(title, message, variant);
    }
});