/**
 * Created by daal on 4/15/15.
 */
package {
import saltr.api.ApiCall;
import saltr.api.ApiCallResult;
import saltr.saltr_internal;

use namespace saltr_internal;

public class ApiCallMock extends ApiCall {

    public function ApiCallMock(isMobile:Boolean = true) {
        super(isMobile);
    }

    override saltr_internal function call(params:Object, callback:Function, timeout:int = 0):void {
        callback(getMockedCallResult());
    }

    public function getMockedCallResult():ApiCallResult {
        return new ApiCallResult();
    }
}
}
