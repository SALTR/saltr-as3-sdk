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
public class SLTLocaleContentApiCall extends SLTApiCall {
    private var _deserializeLocaleContent:Boolean;
    private var _alternateUrl:String;

    public function SLTLocaleContentApiCall(isMobile:Boolean = true, deserializeLocaleContent:Boolean = false) {
        super(isMobile);
        _deserializeLocaleContent = deserializeLocaleContent;
    }

    override saltr_internal function validateMobileParams():Object {
        return validateLocaleContentUrl();
    }

    override saltr_internal function validateWebParams():Object {
        return validateLocaleContentUrl();
    }

    override saltr_internal function buildCall():URLVariables {
        _url = _params.contentUrl;
        _alternateUrl = _params.alternateUrl;
        return null;
    }

    override saltr_internal function getURLTicket(urlVars:URLVariables, timeout:int):SLTResourceURLTicket {
        var resourceURLTicket:SLTResourceURLTicket = SLTApiCall.getTicket(_url, urlVars, timeout, URLRequestMethod.GET);
        resourceURLTicket.maxAttempts = 1;
        return resourceURLTicket;
    }

    override saltr_internal function callRequestFailHandler(resource:SLTResource):void {
        if (_alternateUrl) {
            var ticket:SLTResourceURLTicket = new SLTResourceURLTicket(_alternateUrl);
            ticket.dropTimeout = _dropTimeout;
            ticket.timeoutIncrease = _timeoutIncrease;
            new SLTResource("apiCallAlternate", ticket, alternateCallRequestCompletedHandler, alternateCallRequestFailHandler).load();
        }
        else {
            alternateCallRequestFailHandler(resource);
        }
    }

    private function alternateCallRequestCompletedHandler(resource:SLTResource):void {
        callRequestCompletedHandler(resource);
    }

    private function alternateCallRequestFailHandler(resource:SLTResource):void {
        super.saltr_internal::callRequestFailHandler(resource);
    }

    override saltr_internal function callRequestCompletedHandler(resource:SLTResource):void {
        var apiCallResult:SLTApiCallResult = new SLTApiCallResult();
        apiCallResult.success = resource.data != null;
        apiCallResult.data = _deserializeLocaleContent ? resource.jsonData : resource.data;
        handleResult(apiCallResult);
    }

    private function validateLocaleContentUrl():Object {
        var contentURL:String = _params.contentUrl;
        if (contentURL == null || contentURL == "") {
            return {isValid: false, message: "Missing contentUrl."};
        }
        return {isValid: true};
    }
}
}