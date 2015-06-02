package saltr.api {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.SLTFeature;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTSyncApiCall extends SLTApiCall {

    public function SLTSyncApiCall(isMobile:Boolean = true) {
        super(isMobile);
    }

    override saltr_internal function buildCall():URLVariables {
        _url = SLTConfig.SALTR_DEVAPI_URL;
        var urlVars:URLVariables = new URLVariables();
        var args:Object = buildDefaultArgs();
        urlVars.action = SLTConfig.ACTION_DEV_SYNC_DATA;

        var featureList:Array = [];
        for (var i:String in _params.developerFeatures) {
            var feature:SLTFeature = _params.developerFeatures[i];
            featureList.push({token: feature.token, properties: feature.properties});
        }
        args.developerFeatures = featureList;
        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }
}
}