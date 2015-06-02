/**
 * Created by TIGR on 3/30/2015.
 */
package saltr.api {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTHeartbeatApiCall extends SLTApiCall {
    public function SLTHeartbeatApiCall(isMobile:Boolean = true) {
        super(isMobile);
    }

    override saltr_internal function buildCall():URLVariables {
        _url = SLTConfig.SALTR_API_URL;
        var urlVars:URLVariables = new URLVariables();
        var args:Object = buildDefaultArgs();
        urlVars.action = SLTConfig.ACTION_HEARTBEAT;
        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }
}
}
