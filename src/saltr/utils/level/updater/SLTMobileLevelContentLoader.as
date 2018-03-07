/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import saltr.api.call.SLTApiCall;
import saltr.api.call.factory.SLTApiCallFactory;
import saltr.game.SLTLevel;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.saltr_internal;
import saltr.status.SLTStatus;
import saltr.utils.SLTLogger;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTMobileLevelContentLoader {
    private var _repositoryStorageManager:SLTRepositoryStorageManager;
    private var _nativeTimeout:int;
    private var _dropTimeout:int;
    private var _timeoutIncrease:int;

    public function SLTMobileLevelContentLoader(repositoryStorageManager:SLTRepositoryStorageManager, nativeTimeout:int, dropTimeout:int, timeoutIncrease:int) {
        _repositoryStorageManager = repositoryStorageManager;
        _nativeTimeout = nativeTimeout;
        _dropTimeout = dropTimeout;
        _timeoutIncrease = timeoutIncrease;
    }

    saltr_internal function loadLevelContentFromSaltr(featureToken:String, sltLevel:SLTLevel, successCallback:Function, failCallback:Function):void {
        function successHandler(data:Object):void {
            SLTLogger.getInstance().log("Level content from Saltr request succeed. Feature token: " + featureToken + " Global index: " + sltLevel.globalIndex);
            successCallback(featureToken, sltLevel, data);
        }

        function failHandler(status:SLTStatus):void {
            SLTLogger.getInstance().log("Level content from Saltr failed. Feature token: " + featureToken + " Global index: " + sltLevel.globalIndex);
            failCallback(featureToken, sltLevel, status);
        }

        var params:Object = {
            contentUrl: sltLevel.contentUrl
        };
        var levelContentApiCall:SLTApiCall = SLTApiCallFactory.factory.getCall(SLTApiCallFactory.API_CALL_LEVEL_CONTENT);
        levelContentApiCall.call(params, successHandler, failHandler, _nativeTimeout, _dropTimeout, _timeoutIncrease);
        SLTLogger.getInstance().log("Level content from Saltr requested. Feature token: " + featureToken + " Global index: " + sltLevel.globalIndex);
    }

    saltr_internal function cacheLevelContent(featureToken:String, level:SLTLevel, content:String):void {
        _repositoryStorageManager.cacheLevelContent(featureToken, level.globalIndex, level.version, content);
        SLTLogger.getInstance().log("Level content cached. Feature token: " + featureToken + " Global index: " + level.globalIndex + " version: " + level.version);
    }

    saltr_internal function cachedLevelFileExists(featureToken:String, level:SLTLevel):Boolean {
        return _repositoryStorageManager.cachedLevelFileExists(featureToken, level.globalIndex, level.version);

    }
}
}