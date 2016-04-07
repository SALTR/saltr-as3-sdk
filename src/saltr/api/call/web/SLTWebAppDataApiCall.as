/**
 * Created by daal on 4/7/16.
 */
package saltr.api.call.web {
import flash.events.Event;
import flash.utils.Dictionary;

import saltr.SLTAppData;
import saltr.SLTFeature;
import saltr.SLTFeatureValidator;
import saltr.api.call.SLTApiCallFactory;
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

public class SLTWebAppDataApiCall extends SLTAppDataApiCall {

    private var _originalSuccessCallback:Function;
    private var _originalFailCallback:Function;
    private var _validator:SLTFeatureValidator;
    private var _apiFactory:SLTApiCallFactory;
    private var _appData:SLTAppData;

    public function SLTWebAppDataApiCall() {
        super(false);

        _validator = new SLTFeatureValidator();

        _appData = new SLTAppData();

        _apiFactory = new SLTApiCallFactory();
    }

    override saltr_internal function call(params:Object, successCallback:Function = null, failCallback:Function = null, timeout:int = 0):void {
        _originalFailCallback = failCallback;
        _originalSuccessCallback = successCallback;

        super.call(params, wrappedSuccessCallbackMainContext, wrappedFailCallbackMainContext, timeout);
    }

    private function wrappedSuccessCallbackMainContext(data:Object):void {
        SLTLogger.getInstance().log("New app data request from connect() succeed.");
        if (processNewAppData(data)) {
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
