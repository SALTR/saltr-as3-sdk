/**
 * Created by TIGR on 6/19/2015.
 */
package saltr.utils.level.updater {
import saltr.api.SLTApiFactory;
import saltr.repository.ISLTRepository;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTMobileLevelUpdater {
    saltr_internal static const LEVEL_UPDATE_TIMER_DELAY:Number = 30000;
    saltr_internal static const DEFAULT_SIMULTANEOUS_UPDATING_LEVELS_COUNT:uint = 3;

    protected var _isInProcess:Boolean;
    protected var _repository:ISLTRepository;
    protected var _apiFactory:SLTApiFactory;
    protected var _requestIdleTimeout:int;

    public function SLTMobileLevelUpdater(repository:ISLTRepository, apiFactory:SLTApiFactory, requestIdleTimeout:int) {
        _repository = repository;
        _apiFactory = apiFactory;
        _requestIdleTimeout = requestIdleTimeout;
    }

    public function set apiFactory(value:SLTApiFactory):void {
        _apiFactory = value;
    }

    public function set repository(value:ISLTRepository):void {
        _repository = value;
    }

    public function set requestIdleTimeout(value:int):void {
        _requestIdleTimeout = value;
    }

    protected function resetUpdateProcess():void {
        _isInProcess = false;
    }
}
}
