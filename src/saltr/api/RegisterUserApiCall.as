package saltr.api {

import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.saltr_internal;

use namespace saltr_internal;
/**
 * @private
 */
public class RegisterUserApiCall extends ApiCall {
    public function RegisterUserApiCall(params:Object, isMobile:Boolean = true) {
        super(params, isMobile);
        _url = SLTConfig.SALTR_DEVAPI_URL;
    }

    override saltr_internal function validateMobileParams():Object {
        return validateEmailParams();
    }

    override saltr_internal function validateWebParams():Object {
        var defaultParamsValidation:Object = validateDefaultWebParams();
        if(false == defaultParamsValidation.isValid) {
            return defaultParamsValidation;
        }
        var emailParamsValidation:Object = validateEmailParams();
        if (false == emailParamsValidation.isValid) {
            return emailParamsValidation;
        }
        return {isValid: true};
    }

    override saltr_internal function buildCall():URLVariables {
        var urlVars:URLVariables = new URLVariables();
        var args:Object = {};
        urlVars.action = SLTConfig.ACTION_DEV_REGISTER_USER;
        urlVars.clientKey = _params.clientKey;
        args.devMode = _params.devMode;
        args.apiVersion = ApiCall.API_VERSION;
        args.id = _params.socialId;

        //TODO: @TIGR ask about below params to Gev.
        args.source = "PC";//_params.deviceInfo.device;
        args.os = "OS";//_params.deviceInfo.os;
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
