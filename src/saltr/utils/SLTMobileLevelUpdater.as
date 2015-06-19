/**
 * Created by TIGR on 6/4/2015.
 */
package saltr.utils {
import flash.events.TimerEvent;
import flash.utils.Dictionary;
import flash.utils.Timer;

import saltr.SLTConfig;
import saltr.api.SLTApiCall;
import saltr.api.SLTApiCallResult;
import saltr.api.SLTApiFactory;
import saltr.game.SLTLevel;
import saltr.repository.ISLTRepository;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTMobileLevelUpdater {
    saltr_internal static const LEVEL_UPDATE_TIMER_DELAY:Number = 30000;
    saltr_internal static const DEFAULT_SIMULTANEOUS_UPDATING_LEVELS_COUNT:uint = 3;

    private var _repository:ISLTRepository;
    private var _apiFactory:SLTApiFactory;
    private var _requestIdleTimeout:int;
    private var _isInProcess:Boolean;
    private var _outdatedLevels:Vector.<SLTLevel>;
    private var _updatedLevelCount:uint;
    private var _levelIndexToUpdate:int;
    private var _levelUpdateTimer:Timer;
    private var _allLevels:Vector.<SLTLevel>;

    public function SLTMobileLevelUpdater(repository:ISLTRepository, apiFactory:SLTApiFactory, requestIdleTimeout:int) {
        _repository = repository;
        _apiFactory = apiFactory;
        _requestIdleTimeout = requestIdleTimeout;
        _outdatedLevels = new Vector.<SLTLevel>();
        resetUpdateProcess();
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

    public function updateOutdatedLevelContents(gameLevelsFeatures:Dictionary):void {
        if (_isInProcess) {
            return;
        }
        _allLevels = allLevels;
        _outdatedLevels = getOutdatedLevels();
        if (_outdatedLevels.length > 0) {
            _levelIndexToUpdate = 0;
            _isInProcess = true;
            startLevelUpdateTimer();
        }
    }

    public function loadLevelContentInternally(sltLevel:SLTLevel):Object {
        var content:Object = loadLevelContentFromCache(sltLevel);
        if (content == null) {
            content = loadLevelContentFromDisk(sltLevel);
        }
        return content;
    }

    private function startLevelUpdateTimer():void {
        stopLevelUpdateTimer();
        _levelUpdateTimer = new Timer(LEVEL_UPDATE_TIMER_DELAY);
        _levelUpdateTimer.addEventListener(TimerEvent.TIMER, levelUpdateTimerHandler);
        _levelUpdateTimer.start();
    }

    private function stopLevelUpdateTimer():void {
        if (null != _levelUpdateTimer) {
            _levelUpdateTimer.stop();
            _levelUpdateTimer.removeEventListener(TimerEvent.TIMER, levelUpdateTimerHandler);
            _levelUpdateTimer = null;
        }
    }

    private function levelUpdateTimerHandler(event:TimerEvent):void {
        startNextLevelsUpdate();
        if (_levelIndexToUpdate == _outdatedLevels.length) {
            stopLevelUpdateTimer();
        }
    }

    private function startNextLevelsUpdate():void {
        for (var i:uint = 0; i < DEFAULT_SIMULTANEOUS_UPDATING_LEVELS_COUNT; ++i) {
            var levelIndexToUpdate:int = _levelIndexToUpdate + 1;
            if (levelIndexToUpdate < _outdatedLevels.length) {
                _levelIndexToUpdate = levelIndexToUpdate;
                loadLevelContentFromSaltr(_outdatedLevels[_levelIndexToUpdate]);
            } else {
                return;
            }
        }
    }

    private function resetUpdateProcess():void {
        _outdatedLevels.length = 0;
        _updatedLevelCount = 0;
        _levelIndexToUpdate = -1;
        _isInProcess = false;
    }

    private function loadLevelContentFromCache(sltLevel:SLTLevel):Object {
        var url:String = SLTUtils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_CACHE_URL_TEMPLATE, sltLevel.packIndex, sltLevel.localIndex);
        return _repository.getObjectFromCache(url);
    }

    private function loadLevelContentFromDisk(sltLevel:SLTLevel):Object {
        var url:String = SLTUtils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_PACKAGE_URL_TEMPLATE, sltLevel.packIndex, sltLevel.localIndex);
        return _repository.getObjectFromApplication(url);
    }

    private function getOutdatedLevels():Vector.<SLTLevel> {
        var levelsToUpdate:Vector.<SLTLevel> = new Vector.<SLTLevel>();
        for (var i:int = 0; i < _allLevels.length; ++i) {
            var currentLevel:SLTLevel = _allLevels[i];
            if (currentLevel.version != getCachedLevelVersion(currentLevel)) {
                levelsToUpdate.push(currentLevel);
            }
        }
        return levelsToUpdate;
    }

    private function getCachedLevelVersion(sltLevel:SLTLevel):String {
        var cachedFileName:String = SLTUtils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_CACHE_URL_TEMPLATE, sltLevel.packIndex, sltLevel.localIndex);
        return _repository.getObjectVersionFromCache(cachedFileName);
    }

    /**
     * Loads the level content.
     * @param sltLevel The level.
     */
    private function loadLevelContentFromSaltr(sltLevel:SLTLevel):void {
        var params:Object = {
            levelContentUrl: sltLevel.contentUrl + "?_time_=" + new Date().getTime()
        };
        var levelContentApiCall:SLTApiCall = _apiFactory.getCall(SLTApiFactory.API_CALL_LEVEL_CONTENT, true);
        levelContentApiCall.call(params, levelContentApiCallback, _requestIdleTimeout);

        function levelContentApiCallback(result:SLTApiCallResult):void {
            var content:Object = result.data;
            if (result.success) {
                cacheLevelContent(sltLevel, content);
            }
            ++_updatedLevelCount;
            if (_updatedLevelCount >= _outdatedLevels.length) {
                resetUpdateProcess();
            }
        }
    }

    private function cacheLevelContent(sltLevel:SLTLevel, content:Object):void {
        var cachedFileName:String = SLTUtils.formatString(SLTConfig.LOCAL_LEVEL_CONTENT_CACHE_URL_TEMPLATE, sltLevel.packIndex, sltLevel.localIndex);
        _repository.cacheObject(cachedFileName, String(sltLevel.version), content);
    }
}
}
