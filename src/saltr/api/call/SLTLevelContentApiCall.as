package saltr.api.call {
import flash.net.URLVariables;

import saltr.game.SLTLevel;
import saltr.resource.SLTResource;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTLevelContentApiCall extends SLTApiCall {
    public function SLTLevelContentApiCall(isMobile:Boolean = true) {
        super(isMobile);
    }

    override saltr_internal function validateMobileParams():Object {
        return validateLevelContentUrl();
    }

    override saltr_internal function validateWebParams():Object {
        return validateLevelContentUrl();
    }

    override saltr_internal function buildCall():URLVariables {
        var level:SLTLevel = _params.sltLevel;
        var levelContentUrl:String = level.contentUrl + "?_time_=" + new Date().getTime();
        _url = levelContentUrl;
        return null;
    }

    override saltr_internal function callRequestCompletedHandler(resource:SLTResource):void {
        var content:Object = resource.jsonData;
        var apiCallResult:SLTApiCallLevelContentResult = new SLTApiCallLevelContentResult();
        apiCallResult.success = content != null;
        apiCallResult.data = content;
        apiCallResult.featureToken = _params.featureToken;
        apiCallResult.level = _params.sltLevel;
        _handler.handle(apiCallResult);
    }

    private function validateLevelContentUrl():Object {
        var level:SLTLevel = _params.sltLevel;
        var contentURL:String = level.contentUrl;
        var featureToken:String = _params.featureToken;
        if (level == null || contentURL == null || contentURL == "" || featureToken == null || featureToken == "") {
            return {isValid: false, message: "Incomplete SLTLevel passed."};
        }
        return {isValid: true};
    }
}
}