package saltr.api {


import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.SLTSaltrMobile;
import saltr.saltr_internal;

use namespace saltr_internal;

public class RegisterDeviceApiCall extends ApiCall {

    public function RegisterDeviceApiCall(params:Object, isMobile:Boolean = true) {
        super(params, isMobile);
        _url = SLTConfig.SALTR_DEVAPI_URL;
    }

    override protected function validateParams():Object {
        if (_isMobile) {
            validateMobileParams();
        }
        else {
            //TODO::@daal web case implement...
        }
    }

    private function validateMobileParams():Boolean {
        if (_params.deviceId == null) {
            return {isValid: false, message: "Field deviceId is required"};
        }
        if (_params.email == null || _params.email == "") {
            return {isValid: false, message: "Field email is required"};
        }
        return {isValid: true};
    }

    override protected function buildCall():URLVariables {
        var urlVars:URLVariables = new URLVariables();
        var args:Object = {};
        urlVars.action = SLTConfig.ACTION_DEV_REGISTER_DEVICE;
        urlVars.clientKey = _params.clientKey;
        args.devMode = _params.devMode;
        args.apiVersion = SLTSaltrMobile.API_VERSION;
        args.id = _params.deviceId;

        args.source = _params.deviceInfo.device;
        args.os = _params.deviceInfo.os;
        args.email = _params.email;

        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }
}
}