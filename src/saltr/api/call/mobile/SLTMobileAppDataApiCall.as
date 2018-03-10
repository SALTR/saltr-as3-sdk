/**
 * Created by daal on 4/7/16.
 */
package saltr.api.call.mobile {
import flash.events.Event;
import flash.utils.Dictionary;

import saltr.SLTAppData;
import saltr.SLTContext;
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

    private var _originalSuccessCallback:Function;
    private var _originalFailCallback:Function;
    private var _validator:SLTFeatureValidator;
    private var _repositoryStorageManager:SLTRepositoryStorageManager;
    private var _levelUpdater:SLTMobileLevelsFeaturesUpdater;

    private var _contextForcedData:Object;

    public function SLTMobileAppDataApiCall(appData:SLTAppData) {
        super(appData);

        _validator = new SLTFeatureValidator();
        _repositoryStorageManager = SLTRepositoryStorageManager.getInstance();
        _levelUpdater = new SLTMobileLevelsFeaturesUpdater(0);
    }

    override saltr_internal function call(params:Object, successCallback:Function = null, failCallback:Function = null, nativeTimeout:int = 0, dropTimeout:int = 0, timeoutIncrease:int = 0):void {
        _originalFailCallback = failCallback;
        _originalSuccessCallback = successCallback;

        _levelUpdater.nativeTimeout = nativeTimeout;
        _levelUpdater.dropTimeout = dropTimeout;
        _levelUpdater.timeoutIncrease = timeoutIncrease;

        if (params.context == SLTContext.NORMAL) {
            super.call(params, wrappedSuccessCallbackContextNormal, wrappedFailCallbackContextNormal, nativeTimeout, dropTimeout, timeoutIncrease);
        }
        else if (params.context == SLTContext.FORCED) {
            _contextForcedData = {
                levelCollectionToken: params.levelCollectionToken,
                sltLevel: params.sltLevel,
                callback: params.callback
            };

            super.call(params, wrappedSuccessCallbackContextForced, wrappedFailCallbackContextForced, nativeTimeout, dropTimeout, timeoutIncrease);
        } else {
            throw new Error("Wrong SALTR context is used.");
        }
    }


    //////////// CONTEXT FORCED ////////

    private function wrappedFailCallbackContextForced(status:SLTStatus):void {
        _originalSuccessCallback(_contextForcedData);
    }

    private function wrappedSuccessCallbackContextForced(data:Object):void {
        if (processNewAppData(data)) {
            var newLevel:SLTLevel = _appData.getLevelCollectionBody(_contextForcedData.levelCollectionToken).getLevelByGlobalIndex(_contextForcedData.sltLevel.globalIndex);
            _levelUpdater.addEventListener(Event.COMPLETE, dedicatedLevelUpdateCompleteHandler);

            //we need to force load level content here
            _levelUpdater.updateLevel(_contextForcedData.levelCollectionToken, newLevel);
        } else {
            _originalSuccessCallback(_contextForcedData);
        }
    }

    private function dedicatedLevelUpdateCompleteHandler(event:Event):void {
        _levelUpdater.removeEventListener(Event.COMPLETE, dedicatedLevelUpdateCompleteHandler);
        _originalSuccessCallback(_contextForcedData);
    }


    //////////// CONTEXT NORMAL ////////

    private function wrappedSuccessCallbackContextNormal(data:Object):void {
        SLTLogger.getInstance().log("New app data request from connect() succeed.");
        if (processNewAppData(data)) {
            _originalSuccessCallback(_appData);
        } else {
            _originalFailCallback(new SLTStatusAppDataParseError());
        }
    }

    private function wrappedFailCallbackContextNormal(status:SLTStatus):void {
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
