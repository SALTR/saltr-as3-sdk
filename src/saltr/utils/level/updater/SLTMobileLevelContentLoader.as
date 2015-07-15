/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import saltr.api.call.SLTApiCall;
import saltr.api.call.SLTApiCallFactory;
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
    private var _apiFactory:SLTApiCallFactory;
    private var _requestIdleTimeout:int;

    public function SLTMobileLevelContentLoader(repositoryStorageManager:SLTRepositoryStorageManager, apiFactory:SLTApiCallFactory, requestIdleTimeout:int) {
        _repositoryStorageManager = repositoryStorageManager;
        _apiFactory = apiFactory;
        _requestIdleTimeout = requestIdleTimeout;
    }

    saltr_internal function set apiFactory(value:SLTApiCallFactory):void {
        _apiFactory = value;
    }

    saltr_internal function set repositoryStorageManager(value:SLTRepositoryStorageManager):void {
        _repositoryStorageManager = value;
    }

    saltr_internal function set requestIdleTimeout(value:int):void {
        _requestIdleTimeout = value;
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
            contentUrl: sltLevel.contentUrl + "?_time_=" + new Date().getTime()
        };
        var levelContentApiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_LEVEL_CONTENT, true);
        levelContentApiCall.call(params, successHandler, failHandler, _requestIdleTimeout);
        SLTLogger.getInstance().log("Level content from Saltr requested. Feature token: " + featureToken + " Global index: " + sltLevel.globalIndex);
    }

    saltr_internal function getCachedLevelVersion(featureToken:String, level:SLTLevel):String {
        return _repositoryStorageManager.getLevelVersionFromCache(featureToken, level.globalIndex);
    }

    saltr_internal function cacheLevelContent(featureToken:String, level:SLTLevel, content:Object):void {
        _repositoryStorageManager.cacheLevelContent(featureToken, level.globalIndex, level.version, content);
        SLTLogger.getInstance().log("Level content cached. Feature token: " + featureToken + " Global index: " + level.globalIndex + " version: " + level.version);
    }
}
}