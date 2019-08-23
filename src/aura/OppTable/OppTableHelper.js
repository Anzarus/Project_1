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
        const childCmp =cmp.find("child");

        const auraMethodResult = childCmp.secondMethod(
            cmp,
            "getProduct2sOfOpp",
            {oppId}
        );
    },//todo

    deleteProdFromOpp: function (cmp, row) {
        const data = cmp.get("v.data");
        const rowIndex = data.indexOf(row);
        const oppId = cmp.get("v.recordId");
        const prodId = data[rowIndex].Id;
        const childCmp = cmp.find("child");

        const auraMethodResult = childCmp.firstMethod(
            cmp,
            "deleteProdFromOpp",
            {oppId, prodId},
            function (helper) {
                helper.showToast(
                    $A.get("$Label.c.success"),
                    $A.get("$Label.c.SuccDelProd1") + " "
                    + data[rowIndex].Name + " "
                    + $A.get("$Label.c.SuccDelProd2"),
                    'success'
                );
                $A.get('e.force:refreshView').fire();
            },
            function (state, response, helper) {
                helper.checkOtherCases(state, response, helper);
            }
        );
    },

    viewChangeWindow: function (cmp, prodId) {
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
                        this.showToast($A.get("$Label.c.err"), $A.get("$Label.c.off"), "error");
                    } else if (status === "ERROR") {
                        if (errMessage === '') errMessage = $A.get("$Label.c.GenErr");
                        this.showToast($A.get("$Label.c.err"), errMessage, 'error');
                    }
                }
            }
        );
    }//todo
});