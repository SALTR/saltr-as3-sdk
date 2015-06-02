/**
 * Created by TIGR on 5/8/2015.
 */
package tests.saltr.api {
import saltr.api.SLTApiCall;
import saltr.api.SLTApiCallResult;
import saltr.api.SLTApiFactory;
import saltr.resource.SLTResource;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTApiCallTest {
    protected var _call:SLTApiCall;
    private var _callName:String;

    private var _apiFactory:SLTApiFactory;

    public function SLTApiCallTest(callName:String) {
        _callName = callName;
        _apiFactory = new SLTApiFactory();
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
        return SLTApiCallTestHelper.validateCallParams(_call, params, actionName);
    }

    protected function getMobileCallRequestCompletedResult(callResult:SLTApiCallResult, resource:SLTResource):Boolean {
        createCallMobile();
        var isCallSuccess:Boolean = false;
        var callback:Function = function (result:SLTApiCallResult):void {
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

    protected function getWebCallRequestCompletedResult(callResult:SLTApiCallResult, resource:SLTResource):Boolean {
        createCallWeb();
        var isCallSuccess:Boolean = false;
        var callback:Function = function (result:SLTApiCallResult):void {
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
