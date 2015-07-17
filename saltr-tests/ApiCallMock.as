/**
 * Created by daal on 4/15/15.
 */
package {
import saltr.api.call.SLTApiCall;
import saltr.saltr_internal;
import saltr.status.SLTStatus;

use namespace saltr_internal;

public class ApiCallMock extends SLTApiCall {

    public function ApiCallMock(isMobile:Boolean = true) {
        super(isMobile);
    }

    override saltr_internal function call(params:Object, successCallback:Function = null, failCallback:Function = null, timeout:int = 0):void {
        _successCallback = successCallback;
        _failCallback = failCallback;
        _params = params;
        getMockedCallResult();
    }

    public function getMockSuccess():Boolean {
        return false;
    }

    public function getMockSuccessData(field:*):Object {
        return new Object();
    }

    public function getMockFailStatus():SLTStatus {
        return new SLTStatus(-1, "");
    }

    public function getParamsFieldName():String {
        return "";
    }

    private function getMockedCallResult():void {
        if (getMockSuccess()) {
            _successCallback(getMockSuccessData(_params[getParamsFieldName()]));
        } else {
            _failCallback(getMockFailStatus());
        }
    }
}
}
