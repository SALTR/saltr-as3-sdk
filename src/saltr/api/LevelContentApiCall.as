package saltr.api {
import flash.net.URLVariables;

import saltr.resource.SLTResource;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class LevelContentApiCall extends ApiCall {
    public function LevelContentApiCall(isMobile:Boolean = true) {
        super(isMobile);
    }

    override saltr_internal function validateMobileParams():Object {
        return validateLevelContentUrl();
    }

    override saltr_internal function validateWebParams():Object {
        return validateLevelContentUrl();
    }

    override saltr_internal function buildCall():URLVariables {
        _url = _params.levelContentUrl;
        return null;
    }

    override saltr_internal function callRequestCompletedHandler(resource:SLTResource):void {
        var content:Object = resource.jsonData;
        var apiCallResult:ApiCallResult = new ApiCallResult();
        apiCallResult.success = content != null;
        apiCallResult.data = content;
        _callback(apiCallResult);
    }

    private function validateLevelContentUrl():Object {
        if (_params.levelContentUrl == null || _params.levelContentUrl == "") {
            return {isValid: false, message: "Field levelContentUrl is required"};
        }
        return {isValid: true};
    }
}
}