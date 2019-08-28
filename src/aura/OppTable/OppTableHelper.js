/**
 * Created by AntonAntoniuk on 15.08.2019.
 */

({
    setColumns: function (cmp) {
        const actions = [
            {label: $A.get("$Label.c.Edit"), name: 'edit'},
            {label: $A.get("$Label.c.Delete"), name: 'delete'}
        ];
        cmp.set('v.columns', [
            {label: $A.get("$Label.c.ProdName"), fieldName: 'Name', type: 'text'},
            {label: $A.get("$Label.c.Price"), fieldName: 'Price__c', type: 'currency'},
            {type: 'action', typeAttributes: {rowActions: actions}}
        ]);
    },

    getProdOfCurrOpp: function (cmp) {
        const oppId = cmp.get("v.recordId");

        const requestCmp = cmp.find("requestCmp");
        const toastCmp = cmp.find("toastCmp");

        const auraMethodResult = requestCmp.requestPromise(
            "getProduct2sOfOpp",
            {oppId: oppId}
        );

        auraMethodResult.then(
            function (result) {
                if (result.length === 0)
                    toastCmp.showToast($A.get("$Label.c.inf"), $A.get("$Label.c.NoProdInOpp"), 'info');
                else
                    cmp.set("v.data", result);
            })
            .catch(
                function (errors) {
                    let errorMessage = errors[0].message;
                    if (errorMessage === '') errorMessage = $A.get("$Label.c.GenErr");
                    toastCmp.showToast($A.get("$Label.c.err"), errorMessage, 'error');
                });


    },

    deleteProdFromOpp: function (cmp, row) {
        const data = cmp.get("v.data");
        const rowIndex = data.indexOf(row);
        const oppId = cmp.get("v.recordId");
        const prodId = data[rowIndex].Id;

        const requestCmp = cmp.find("requestCmp");
        const toastCmp = cmp.find("toastCmp");

        requestCmp.requestCallback(
            "deleteProdFromOpp",
            {oppId: oppId, prodId: prodId},
            function () {
                toastCmp.showToast($A.get("$Label.c.success"),
                    $A.get("$Label.c.SuccDelProd1") + " "
                    + data[rowIndex].Name + " "
                    + $A.get("$Label.c.SuccDelProd2"),
                    'success');
                $A.get('e.force:refreshView').fire();
            },
            function (errors) {
                let errorMessage = errors[0].message;
                if (errorMessage === '') errorMessage = $A.get("$Label.c.GenErr");
                toastCmp.showToast($A.get("$Label.c.err"), errorMessage, 'error');
            }
        );
    },

    viewChangeWindow: function (cmp, prodId) {
        const toastCmp = cmp.find("toastCmp");

        $A.createComponent(
            "c:EditPageForProd", {
                "prodId": prodId
            },
            function (Modal, status, errMessage) {
                if (cmp.isValid()) {
                    if (status === "SUCCESS") {
                        const cmpBody = cmp.get("v.cmpBody");
                        cmpBody.push(Modal);
                        cmp.set("v.cmpBody", cmpBody);
                    } else if (status === "INCOMPLETE") {
                        toastCmp.showToast($A.get("$Label.c.err"), $A.get("$Label.c.off"), "error");
                    } else if (status === "ERROR") {
                        if (errMessage === '') errMessage = $A.get("$Label.c.GenErr");
                        toastCmp.showToast($A.get("$Label.c.err"), errMessage, 'error');
                    }
                }
            }
        );
    }
});