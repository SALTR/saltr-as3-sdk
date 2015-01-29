package saltr.api {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.SLTSaltrMobile;

public class AppDataApiCall extends ApiCall {

    public function AppDataApiCall(params:Object, isMobile:Boolean = true) {
        super(params, isMobile);
        _url = SLTConfig.SALTR_API_URL;
    }

    override protected function validateParams():Object {
        if (_isMobile) {
            return validateMobileParams();
        }
        else {
            //TODO::@daal web case implement...
        }
    }

    private function validateMobileParams():Boolean {
        if (_params.deviceId == null) {
            return {isValid: false, message: "Field deviceId is required"};
        }
        return {isValid: true};
    }

    override protected function buildCall():URLVariables {
        var urlVars:URLVariables = new URLVariables();
        urlVars.action = SLTConfig.ACTION_GET_APP_DATA;

        var args:Object = {};

        args.apiVersion = SLTSaltrMobile.API_VERSION;
        args.clientKey = _params.clientKey;
        args.client = SLTSaltrMobile.CLIENT;
        args.deviceId = _params.deviceId;
        args.devMode = _params.devMode;

        //TODO:: @daal. Check if removeEmptyAndNullsJSONReplacer strips nulls and empties properly with can remove this null checks...
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