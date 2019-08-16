/**
 * Created by AntonAntoniuk on 16.08.2019.
 */

({
    getProduct2: function (cmp) {
        const action = cmp.get("c.getCurrentProd");
        const prodId = cmp.get("v.prodId");
        action.setParams({prodId: prodId});

        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const prod = response.getReturnValue();
                console.log(prod);
                if (prod != null) {
                    cmp.set("v.prod", prod);
                    console.log("done");
                } else cmp.print("No elements");
            }
        });
        $A.enqueueAction(action);
    }
});