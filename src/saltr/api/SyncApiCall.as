package saltr.api {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.SLTFeature;
import saltr.SLTSaltrMobile;
import saltr.SLTSaltrMobile;

public class SyncApiCall extends ApiCall{

    public function SyncApiCall(params:Object) {
        super(params);
        _url = SLTConfig.SALTR_DEVAPI_URL;
    }

    override protected function buildCall():URLVariables {
        var urlVars:URLVariables = new URLVariables();
        var args:Object = {};
        urlVars.action = SLTConfig.ACTION_DEV_SYNC_DATA;

        args.apiVersion = SLTSaltrMobile.API_VERSION;
        args.clientKey = _params.clientKey;
        args.client = SLTSaltrMobile.CLIENT;
        args.devMode = _params.devMode;
        urlVars.devMode = _params.devMode;

        //required for Mobile
        if (_params.deviceId != null) {
            args.deviceId = _params.deviceId;
            urlVars.deviceId = _params.deviceId;
        } else {
            throw new Error("Field 'deviceId' is a required.")
        }

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