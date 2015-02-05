package saltr.api {
import flash.net.URLVariables;

import saltr.resource.SLTResource;
import saltr.saltr_internal;

use namespace saltr_internal;

public class LevelContentApiCall extends ApiCall{
    public function LevelContentApiCall(params:Object, isMobile:Boolean = true) {
        super(params, isMobile);
        _url = _params.levelContentUrl;
    }

    override protected function buildCall():URLVariables {
        return null;
    }

    override protected function callRequestCompletedHandler(resource:SLTResource):void {
        var content:Object = resource.jsonData;
        var apiCallResult:ApiCallResult = new ApiCallResult();
        apiCallResult.success = content != null;
        apiCallResult.data = content;
        _callback(apiCallResult);
    }

    override protected function validateMobileParams():Object {
        if (_params.levelContentUrl == null || _params.levelContentUrl == "") {
            return {isValid: false, message: "Field levelContentUrl is required"};
        }
        return {isValid: true};
    }
}
}