/**
 * Created by TIGR on 3/30/2015.
 */
package saltr.api {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.saltr_internal;

use namespace saltr_internal;

public class HeartbeatApiCall extends ApiCall {
    public function HeartbeatApiCall(params:Object, isMobile:Boolean = true) {
        super(params, isMobile);
        _url = SLTConfig.SALTR_API_URL;
    }

    override saltr_internal function buildCall():URLVariables {
        var urlVars:URLVariables = new URLVariables();
        var args:Object = buildDefaultArgs();
        urlVars.action = SLTConfig.ACTION_HEARTBEAT;
        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }
}
}
