package saltr.api.call {
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import saltr.resource.SLTResource;
import saltr.resource.SLTResourceURLTicket;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTLevelContentApiCall extends SLTApiCall {
    private var _deserializeLevelContent;

    public function SLTLevelContentApiCall(isMobile:Boolean = true, deserializeLevelContent:Boolean = false) {
        super(isMobile);
        _deserializeLevelContent = deserializeLevelContent;
    }

    override saltr_internal function validateMobileParams():Object {
        return validateLevelContentUrl();
    }

    override saltr_internal function validateWebParams():Object {
        return validateLevelContentUrl();
    }

    override saltr_internal function buildCall():URLVariables {
        _url = _params.contentUrl + "?_time_=" + new Date().getTime();
        return null;
    }

    override saltr_internal function getURLTicket(urlVars:URLVariables, timeout:int):SLTResourceURLTicket {
        return SLTApiCall.getTicket(_url, urlVars, timeout, URLRequestMethod.GET);
    }

    override saltr_internal function callRequestCompletedHandler(resource:SLTResource):void {
        var apiCallResult:SLTApiCallResult = new SLTApiCallResult();
        apiCallResult.success = resource.data != null;
        apiCallResult.data= _deserializeLevelContent ? resource.jsonData : resource.data;
        handleResult(apiCallResult);
    }

    private function validateLevelContentUrl():Object {
        var contentURL:String = _params.contentUrl;
        if (contentURL == null || contentURL == "") {
            return {isValid: false, message: "Missing contentUrl."};
        }
        return {isValid: true};
    }
}
}