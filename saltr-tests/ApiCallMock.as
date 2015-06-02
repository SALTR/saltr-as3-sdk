/**
 * Created by daal on 4/15/15.
 */
package {
import saltr.api.SLTApiCall;
import saltr.api.SLTApiCallResult;
import saltr.saltr_internal;

use namespace saltr_internal;

public class ApiCallMock extends SLTApiCall {

    public function ApiCallMock(isMobile:Boolean = true) {
        super(isMobile);
    }

    override saltr_internal function call(params:Object, callback:Function, timeout:int = 0):void {
        callback(getMockedCallResult());
    }

    public function getMockedCallResult():SLTApiCallResult {
        return new SLTApiCallResult();
    }
}
}
