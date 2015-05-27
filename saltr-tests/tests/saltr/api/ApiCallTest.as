/**
 * Created by TIGR on 5/8/2015.
 */
package tests.saltr.api {
import saltr.api.ApiCall;
import saltr.api.ApiCallResult;
import saltr.api.ApiFactory;
import saltr.resource.SLTResource;
import saltr.saltr_internal;

use namespace saltr_internal;

public class ApiCallTest {
    protected var _call:ApiCall;
    private var _callName:String;

    private var _apiFactory:ApiFactory;

    public function ApiCallTest(callName:String) {
        _callName = callName;
        _apiFactory = new ApiFactory();
    }

    protected function createCallMobile():void {
        _call = _apiFactory.getCall(_callName, true);
    }

    protected function createCallWeb():void {
        _call = _apiFactory.getCall(_callName, false);
    }

    protected function clearCall():void {
        _call = null;
    }

    protected function validateParams(params:Object, actionName:String):Boolean {
        return ApiCallTestHelper.validateCallParams(_call, params, actionName);
    }

    protected function getMobileCallRequestCompletedResult(callResult:ApiCallResult, resource:SLTResource):Boolean {
        createCallMobile();
        var isCallSuccess:Boolean = false;
        var callback:Function = function (result:ApiCallResult):void {
            callResult = result;
            if (result.success) {
                isCallSuccess = true;
            } else {
                isCallSuccess = false;
            }
        };
        _call.call(getCorrectMobileCallParams(), callback);
        _call.callRequestCompletedHandler(resource);

        return isCallSuccess;
    }

    protected function getWebCallRequestCompletedResult(callResult:ApiCallResult, resource:SLTResource):Boolean {
        createCallWeb();
        var isCallSuccess:Boolean = false;
        var callback:Function = function (result:ApiCallResult):void {
            callResult = result;
            if (result.success) {
                isCallSuccess = true;
            } else {
                isCallSuccess = false;
            }
        };
        _call.call(getCorrectWebCallParams(), callback);
        _call.callRequestCompletedHandler(resource);

        return isCallSuccess;
    }

    protected function getCorrectMobileCallParams():Object {
        throw new Error("Virtual method error!");
    }

    protected function getCorrectWebCallParams():Object {
        throw new Error("Virtual method error!");
    }
}
}
