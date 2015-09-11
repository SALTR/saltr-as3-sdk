package saltr.api.call {

import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTRegisterUserApiCall extends SLTApiCall {
    public function SLTRegisterUserApiCall(isMobile:Boolean = true) {
        super(isMobile);
    }

    override saltr_internal function validateMobileParams():Object {
        return validateWebParams();
    }

    override saltr_internal function validateWebParams():Object {
        var defaultParamsValidation:Object = validateDefaultWebParams();
        if (false == defaultParamsValidation.isValid) {
            return defaultParamsValidation;
        }
        var emailParamsValidation:Object = validateEmailParams();
        if (false == emailParamsValidation.isValid) {
            return emailParamsValidation;
        }
        return {isValid: true};
    }

    override saltr_internal function buildCall():URLVariables {
        _url = SLTConfig.SALTR_DEVAPI_URL;
        var urlVars:URLVariables = new URLVariables();
        var args:Object = {};
        urlVars.action = SLTConfig.ACTION_DEV_REGISTER_USER;
        urlVars.clientKey = _params.clientKey;
        urlVars.client = _client;
        args.devMode = _params.devMode;
        args.apiVersion = SLTApiCall.API_VERSION;
        args.id = _params.socialId;

        args.source = _params.platform;
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
