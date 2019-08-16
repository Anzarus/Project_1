/**
 * Created by AntonAntoniuk on 16.08.2019.
 */

({
    doInit: function (cmp, helper, event) {
        helper.getProduct2(cmp);
    },

    cancel: function (cmp, helper, event) {
        cmp.destroy();
    }
});