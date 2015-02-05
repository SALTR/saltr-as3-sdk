package saltr.api {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.SLTSaltrMobile;

public class AddPropertiesApiCall extends ApiCall {

    public function AddPropertiesApiCall(params:Object, isMobile:Boolean = true):void {
        super(params,isMobile);
        _url = SLTConfig.SALTR_API_URL;
    }

    override protected function validateMobileParams():Object {
        if (_params.deviceId == null) {
            return {isValid: false, message: "Field deviceId is required"};
        }
        return {isValid: true};
    }

    override protected function buildCall():URLVariables {
        var urlVars:URLVariables = new URLVariables();
        var args:Object = {};
        urlVars.action = SLTConfig.ACTION_ADD_PROPERTIES;

        args.apiVersion = SLTSaltrMobile.API_VERSION;
        args.clientKey = _params.clientKey;
        args.client = SLTSaltrMobile.CLIENT;
        args.deviceId = _params.deviceId;

        //optional for Mobile
        if (_params.socialId != null) {
            args.socialId = _params.socialId;
        }

        if (_params.basicProperties != null) {
            args.basicProperties = _params.basicProperties;
        }

        if (_params.customProperties != null) {
            args.customProperties = _params.customProperties;
        }

        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }
}
}