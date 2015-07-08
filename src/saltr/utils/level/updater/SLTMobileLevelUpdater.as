/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import flash.events.EventDispatcher;

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
public class SLTMobileLevelUpdater extends EventDispatcher {
    saltr_internal static const LEVEL_UPDATE_TIMER_DELAY:Number = 3000;
    saltr_internal static const DEFAULT_SIMULTANEOUS_UPDATING_LEVELS_COUNT:uint = 3;

    protected var _isInProcess:Boolean;
    protected var _repositoryStorageManager:SLTRepositoryStorageManager;
    protected var _apiFactory:SLTApiCallFactory;
    protected var _requestIdleTimeout:int;

    private var _levelContentHandler:SLTLevelContentApiCallHandler;

    public function SLTMobileLevelUpdater(repositoryStorageManager:SLTRepositoryStorageManager, apiFactory:SLTApiCallFactory, requestIdleTimeout:int) {
        _repositoryStorageManager = repositoryStorageManager;
        _apiFactory = apiFactory;
        _requestIdleTimeout = requestIdleTimeout;
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

    protected function resetUpdateProcess():void {
        _isInProcess = false;
    }

    protected function processLevelContentLoaded(result:SLTApiCallLevelContentResult):void {
        var content:Object = result.data;
        if (result.success) {
            cacheLevelContent(result.featureToken, result.level, content);
        }
    }

    private function cacheLevelContent(featureToken:String, level:SLTLevel, content:Object):void {
        _repositoryStorageManager.cacheLevelContent(featureToken, level.globalIndex, level.version, content);
    }

    private function initApiCallHandlers():void {
        _levelContentHandler = new SLTLevelContentApiCallHandler(processLevelContentLoaded);
    }
}
}