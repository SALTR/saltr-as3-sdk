/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import saltr.api.call.SLTApiCall;
import saltr.api.call.SLTApiCallFactory;
import saltr.api.call.SLTApiCallLevelContentResult;
import saltr.api.handler.SLTLevelContentApiCallHandler;
import saltr.game.SLTLevel;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTMobileLevelContentLoader {
    private var _repositoryStorageManager:SLTRepositoryStorageManager;
    private var _apiFactory:SLTApiCallFactory;
    private var _requestIdleTimeout:int;
    private var _levelContentHandler:SLTLevelContentApiCallHandler;
    private var _callback:Function;

    public function SLTMobileLevelContentLoader(repositoryStorageManager:SLTRepositoryStorageManager, apiFactory:SLTApiCallFactory, requestIdleTimeout:int) {
        _repositoryStorageManager = repositoryStorageManager;
        _apiFactory = apiFactory;
        _requestIdleTimeout = requestIdleTimeout;
        _callback = null;
        initApiCallHandlers();
    }

    public function set apiFactory(value:SLTApiCallFactory):void {
        _apiFactory = value;
    }

    public function set repositoryStorageManager(value:SLTRepositoryStorageManager):void {
        _repositoryStorageManager = value;
    }

    public function set requestIdleTimeout(value:int):void {
        _requestIdleTimeout = value;
    }

    public function set callback(value:Function):void {
        _callback = value;
    }

    /**
     * Loads the level content.
     * @param sltLevel The level.
     */
    public function loadLevelContentFromSaltr(featureToken:String, sltLevel:SLTLevel):void {
        var params:Object = {
            featureToken: featureToken,
            sltLevel: sltLevel
        };
        var levelContentApiCall:SLTApiCall = _apiFactory.getCall(SLTApiCallFactory.API_CALL_LEVEL_CONTENT, true);
        levelContentApiCall.call(params, _levelContentHandler, _requestIdleTimeout);
    }

    public function getCachedLevelVersion(featureToken:String, level:SLTLevel):String {
        return _repositoryStorageManager.getLevelVersionFromCache(featureToken, level.globalIndex);
    }

    public function cacheLevelContent(featureToken:String, level:SLTLevel, content:Object):void {
        _repositoryStorageManager.cacheLevelContent(featureToken, level.globalIndex, level.version, content);
    }

    protected function processLevelContentLoaded(result:SLTApiCallLevelContentResult):void {
        if (_callback) {
            _callback(result);
        }
    }

    private function initApiCallHandlers():void {
        _levelContentHandler = new SLTLevelContentApiCallHandler(processLevelContentLoaded);
    }
}
}