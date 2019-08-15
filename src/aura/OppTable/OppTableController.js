/**
 * Created by AntonAntoniuk on 15.08.2019.
 */

({
    init: function (cmp, event, helper) {
        const actions = [
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'}
        ],
        fetchData = {
            name: 'productName'
        };

        cmp.set('v.columns', [
            {label: 'Product Name', fieldName: 'prodName', type: 'text'},
            {label: 'Price', fieldName: 'price', type: 'double'},
            {type: 'action', typeAttributes: {rowActions: actions}}
        ]);

        const action = cmp.get("c.getProduct2sofOpp");
        action.setCallback(this, (response) => {
            const state = response.getState();
            if (state === "SUCCESS") {
                const listOfProducts = response.getReturnValue();
                cmp.set("v.data", listOfProducts);
            }
        });

        $A.enqueueAction(action);
    },

    handleRowAction: function (cmp, event, helper) {
        const action = event.getParam('action');
        const row = event.getParam('row');

        switch (action.name) {
            case 'delete':
                helper.deleteProdFromOpp(cmp, row);
                break;
            case 'edit':
//todo
                break;
        }
    }
});