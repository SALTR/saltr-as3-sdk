package saltr.api {


import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.SLTSaltrMobile;

import saltr.saltr_internal;
import saltr.utils.MobileDeviceInfo;

use namespace saltr_internal;

public class RegisterDeviceApiCall extends ApiCall{

    public function RegisterDeviceApiCall(params:Object) {
        super(params);
        _url = SLTConfig.SALTR_DEVAPI_URL;
    }

    override protected function buildCall():URLVariables {
        var urlVars:URLVariables = new URLVariables();
        var args:Object = {};
        urlVars.action = SLTConfig.ACTION_DEV_REGISTER_DEVICE;
        urlVars.clientKey = _params.clientKey;
        args.devMode = _params.devMode;
        args.apiVersion = SLTSaltrMobile.API_VERSION;

        //required for Mobile
        if (_params.deviceId != null) {
            args.id = _params.deviceId;
        } else {
            throw new Error("Field 'deviceId' is a required.");
        }

        args.source = _params.deviceInfo.device;
        args.os = _params.deviceInfo.os;

        if (_params.email != null && _params.email != "") {
            args.email = _params.email;
        } else {
            throw new Error("Field 'email' is a required.")
        }

        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }
}
}