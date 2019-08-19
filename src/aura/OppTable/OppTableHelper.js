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
            {label: 'Product Name', fieldName: 'Name', type: 'text'},
            {label: 'Price', fieldName: 'Price__c', type: 'currency'},
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
                    this.showToast('Info','There is no products in opportunity','info');
                }
                cmp.set("v.data", data);
            } else {
                this.showToast('Error!', 'Unexpected error!', 'error');
            }
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
            } else {
                this.showToast('Error!', 'Unexpected error!', 'error');
            }
        });
        $A.enqueueAction(action);
    },

    viewChangeWindow: function (cmp, prodId, rowIndex) {

        $A.createComponent(
            "c:EditPageForProd", {
                "prodId": prodId,
                "rowIndex": rowIndex
            },
            function (myModal) {
                if (cmp.isValid()) {
                    const targetCmp = cmp.find('ModalDiv');
                    const body = targetCmp.get("v.body");
                    body.push(myModal);
                    targetCmp.set("v.body", body);
                }
            }
        );
    },

    getOneUpdatedProd: function (cmp, event) {
        const rowIndex = event.getParam("rowIndex");
        const data = cmp.get("v.data");

        const action = cmp.get("c.getUpdatedProduct2s");
        action.setParams({prodId: data[rowIndex].Id});

        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                data[rowIndex] = response.getReturnValue();
                cmp.set("v.data", data);
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function (title, message, variant) {
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: variant
        });
        toastEvent.fire();
    }
});