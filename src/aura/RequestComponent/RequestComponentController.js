/**
 * Created by AntonAntoniuk on 22.08.2019.
 */

({
    requestCallback: function (cmp, event, helper) {
        const parentCmp = cmp.get("v.parentCmp");

        const parameters = event.getParam('arguments');
        const apexMethodName = parameters.apexMethodName;
        const attributes = parameters.attributes;
        const successCallback = parameters.successCallback;
        const errorCallback = parameters.errorCallback;

        helper.doRequest(parentCmp, apexMethodName, attributes, helper, successCallback, errorCallback);
    },

    requestPromise: function (cmp, event, helper) {
        const parentCmp = cmp.get("v.parentCmp");

        const parameters = event.getParam('arguments');
        const apexMethodName = parameters.apexMethodName;
        const attributes = parameters.attributes;

        return helper.doPromiseRequest(parentCmp, apexMethodName, attributes);
    }
});