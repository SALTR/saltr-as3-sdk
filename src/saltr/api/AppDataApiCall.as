package saltr.api {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.SLTSaltrMobile;

public class AppDataApiCall extends ApiCall{
    public function AppDataApiCall(params:Object) {
        super(params);
        _url = SLTConfig.SALTR_API_URL;
    }

    override protected function buildCall():URLVariables {
        var urlVars:URLVariables = new URLVariables();
        urlVars.cmd = SLTConfig.ACTION_GET_APP_DATA; //TODO @GSAR: remove later
        urlVars.action = SLTConfig.ACTION_GET_APP_DATA;

        var args:Object = {};

        args.apiVersion = SLTSaltrMobile.API_VERSION;
        args.clientKey = _params.clientKey;
        args.client = SLTSaltrMobile.CLIENT;

        //required for Mobile
        if (_params.deviceId != null) {
            args.deviceId = _params.deviceId;
        } else {
            throw new Error("Field 'deviceId' is a required.")
        }

        args.devMode = _params.devMode;

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