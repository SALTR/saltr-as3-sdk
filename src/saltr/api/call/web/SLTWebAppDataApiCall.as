/**
 * Created by daal on 4/7/16.
 */
package saltr.api.call.web {
import flash.utils.Dictionary;

import saltr.SLTAppData;
import saltr.SLTFeature;
import saltr.SLTFeatureValidator;
import saltr.api.call.SLTAppDataApiCall;
import saltr.saltr_internal;
import saltr.status.SLTStatus;
import saltr.status.SLTStatusAppDataLoadFail;
import saltr.status.SLTStatusAppDataParseError;
import saltr.utils.SLTLogger;

use namespace saltr_internal;

public class SLTWebAppDataApiCall extends SLTAppDataApiCall {

    private var _originalSuccessCallback:Function;
    private var _originalFailCallback:Function;
    private var _validator:SLTFeatureValidator;

    public function SLTWebAppDataApiCall(appData:SLTAppData) {
        super(appData, false);

        _validator = new SLTFeatureValidator();
    }

    override saltr_internal function call(params:Object, successCallback:Function = null, failCallback:Function = null, timeout:int = 0, dropTimeout:int = 0, progressiveTimeout:int = 0):void {
        _originalFailCallback = failCallback;
        _originalSuccessCallback = successCallback;

        super.call(params, wrappedSuccessCallback, wrappedFailCallback, timeout, dropTimeout, progressiveTimeout);
    }

    private function wrappedSuccessCallback(data:Object):void {
        SLTLogger.getInstance().log("New app data request from connect() succeed.");
        if (processNewAppData(data)) {
            _originalSuccessCallback(_appData);
        } else {
            _originalFailCallback(new SLTStatusAppDataParseError());
        }
    }

    private function wrappedFailCallback(status:SLTStatus):void {
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
