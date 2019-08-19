/**
 * Created by AntonAntoniuk on 15.08.2019.
 */

({
    init: function (cmp, event, helper) {
        helper.setColumns(cmp);
        helper.getProdOfCurrOpp(cmp);
    },

    handleRowAction: function (cmp, event, helper) {
        const action = event.getParam('action');
        const row = event.getParam('row');
        const data = cmp.get("v.data");
        const rowIndex = data.indexOf(row);
        const prodId = data[rowIndex].Id;

        switch (action.name) {
            case 'delete':
                helper.deleteProdFromOpp(cmp, row);
                break;
            case 'edit':
                helper.viewChangeWindow(cmp, prodId, rowIndex);
                break;
        }
    },

    handleCompEvent: function (cmp, event, helper) {
        helper.getOneUpdatedProd(cmp, event);
    }
});