package saltr.api.call {
import saltr.api.*;

import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTAddPropertiesApiCall extends SLTApiCall {

    public function SLTAddPropertiesApiCall(isMobile:Boolean = true):void {
        super(isMobile);
    }

    override saltr_internal function buildCall():URLVariables {
        _url = SLTConfig.SALTR_API_URL;
        var urlVars:URLVariables = new URLVariables();
        var args:Object = buildDefaultArgs();
        urlVars.action = SLTConfig.ACTION_ADD_PROPERTIES;
        args.basicProperties = _params.basicProperties;
        args.customProperties = _params.customProperties;

        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }
}
}