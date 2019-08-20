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
        const action = cmp.get("c.getProduct2sOfOpp");
        action.setParams({oppId: oppId});

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
        $A.enqueueAction(action);
    },

    deleteProdFromOpp: function (cmp, row) {
        const data = cmp.get("v.data");
        const rowIndex = data.indexOf(row);
        const oppId = cmp.get("v.recordId");
        const prodId = data[rowIndex].Id;

        const action = cmp.get("c.deleteProdFromOpp");
        action.setParams({oppId: oppId, prodId: prodId});
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                data.splice(rowIndex, 1);
                cmp.set('v.data', data);
                $A.get('e.force:refreshView').fire();
                this.showToast($A.get("$Label.c.success"), $A.get("$Label.c.SuccDelProd1") + data[rowIndex].Name + $A.get("$Label.c.SuccDelProd2"), 'success');
            } else this.checkOtherCases(state, response);
        });
        $A.enqueueAction(action);
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
    },

    showToast: function (title, message, variant) {
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: variant
        });
        toastEvent.fire();
    },

    checkOtherCases: function (state, response) {
        if (state === "ERROR") {
            let errorMessage = response.getError();
            if (errorMessage === '') errorMessage = $A.get("$Label.c.GenErr");
            this.showToast($A.get("$Label.c.err"), errorMessage, 'error');
        } else {
            this.showToast($A.get("$Label.c.err"), $A.get("$Label.c.GenErr"), 'error');
        }
    }
});