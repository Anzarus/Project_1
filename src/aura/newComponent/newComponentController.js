/**
 * Created by AntonAntoniuk on 22.08.2019.
 */

({
    firstMethod: function (cmp, event, helper) {
        const parametrs = event.getParam('arguments');
        const apexMethodName = parametrs.apexMethodName;
        const params = parametrs.params;
        const successCallback = parametrs.successCallback;
        const errorCallback = parametrs.errorCallback;
        const parentCmp = parametrs.parentCmp;

        console.log(params);

        const action = parentCmp.get("c." + apexMethodName);//todo який саме cmp треба викликати
        action.setParams({paramToStr: params.toString()});
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                if (successCallback) successCallback(response.getReturnValue());
            } else if (state === "ERROR") {
                if (errorCallback) errorCallback(response.getReturnValue());
            } else {
                helper.showToast($A.get("$Label.c.err"), $A.get("$Label.c.GenErr"), 'error');
            }
        });
        $A.enqueueAction(action);
    },

    secondMethod: function (cmp, event, helper) {
        const apexMethodName = event.getParam("apexMethodName");
        const attributes = event.getParam("attributes");

    }
});