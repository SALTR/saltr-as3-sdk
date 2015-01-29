package saltr.api {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.SLTFeature;
import saltr.SLTSaltrMobile;
import saltr.SLTSaltrMobile;

public class SyncApiCall extends ApiCall{

    public function SyncApiCall(params:Object, isMobile:Boolean = true) {
        super(params, isMobile);
        _url = SLTConfig.SALTR_DEVAPI_URL;
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
        var args:Object = {};
        urlVars.action = SLTConfig.ACTION_DEV_SYNC_DATA;

        args.apiVersion = SLTSaltrMobile.API_VERSION;
        args.clientKey = _params.clientKey;
        args.client = SLTSaltrMobile.CLIENT;
        args.deviceId = _params.deviceId;
        args.devMode = _params.devMode;

        urlVars.devMode = _params.devMode;
        urlVars.deviceId = _params.deviceId;

        //optional for Mobile
        if (_params.socialId != null) {
            args.socialId = _params.socialId;
        }

        var featureList:Array = [];
        for (var i:String in _params.developerFeatures) {
            var feature:SLTFeature = _params.developerFeatures[i];
            featureList.push({token: feature.token, value: JSON.stringify(feature.properties)});
        }
        args.developerFeatures = featureList;
        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }
}
}