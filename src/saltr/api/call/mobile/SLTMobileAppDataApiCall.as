/**
 * Created by daal on 4/7/16.
 */
package saltr.api.call.mobile {
import flash.events.Event;
import flash.utils.Dictionary;

import saltr.SLTAppData;

import saltr.SLTFeature;
import saltr.SLTFeatureValidator;
import saltr.api.call.SLTAppDataApiCall;
import saltr.game.SLTLevel;
import saltr.repository.SLTMobileRepository;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.saltr_internal;
import saltr.status.SLTStatus;
import saltr.status.SLTStatusAppDataLoadFail;
import saltr.status.SLTStatusAppDataParseError;
import saltr.utils.SLTLogger;
import saltr.utils.level.updater.SLTMobileLevelsFeaturesUpdater;

use namespace saltr_internal;

public class SLTMobileAppDataApiCall extends SLTAppDataApiCall {

    public static const CTX_MAIN:String = "main";
    public static const CTX_SEC:String = "secondary";

    private var _originalSuccessCallback:Function;
    private var _originalFailCallback:Function;
    private var _validator:SLTFeatureValidator;
    private var _repositoryStorageManager:SLTRepositoryStorageManager;
    private var _levelUpdater:SLTMobileLevelsFeaturesUpdater;

    private var _dataToSendBackIfSecondaryContext:Object;

    public function SLTMobileAppDataApiCall(appData:SLTAppData) {
        super(appData);

        _validator = new SLTFeatureValidator();
        _repositoryStorageManager = new SLTRepositoryStorageManager(new SLTMobileRepository());

        _levelUpdater = new SLTMobileLevelsFeaturesUpdater(_repositoryStorageManager, 0);
    }

    override saltr_internal function call(params:Object, successCallback:Function = null, failCallback:Function = null, timeout:int = 0, dropTimeout:int = 0, progressiveTimeout:int = 0):void {
        _originalFailCallback = failCallback;
        _originalSuccessCallback = successCallback;


        _levelUpdater.requestIdleTimeout = timeout;
        _levelUpdater.dropTimeout = dropTimeout;
        _levelUpdater.progressiveTimeout = progressiveTimeout;

        if (params.context == CTX_MAIN) {
            super.call(params, wrappedSuccessCallbackMainContext, wrappedFailCallbackMainContext, timeout, dropTimeout, progressiveTimeout);
        }
        else {
            _dataToSendBackIfSecondaryContext = {
                gameLevelsFeatureToken: params.gameLevelsFeatureToken,
                sltLevel: params.sltLevel,
                callback: params.callback
            };

            super.call(params, wrappedSuccessCallbackSecondaryContext, wrappedFailCallbackSecondaryContext, timeout, dropTimeout, progressiveTimeout);
        }
    }


////////////SECONDARY CONTEXT////////

    private function wrappedFailCallbackSecondaryContext(status:SLTStatus):void {
        _originalSuccessCallback(_dataToSendBackIfSecondaryContext);
    }

    private function wrappedSuccessCallbackSecondaryContext(data:Object):void {
        if (processNewAppData(data)) {
            var newLevel:SLTLevel = _appData.getGameLevelsProperties(_params.gameLevelsFeatureToken).getLevelByGlobalIndex(_params.sltLevel.globalIndex);
            _levelUpdater.addEventListener(Event.COMPLETE, dedicatedLevelUpdateCompleteHandler);
            _levelUpdater.updateLevel(_params.gameLevelsFeatureToken, newLevel);
        } else {
            _originalSuccessCallback(_dataToSendBackIfSecondaryContext);
        }
    }

    private function dedicatedLevelUpdateCompleteHandler(event:Event):void {
        _levelUpdater.removeEventListener(Event.COMPLETE, dedicatedLevelUpdateCompleteHandler);
        _originalSuccessCallback(_dataToSendBackIfSecondaryContext);
    }


////////////MAIN CONTEXT////////

    private function wrappedSuccessCallbackMainContext(data:Object):void {
        SLTLogger.getInstance().log("New app data request from connect() succeed.");
        if (processNewAppData(data)) {
            _levelUpdater.update(_appData.gameLevelsFeatures);
            _originalSuccessCallback(_appData);
        } else {
            _originalFailCallback(new SLTStatusAppDataParseError());
        }
    }

    private function wrappedFailCallbackMainContext(status:SLTStatus):void {
        SLTLogger.getInstance().log("New app data request from connect() failed. StatusCode: " + status.statusCode);

        if (status.statusCode == SLTStatus.API_ERROR) {
            _originalFailCallback(new SLTStatusAppDataLoadFail());
        } else {
            _originalFailCallback(status);
        }
    }

    private function processNewAppData(data:Object):Boolean {
        try {
            _appData.initWithData(data);
            validateFeatures();
        } catch (e:Error) {
            SLTLogger.getInstance().log("New app data process failed.");
            return false;
        }

        _repositoryStorageManager.cacheAppData(data);

        SLTLogger.getInstance().log("New app data processed.");
        return true;
    }

    private function validateFeatures():void {
        var activeFeatures:Dictionary = _appData.activeFeatures;
        for each (var feature:SLTFeature  in activeFeatures) {
            if (!_validator.validate(feature)) {
                feature.isValid = false;
            }
        }
    }

}
}
