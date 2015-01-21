package saltr.api {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.SLTSaltrMobile;
import saltr.SLTSaltrMobile;

public class AddPropertiesApiCall extends ApiCall {
    public function AddPropertiesApiCall(params:Object):void {
        super(params);
        _url = SLTConfig.SALTR_API_URL;
    }

    override protected function buildCall():URLVariables {
        var urlVars:URLVariables = new URLVariables();
        var args:Object = {};
        urlVars.cmd = SLTConfig.ACTION_ADD_PROPERTIES; //TODO @GSAR: remove later
        urlVars.action = SLTConfig.ACTION_ADD_PROPERTIES;

        args.apiVersion = SLTSaltrMobile.API_VERSION;
        args.clientKey = _params.clientKey;
        args.client = SLTSaltrMobile.CLIENT;

        //required for Mobile
        if (_params.deviceId != null) {
            args.deviceId = _params.deviceId;
        } else {
            throw new Error("Field 'deviceId' is a required.")
        }

        //optional for Mobile
        if(_params.socialId != null) {
            args.socialId = _params.socialId;
        }

        //optional
        if (_params.basicProperties != null) {
            args.basicProperties = _params.basicProperties;
        }

        //optional
        if (_params.customProperties != null) {
            args.customProperties = _params.customProperties;
        }

        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }
}
}