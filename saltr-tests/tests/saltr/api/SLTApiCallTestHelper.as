/**
 * Created by TIGR on 5/6/2015.
 */
package tests.saltr.api {
import flash.net.URLVariables;

import saltr.api.call.SLTApiCall;
import saltr.saltr_internal;
import saltr.status.SLTStatus;

use namespace saltr_internal;

public class SLTApiCallTestHelper {
    public function SLTApiCallTestHelper() {
    }

    public static function validateCallParams(call:SLTApiCall, params:Object, action:String):Boolean {
        var isCallSuccess:Boolean = true;
        var successCallback:Function = function (data:Object):void {
            isCallSuccess = true;
        };

        var failCallback:Function = function (status:SLTStatus):void {
            isCallSuccess = false;
        };

        call.call(params, successCallback, failCallback);

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
