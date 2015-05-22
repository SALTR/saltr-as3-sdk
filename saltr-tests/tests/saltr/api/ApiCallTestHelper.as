/**
 * Created by TIGR on 5/6/2015.
 */
package tests.saltr.api {
import flash.net.URLVariables;

import saltr.api.ApiCall;
import saltr.api.ApiCallResult;
import saltr.saltr_internal;

use namespace saltr_internal;

public class ApiCallTestHelper {
    public function ApiCallTestHelper() {
    }

    public static function validateCallParams(call:ApiCall, params:Object, action:String):Boolean {
        var isCallSuccess:Boolean = true;
        var callback:Function = function (result:ApiCallResult):void {
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
        var isObjectsEqual = areObjectsEqual(params, jsonParsed);

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
