/**
 * Created by daal on 4/7/16.
 */
package saltr {
import saltr.api.call.SLTApiCall;
import saltr.api.call.SLTApiCallFactory;
import saltr.game.SLTLevel;
import saltr.status.SLTStatus;
import saltr.utils.SLTLogger;

use namespace saltr_internal;

public class SLTSaltrWebClean extends SLTSaltr {

    public function SLTSaltrWebClean(clientKey:String, deviceId:String = null, socialId:String = null) {
        super(clientKey, deviceId, socialId);
    }

    override public function start():void {
        if (_socialId == null) {
            throw new Error("socialId field is required and can't be null.");
        }

        _appData.initEmpty();
        _started = true;
    }

    override public function initLevelContentFromSaltr(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function):void {
        var levelContentApiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_LEVEL_CONTENT, true);
        levelContentApiCall.call(params, successHandler, failHandler, _requestIdleTimeout);
    }
}
}
