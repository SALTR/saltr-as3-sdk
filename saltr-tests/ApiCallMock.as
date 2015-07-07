/**
 * Created by daal on 4/15/15.
 */
package {
import saltr.api.call.SLTApiCall;
import saltr.api.call.SLTApiCallResult;
import saltr.api.handler.ISLTApiCallHandler;
import saltr.saltr_internal;

use namespace saltr_internal;

public class ApiCallMock extends SLTApiCall {

    public function ApiCallMock(isMobile:Boolean = true) {
        super(isMobile);
    }

    override saltr_internal function call(params:Object, handler:ISLTApiCallHandler, timeout:int = 0):void {
        handler.handle(getMockedCallResult());
    }

    public function getMockedCallResult():SLTApiCallResult {
        return new SLTApiCallResult();
    }
}
}
