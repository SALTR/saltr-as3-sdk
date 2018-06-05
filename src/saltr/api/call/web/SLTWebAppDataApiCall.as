/**
 * Created by daal on 4/7/16.
 */
package saltr.api.call.web {
import saltr.SLTAppData;
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

    public function SLTWebAppDataApiCall(appData:SLTAppData) {
        super(appData, false);
    }

    override saltr_internal function call(params:Object, successCallback:Function = null, failCallback:Function = null, nativeTimeout:int = 0, dropTimeout:int = 0, timeoutIncrease:int = 0):void {
        _originalFailCallback = failCallback;
        _originalSuccessCallback = successCallback;

        super.call(params, wrappedSuccessCallback, wrappedFailCallback, nativeTimeout, dropTimeout, timeoutIncrease);
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
        } catch (e:Error) {
            SLTLogger.getInstance().log("New app data process failed.");
            return false;
        }

        SLTLogger.getInstance().log("New app data processed.");
        return true;
    }

}
}
