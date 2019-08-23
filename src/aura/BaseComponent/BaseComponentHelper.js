/**
 * Created by TetianaSakun on 31.07.2019.
 */

({
    constructLightningPromise: function () {
        return class LightningPromise extends Promise {
            constructor(resolver) {
                super($A.getCallback(resolver));
            };

            then(onFulfilled, onRejected) {
                super.then(onFulfilled ? $A.getCallback(onFulfilled) : undefined,
                    onRejected ? $A.getCallback(onRejected) : undefined);

            };

            catch(onRejected) {
                super.catch(onRejected ? $A.getCallback(onRejected) : undefined);
            };

            finally(onFinally) {
                super.finally(onFinally ? $A.getCallback(onFinally) : undefined);
            };
        }
    }
});