/**
 * Created by daal on 4/15/15.
 */
package {
import saltr.api.ApiCall;
import saltr.api.ApiCallResult;
import saltr.saltr_internal;

use namespace saltr_internal;

public class ApiCallMock extends ApiCall{

    public function ApiCallMock(params : Array, isMobile:Boolean) {
        super(params, isMobile);
    }

    override saltr_internal function call(callback:Function, timeout:int = 0):void {
        callback(getMockedCallResult());
    }

    public function getMockedCallResult() : ApiCallResult {
        return new ApiCallResult();
    }
}
}
