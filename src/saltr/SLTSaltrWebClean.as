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


    //TODO::@daal, @arka.... fix this..
    override public function initLevelContentFromSaltr(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function):void {
        if (!_started) {
            throw new Error("Method 'initLevelContentFromSaltr' should be called after 'start()' only.");
        }

        var additionalCallParams:Object = {
            gameLevelsFeatureToken: gameLevelsFeatureToken,
            sltLevel: sltLevel,
            callback: callback
        };

        if (canGetAppData()) {
            additionalCallParams.context = "secondary";
            getAppData(appDataInitLevelSuccessHandler, null, false, null, null, additionalCallParams);
        } else {
            appDataInitLevelSuccessHandler(additionalCallParams);
        }
    }

    private function appDataInitLevelSuccessHandler(data:Object):void {
        _isWaitingForAppData = false;

        var gameLevelsFeatureToken:String = data.gameLevelsFeatureToken;
        var level:SLTLevel = data.sltLevel;
        var callback:Function = data.callback;
        var success:Boolean = initLevelContentLocally(gameLevelsFeatureToken, level);

        callback(success);
    }
}
}
