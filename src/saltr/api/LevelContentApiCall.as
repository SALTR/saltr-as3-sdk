package saltr.api {
import flash.net.URLVariables;

import saltr.resource.SLTResource;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class LevelContentApiCall extends ApiCall {
    public function LevelContentApiCall(params:Object, isMobile:Boolean = true) {
        super(params, isMobile);
        _url = _params.levelContentUrl;
    }

    override saltr_internal function buildCall():URLVariables {
        return null;
    }

    override saltr_internal function callRequestCompletedHandler(resource:SLTResource):void {
        var content:Object = resource.jsonData;
        var apiCallResult:ApiCallResult = new ApiCallResult();
        apiCallResult.success = content != null;
        apiCallResult.data = content;
        _callback(apiCallResult);
    }

    override saltr_internal function validateMobileParams():Object {
        if (_params.levelContentUrl == null || _params.levelContentUrl == "") {
            return {isValid: false, message: "Field levelContentUrl is required"};
        }
        return {isValid: true};
    }
}
}