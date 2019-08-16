/**
 * Created by AntonAntoniuk on 15.08.2019.
 */

({
    setColumns: function (cmp) {
        const actions = [
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'}
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
                cmp.set("v.data", data);
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
            }
        });
        $A.enqueueAction(action);
    },

    viewChangeWindow: function (cmp, prodId) {

        $A.createComponent(
            "c:EditPageForProd", {
                "prodId": prodId
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
    }
});