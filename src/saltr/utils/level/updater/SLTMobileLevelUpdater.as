/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import flash.events.EventDispatcher;

import saltr.api.SLTApiFactory;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTMobileLevelUpdater extends EventDispatcher {
    saltr_internal static const LEVEL_UPDATE_TIMER_DELAY:Number = 30000;
    saltr_internal static const DEFAULT_SIMULTANEOUS_UPDATING_LEVELS_COUNT:uint = 3;

    protected var _isInProcess:Boolean;
    protected var _repositoryStorageManager:SLTRepositoryStorageManager;
    protected var _apiFactory:SLTApiFactory;
    protected var _requestIdleTimeout:int;

    public function SLTMobileLevelUpdater(repositoryStorageManager:SLTRepositoryStorageManager, apiFactory:SLTApiFactory, requestIdleTimeout:int) {
        _repositoryStorageManager = repositoryStorageManager;
        _apiFactory = apiFactory;
        _requestIdleTimeout = requestIdleTimeout;
    }

    public function set apiFactory(value:SLTApiFactory):void {
        _apiFactory = value;
    }

    public function set repositoryStorageManager(value:SLTRepositoryStorageManager):void {
        _repositoryStorageManager = value;
    }

    public function set requestIdleTimeout(value:int):void {
        _requestIdleTimeout = value;
    }

    protected function resetUpdateProcess():void {
        _isInProcess = false;
    }
}
}