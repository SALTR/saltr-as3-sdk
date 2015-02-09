package saltr.api {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.SLTSaltrMobile;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class AppDataApiCall extends ApiCall {

    public function AppDataApiCall(params:Object, isMobile:Boolean = true) {
        super(params, isMobile);
        _url = SLTConfig.SALTR_API_URL;
    }

    override saltr_internal function buildCall():URLVariables {
        var urlVars:URLVariables = new URLVariables();
        urlVars.action = SLTConfig.ACTION_GET_APP_DATA;

        var args:Object = super.getMinimalArgs();

        args.apiVersion = ApiCall.API_VERSION;
        args.clientKey = _params.clientKey;
        args.client = _client;
        args.devMode = _params.devMode;

        args.basicProperties = _params.basicProperties;
        args.customProperties = _params.customProperties;

        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }
}
}