/**
 * Created by AntonAntoniuk on 22.08.2019.
 */

({
    firstMethod: function (cmp, event, helper) {
        const parameters = event.getParam('arguments');
        const parentCmp = parameters.parentCmp;
        const apexMethodName = parameters.apexMethodName;
        const attributes = parameters.attributes;
        const successCallback = parameters.successCallback;
        const errorCallback = parameters.errorCallback;

        helper.doRequest(parentCmp, apexMethodName, attributes, helper, successCallback, errorCallback);
    },

    secondMethod: function (cmp, event, helper) {
        const parameters = event.getParam('arguments');
        const parentCmp = parameters.parentCmp;
        const apexMethodName = parameters.apexMethodName;
        const attributes = parameters.attributes;



        const promise = helper.setControllerAndParams(parentCmp, apexMethodName, attributes, helper,function (helper, response) {
                if (response.getReturnValue().length === 0) {
                    helper.showToast($A.get("$Label.c.inf"), $A.get("$Label.c.NoProdInOpp"), 'info');
                }
            }, function (state, response, helper) {
                helper.checkOtherCases(state, response, helper);
            }
        );
        // const promise = new Promise(function (resolve, reject) {
        // });

        promise.then((successCallback, data) => {//todo
            if (successCallback) successCallback(helper, response);
            cmp.set("v.data", data);
        });

        return promise;
        /*      const action = cmp.get("c." + apexMethodName);
                action.setParams({json : JSON.stringify(attributes)});
                action.setCallback(this, function (response) {
                    const state = response.getState();
                    if (state === "SUCCESS") {
                        const data = response.getReturnValue();
                        if (data.length === 0) {
                            this.showToast($A.get("$Label.c.inf"), $A.get("$Label.c.NoProdInOpp"), 'info');
                        }
                        cmp.set("v.data", data);
                    } else this.checkOtherCases(state, response);
                });
                $A.enqueueAction(action);*/
    }
});