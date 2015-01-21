package saltr.api {
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.net.URLVariables;

import saltr.SLTConfig;

import saltr.resource.SLTResource;

import saltr.resource.SLTResourceURLTicket;

import saltr.saltr_internal;
use namespace saltr_internal;

public class ApiCall {

    protected var _url:String;
    protected var _params:Object;
    protected var _callback:Function;

    internal static function removeEmptyAndNullsJSONReplacer(k:*, v:*):* {
        if (v != null && v != "null" && v !== "") {
            return v;
        }
        return undefined;
    }

    internal static function getTicket(url:String, vars:URLVariables, timeout:int = 0):SLTResourceURLTicket {
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(url, vars);
        ticket.method = URLRequestMethod.POST;
        if (timeout > 0) {
            ticket.idleTimeout = timeout;
        }
        return ticket;
    }

    public function ApiCall(params:Object) {
        _params = params;
    }

    public function call(callback:Function, timeout:int = 0):void {
        _callback = callback;
        var urlVars:URLVariables = buildCall();
        doCall(urlVars, timeout);
    }

    private function doCall(urlVars:URLVariables, timeout:int):void {
        var ticket:SLTResourceURLTicket = ApiCall.getTicket(_url, urlVars, timeout);
        var resource:SLTResource = new SLTResource("apiCall", ticket, callRequestCompletedHandler, callRequestFailHandler);
        resource.load();
    }

    protected function callRequestCompletedHandler(resource:SLTResource):void {
        var jsonData:Object = resource.jsonData;
        var success:Boolean = false;
        var apiCallResult:ApiCallResult = new ApiCallResult();
        var response:Object;
        if (jsonData.hasOwnProperty("response")) {
            response = jsonData.response[0];
            success = response.success;
            if(success) {
                //sync();
                apiCallResult.data = response;
            } else {
                //_dialogController.showDeviceRegistrationFailStatus(response.error.message);
                apiCallResult.errorMessage = response.error.message;
                apiCallResult.errorCode = response.error.code;
            }
        }
        else {
            //_dialogController.showDeviceRegistrationFailStatus(DeviceRegistrationDialog.DLG_SUBMIT_FAILED);
            success = false;
            apiCallResult.errorMessage = "response.error.message";//TODO: TIGR fix this
            apiCallResult.errorCode = -1;//"response.error.code";//TODO: TIGR fix this
        }

        apiCallResult.success = success;
        resource.dispose();
        _callback(apiCallResult);
    }

    protected function callRequestFailHandler(resource:SLTResource):void {
        resource.dispose();
        _callback(new ApiCallResult());
    }


    protected function buildCall():URLVariables {
        throw new Error("abstract method call error");
    }
}
}