package saltr.api {
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.net.URLVariables;

import saltr.SLTConfig;

import saltr.resource.SLTResource;

import saltr.resource.SLTResourceURLTicket;

import saltr.saltr_internal;
import saltr.status.SLTStatus;

use namespace saltr_internal;

public class ApiCall {

    protected var _url:String;
    protected var _params:Object;
    protected var _callback:Function;
    protected var _isMobile:Boolean;

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

    public function ApiCall(params:Object, isMobile:Boolean = true) {
        _params = params;
        _isMobile = isMobile;
    }

    public function call(callback:Function, timeout:int = 0):void {
        _callback = callback;
        var validationResult : Object = validateParams();
        if(validationResult.isValid == false) {
            returnValidationFailedResult(validationResult.message);
            return;
        }
        var urlVars:URLVariables = buildCall();
        doCall(urlVars, timeout);
    }

    private function returnValidationFailedResult(message:String):void {
        var apiCallResult : ApiCallResult = new ApiCallResult();
        apiCallResult.success = false;
        apiCallResult.status = new SLTStatus(SLTStatus.API_ERROR, message);
        _callback(apiCallResult);
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
                apiCallResult.data = response;
            } else {
                apiCallResult.status = new SLTStatus(response.error.code, response.error.message);
            }
        }
        else {
            var status:SLTStatus = new SLTStatus(SLTStatus.API_ERROR, "unknown API error: 'response' node is missing");
            apiCallResult.status = status;
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

    //TODO::daal. Now it is just an plain Object. Will be replaced with ValidationResult object...
    protected function validateParams():Object {
        if (_isMobile) {
            return validateMobileParams();
        }
        else {
            //TODO::@daal web case implement...
            return validateWebParams();
        }
    }

    protected function validateMobileParams():Object {
        throw new Error("abstract method call error");
    }

    protected function validateWebParams():Object {
        throw new Error("abstract method call error");
    }
}
}