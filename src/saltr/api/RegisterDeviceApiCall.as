package saltr.api {


import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.SLTSaltrMobile;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class RegisterDeviceApiCall extends ApiCall {

    public function RegisterDeviceApiCall(params:Object, isMobile:Boolean = true) {
        super(params, isMobile);
        _url = SLTConfig.SALTR_DEVAPI_URL;
    }

    override saltr_internal function validateMobileParams():Object {
        var defaultParamsValidation:Object = validateDefaultMobileParams();
        if(false == defaultParamsValidation.isValid) {
            return defaultParamsValidation;
        }
        var emailParamsValidation:Object = validateEmailParams();
        if (false == emailParamsValidation.isValid) {
            return emailParamsValidation;
        }
        return {isValid: true};
    }

    override saltr_internal function validateWebParams():Object {
        return validateMobileParams();
    }

    override saltr_internal function buildCall():URLVariables {
        var urlVars:URLVariables = new URLVariables();
        var args:Object = {};
        urlVars.action = SLTConfig.ACTION_DEV_REGISTER_DEVICE;
        urlVars.clientKey = _params.clientKey;
        urlVars.client = _client;
        args.devMode = _params.devMode;
        args.apiVersion = ApiCall.API_VERSION;
        args.id = _params.deviceId;

        args.source = _params.deviceInfo.device;
        args.os = _params.deviceInfo.os;
        args.email = _params.email;

        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }

    private function validateEmailParams():Object {
        if (_params.email == null || _params.email == "") {
            return {isValid: false, message: "Field email is required"};
        }
        return {isValid: true};
    }
}
}