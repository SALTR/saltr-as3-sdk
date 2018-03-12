/**
 * Created by daal on 4/7/16.
 */
package saltr {

import saltr.api.call.SLTApiCall;
import saltr.api.call.factory.SLTApiCallFactory;
import saltr.api.call.factory.SLTWebApiCallFactory;
import saltr.game.SLTLevel;
import saltr.status.SLTStatus;

use namespace saltr_internal;

public class SLTSaltrWeb extends SLTSaltr {

    private var _sltLevel:SLTLevel;
    private var _callback:Function;

    public function SLTSaltrWeb(clientKey:String, deviceId:String = null, socialId:String = null) {
        super(clientKey, deviceId, socialId);

        SLTApiCallFactory.factory = new SLTWebApiCallFactory();
    }

    override public function start():void {
        if (_socialId == null) {
            throw new Error("socialId field is required and can't be null.");
        }
        _appData.initFeatures(getAppDataFromSnapshot());
        _started = true;
    }

    override public function initLevelContent(levelCollectionToken:String, sltLevel:SLTLevel, callback:Function, fromSaltr:Boolean = false):void {
        super.initLevelContent(levelCollectionToken, sltLevel, callback, true);
    }

    override protected function initLevelContentFromSaltr(levelCollectionToken:String, sltLevel:SLTLevel, callback:Function):void {
        _sltLevel = sltLevel;
        _callback = callback;

        var params:Object = {
            contentUrl: sltLevel.contentUrl,
            alternateUrl: sltLevel.alternateContentUrl
        };

        var levelContentApiCall:SLTApiCall = SLTApiCallFactory.factory.getCall(SLTApiCallFactory.API_CALL_LEVEL_CONTENT);
        levelContentApiCall.call(params, levelContentLoadSuccessCallback, levelContentLoadFailCallback, _nativeTimeout, _dropTimeout, _timeoutIncrease);
    }

    private function levelContentLoadSuccessCallback(data:Object):void {
        _sltLevel.updateContent(data);
        _callback(true);
    }

    private function levelContentLoadFailCallback(status:SLTStatus):void {
        _callback(false);
    }
}
}
