/**
 * Created by AntonAntoniuk on 22.08.2019.
 */

({
    doRequest: function (parentCmp, apexMethodName, attributes, helper, successCallback, errorCallback) {
        const action = parentCmp.get("c." + apexMethodName);
        action.setParams({json: JSON.stringify(attributes).toString()});
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                if (successCallback) successCallback(response.getReturnValue());
            } else {
                if (errorCallback) errorCallback(response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    doPromiseRequest: function (parentCmp, apexMethodName, attributes) {
        const action = parentCmp.get("c." + apexMethodName);
        action.setParams({json: JSON.stringify(attributes).toString()});

        return new Promise(function (resolve, reject) {
            action.setCallback(this, function (response) {
                const state = response.getState();
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue());
                } else {
                    reject(response.getError());
                }
            });
            $A.enqueueAction(action);
        });
    }
});