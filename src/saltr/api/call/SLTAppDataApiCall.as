package saltr.api.call {
import flash.net.URLVariables;

import saltr.SLTAppData;

import saltr.SLTConfig;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTAppDataApiCall extends SLTApiCall {
    protected var _appData:SLTAppData;

    public function SLTAppDataApiCall(appData:SLTAppData, isMobile:Boolean = true) {
        _appData = appData;
        super(isMobile);
    }

    override saltr_internal function buildCall():URLVariables {
        _url = SLTConfig.SALTR_API_URL;
        var urlVars:URLVariables = new URLVariables();
        urlVars.action = SLTConfig.ACTION_GET_APP_DATA;

        var args:Object = buildDefaultArgs();
        args.ping = _params.ping;
        args.snapshotId = _params.snapshotId;
        args.basicProperties = _params.basicProperties;
        args.customProperties = _params.customProperties;

        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }
}
}