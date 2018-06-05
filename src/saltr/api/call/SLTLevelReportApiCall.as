/**
 * Created by 'ARKA' on 11/23/2016.
 */
package saltr.api.call {
import flash.net.URLVariables;

import saltr.SLTConfig;
import saltr.saltr_internal;
use namespace saltr_internal;

public class SLTLevelReportApiCall  extends SLTApiCall {

    public function SLTLevelReportApiCall(isMobile:Boolean = true):void {
        super(isMobile);
    }

    override saltr_internal function buildCall():URLVariables {
        _url = SLTConfig.SALTR_API_URL;
        var urlVars:URLVariables = new URLVariables();
        urlVars.action = SLTConfig.ACTION_LEVEL_REPORT;

        var args:Object = buildDefaultArgs();
        args.levelReportEventProperties = _params.levelReportEventProperties;

        urlVars.args = JSON.stringify(args, removeEmptyAndNullsJSONReplacer);
        return urlVars;
    }
}
}
