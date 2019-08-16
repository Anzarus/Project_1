/**
 * Created by AntonAntoniuk on 16.08.2019.
 */

({
    doInit: function (cmp, helper, event) {
        const action = cmp.get("c.getItemForId");
        action.setParams({Id: cmp.get("v.itemId")});

        console.log(action);

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                const item = response.getReturnValue();
                console.log(item);
                if (item.length != 0) {
                    cmp.set("v.item", item);
                    console.log("done");
                } else cmp.print("No elements");
            }
        });
        $A.enqueueAction(action);
    },

    cancel: function (cmp, helper, event) {
        cmp.destroy();
    }
});