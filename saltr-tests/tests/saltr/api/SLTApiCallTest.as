/**
 * Created by TIGR on 5/8/2015.
 */
package tests.saltr.api {
import saltr.api.call.SLTApiCall;
import saltr.api.call.factory.SLTApiCallFactory;
import saltr.resource.SLTResource;
import saltr.saltr_internal;
import saltr.status.SLTStatus;

use namespace saltr_internal;

public class SLTApiCallTest {
    protected var _call:SLTApiCall;
    private var _callName:String;

    private var _apiFactory:SLTApiCallFactory;

    public function SLTApiCallTest(callName:String) {
        _callName = callName;
        _apiFactory = new SLTApiCallFactory();
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

    protected function getMobileCallRequestCompletedResult(successData:Object, failStatus:SLTStatus, resource:SLTResource):Boolean {
        createCallMobile();
        var isCallSuccess:Boolean = false;
        var successCallback:Function = function (data:Object):void {
            successData = data;
            isCallSuccess = true;
        };

        var failCallback:Function = function (status:SLTStatus):void {
            failStatus = status;
            isCallSuccess = false;
        };

        _call.call(getCorrectMobileCallParams(), successCallback, failCallback);
        _call.callRequestCompletedHandler(resource);

        return isCallSuccess;
    }

    protected function getWebCallRequestCompletedResult(successData:Object, failStatus:SLTStatus, resource:SLTResource):Boolean {
        createCallWeb();
        var isCallSuccess:Boolean = false;
        var successCallback:Function = function (data:Object):void {
            successData = data;
            isCallSuccess = true;
        };

        var failCallback:Function = function (status:SLTStatus):void {
            failStatus = status;
            isCallSuccess = false;
        };
        _call.call(getCorrectWebCallParams(), successCallback, failCallback);
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
