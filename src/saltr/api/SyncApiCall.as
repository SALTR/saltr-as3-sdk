package saltr.api {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.SLTFeature;
import saltr.SLTSaltrMobile;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SyncApiCall extends ApiCall {

    public function SyncApiCall(params:Object, isMobile:Boolean = true) {
        super(params, isMobile);
        _url = SLTConfig.SALTR_DEVAPI_URL;
    }

    override saltr_internal function buildCall():URLVariables {
        var urlVars:URLVariables = new URLVariables();
        var args:Object = super.getMinimalArgs();
        urlVars.action = SLTConfig.ACTION_DEV_SYNC_DATA;

        args.apiVersion = ApiCall.API_VERSION;
        args.clientKey = _params.clientKey;
        args.client = _client;
        args.devMode = _params.devMode;

        urlVars.devMode = _params.devMode;

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