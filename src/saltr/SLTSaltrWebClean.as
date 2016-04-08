/**
 * Created by daal on 4/7/16.
 */
package saltr {
import saltr.api.call.SLTApiCall;
import saltr.api.call.factory.SLTApiCallFactory;
import saltr.api.call.factory.SLTWebApiCallFactory;
import saltr.game.SLTLevel;

use namespace saltr_internal;

public class SLTSaltrWebClean extends SLTSaltr {

    public function SLTSaltrWebClean(clientKey:String, deviceId:String = null, socialId:String = null) {
        super(clientKey, deviceId, socialId);

        SLTApiCallFactory.factory = new SLTWebApiCallFactory();
    }

    override public function start():void {
        if (_socialId == null) {
            throw new Error("socialId field is required and can't be null.");
        }

        _appData.initEmpty();
        _started = true;
    }

    override public function initLevelContentFromSaltr(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function):void {
        var levelContentApiCall:SLTApiCall = SLTApiCallFactory.factory.getCall(SLTApiCallFactory.API_CALL_LEVEL_CONTENT);
        levelContentApiCall.call(params, successHandler, failHandler, _requestIdleTimeout);
    }
}
}
