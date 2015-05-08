/**
 * Created by TIGR on 5/5/2015.
 */
package tests.saltr.api {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.SLTConfig;
import saltr.api.AddPropertiesApiCall;
import saltr.api.ApiCallResult;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The AddPropertiesApiCallTest class contain the AddPropertiesApiCall tests
 */
public class AddPropertiesApiCallTest {
    [Embed(source="../../../../build/tests/saltr/api_call_tests/add_properties/response_success.json", mimeType="application/octet-stream")]
    private static const ResponseSuccessJson:Class;
    [Embed(source="../../../../build/tests/saltr/api_call_tests/add_properties/response_fail.json", mimeType="application/octet-stream")]
    private static const ResponseFailJson:Class;

    private var _call:AddPropertiesApiCall;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var resource:SLTResourceMock;

    public function AddPropertiesApiCallTest() {
    }

    [Before]
    public function tearUp():void {
    }

    [After]
    public function tearDown():void {
        _call = null;
    }

    /**
     * mobileCallParamsValidationSuccessTest.
     * The intent of this test is to validate passing mobile parameters.
     * Correct parameters provided.
     */
    [Test]
    public function mobileCallParamsValidationSuccessTest():void {
        createCallMobile();
        assertEquals(true, ApiCallTestHelper.validateCallParams(_call, getCorrectMobileCallParams(), SLTConfig.ACTION_ADD_PROPERTIES));
    }

    /**
     * mobileCallParamsValidationFailTest.
     * The intent of this test is to validate passing mobile parameters.
     * Incorrect parameters provided.
     */
    [Test]
    public function mobileCallParamsValidationFailTest():void {
        createCallMobile();
        assertEquals(false, ApiCallTestHelper.validateCallParams(_call, getCorrectWebCallParams(), SLTConfig.ACTION_ADD_PROPERTIES));
    }

    /**
     * webCallParamsValidationSuccessTest.
     * The intent of this test is to validate passing web parameters.
     * Correct parameters provided.
     */
    [Test]
    public function webCallParamsValidationSuccessTest():void {
        createCallWeb();
        assertEquals(true, ApiCallTestHelper.validateCallParams(_call, getCorrectWebCallParams(), SLTConfig.ACTION_ADD_PROPERTIES));
    }

    /**
     * webCallParamsValidationFailTest.
     * The intent of this test is to validate passing mobile parameters.
     * Incorrect parameters provided.
     */
    [Test]
    public function webCallParamsValidationFailTest():void {
        createCallWeb();
        assertEquals(false, ApiCallTestHelper.validateCallParams(_call, getCorrectMobileCallParams(), SLTConfig.ACTION_ADD_PROPERTIES));
    }

    /**
     * callRequestCompletedHandlerTest.
     * The intent of this test is to check the success request handling
     */
    [Test]
    public function callRequestCompletedHandlerTest():void {
        createCallMobile();
        var isCallSuccess:Boolean = false;
        var callback:Function = function (result:ApiCallResult):void {
            if (result.success) {
                isCallSuccess = true;
            } else {
                isCallSuccess = false;
            }
        };

        _call.call(getCorrectMobileCallParams(), callback);
        stub(resource).method("getResponseJsonData").returns(JSON.parse(new ResponseSuccessJson()));
        _call.callRequestCompletedHandler(resource);
        assertEquals(true, isCallSuccess);
    }

    /**
     * callRequestCompletedWithFailHandlerTest.
     * The intent of this test is to check the failed request handling
     */
    [Test]
    public function callRequestCompletedWithFailHandlerTest():void {
        createCallMobile();
        var isCallSuccess:Boolean = true;
        var callback:Function = function (result:ApiCallResult):void {
            if (result.success) {
                isCallSuccess = true;
            } else {
                isCallSuccess = false;
            }
        };

        _call.call(getCorrectMobileCallParams(), callback);
        stub(resource).method("getResponseJsonData").returns(JSON.parse(new ResponseFailJson()));
        _call.callRequestCompletedHandler(resource);
        assertEquals(false, isCallSuccess);
    }

    private function createCallMobile():void {
        _call = new AddPropertiesApiCall();
    }

    private function createCallWeb():void {
        _call = new AddPropertiesApiCall(false);
    }

    private function getCorrectMobileCallParams():Object {
        return {
            clientKey: "clientKey",
            deviceId: "deviceId",
            basicProperties: {type: "basic"},
            customProperties: {type: "custom"}
        };
    }

    private function getCorrectWebCallParams():Object {
        return {
            clientKey: "clientKey",
            socialId: "socialId",
            basicProperties: {type: "basic"},
            customProperties: {type: "custom"}
        };
    }
}
}
