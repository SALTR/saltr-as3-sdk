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
        getMockedCallResult();
    }

    public function getMockSuccess():Boolean {
        return false;
    }

    public function getMockSuccessData():Object {
        return new Object();
    }

    public function getMockFailStatus():SLTStatus {
        return new SLTStatus(-1, "");
    }

    private function getMockedCallResult():void {
        if (getMockSuccess()) {
            _successCallback(getMockSuccessData());
        } else {
            _failCallback(getMockFailStatus());
        }
    }
}
}
