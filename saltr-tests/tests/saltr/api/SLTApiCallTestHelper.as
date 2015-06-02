/**
 * Created by TIGR on 5/6/2015.
 */
package tests.saltr.api {
import flash.net.URLVariables;

import saltr.api.SLTApiCall;
import saltr.api.SLTApiCallResult;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTApiCallTestHelper {
    public function SLTApiCallTestHelper() {
    }

    public static function validateCallParams(call:SLTApiCall, params:Object, action:String):Boolean {
        var isCallSuccess:Boolean = true;
        var callback:Function = function (result:SLTApiCallResult):void {
            if (result.success) {
                isCallSuccess = true;
            } else {
                isCallSuccess = false;
            }
        };

        call.call(params, callback);

        var urlVars:URLVariables = call.buildCall();
        var jsonParsed:Object = JSON.parse(urlVars.args);

        var isCallActionCorrect:Boolean = action === urlVars.action;
        //var paramsValues:String = JSON.stringify(params, ApiCall.removeEmptyAndNullsJSONReplacer);
        var isObjectsEqual:Boolean = areObjectsEqual(params, jsonParsed);

        return isCallSuccess && isObjectsEqual && isCallActionCorrect;
    }

    internal static function areObjectsEqual(a:Object, b:Object):Boolean {
        if (a === null || a is Number || a is Boolean || a is String) {
            // Primitive value comparison
            return a === b;
        } else {
            var p:*;
            for (p in a) {
                // a and b values for p check
                if (!areObjectsEqual(a[p], b[p])) {
                    return false;
                }
            }
            return true;
        }
    }
}
}
