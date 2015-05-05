/**
 * Created by TIGR on 5/5/2015.
 */
package tests.saltr.api {
import org.flexunit.asserts.assertEquals;

import saltr.api.AddPropertiesApiCall;
import saltr.api.ApiCallResult;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The AddPropertiesApiCallTest class contain the AddPropertiesApiCall tests
 */
public class AddPropertiesApiCallTest {
    private var _call:AddPropertiesApiCall;

    public function AddPropertiesApiCallTest() {
    }

    [Before]
    public function tearUp():void {
    }

    [After]
    public function tearDown():void {
        _call = null;
    }

    [Test]
    public function aaa():void {
        prepareMobile();

        var isCallSuccess:Boolean = true;
        var callback:Function = function (result:ApiCallResult):void {
            if (result.success) {
                isCallSuccess = true;
            } else {
                isCallSuccess = false;
            }
        };

        var params:Object = {
            clientKey: "clientKey",
            deviceId: "deviceId",
            socialId: "socialId",
            basicProperties: null,
            customProperties: null
        };
        _call.call(params, callback);
        assertEquals(true, isCallSuccess);
    }

    private function prepareMobile():void {
        _call = new AddPropertiesApiCall();
    }
}
}
