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


        return helper.doPromiseRequest(parentCmp, apexMethodName, attributes)
            .then(
                function (data) {
                    console.log(data);
                    if (data.length === 0)
                        helper.showToast($A.get("$Label.c.inf"), $A.get("$Label.c.NoProdInOpp"), 'info');
                    else
                        parentCmp.set("v.data", data);
                })
            .catch(
                function (response) {
                    helper.checkOtherCases(response.getState(), response, helper);
                });
    }
});