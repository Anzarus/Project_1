/**
 * Created by AntonAntoniuk on 22.08.2019.
 */

({
    showToast: function (title, message, variant) {
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: variant
        });
        toastEvent.fire();
    },

    checkOtherCases: function (state, response, helper) {
        if (state === 'ERROR') {
            let errorMessage = response.getError()[0].message;
            console.log(response.getError()[0]);
            if (errorMessage === '') errorMessage = $A.get("$Label.c.GenErr");
            helper.showToast($A.get("$Label.c.err"), errorMessage, 'error');
        } else {
            helper.showToast($A.get("$Label.c.err"), $A.get("$Label.c.GenErr"), 'error');
        }
    },

    doRequest: function (parentCmp, apexMethodName, attributes, helper, successCallback, errorCallback) {
        const action = parentCmp.get("c." + apexMethodName);
        action.setParams({json: JSON.stringify(attributes).toString()});
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                if (successCallback) successCallback(helper, response);
            } else {
                if (errorCallback) errorCallback(state, response, helper);
            }
            return response.getReturnValue();
        });
        $A.enqueueAction(action);
    }
});