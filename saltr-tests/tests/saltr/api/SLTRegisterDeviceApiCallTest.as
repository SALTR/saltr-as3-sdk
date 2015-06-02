/**
 * Created by TIGR on 5/11/2015.
 */
package tests.saltr.api {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.api.SLTApiCallResult;
import saltr.api.SLTApiFactory;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTRegisterDeviceApiCallTest class contain the RegisterDeviceApiCall tests
 */
public class SLTRegisterDeviceApiCallTest extends SLTApiCallTest {
    [Embed(source="../../../../build/tests/saltr/api_call_tests/register_device/response_success.json", mimeType="application/octet-stream")]
    private static const ResponseSuccessJson:Class;
    [Embed(source="../../../../build/tests/saltr/api_call_tests/register_device/response_fail.json", mimeType="application/octet-stream")]
    private static const ResponseFailJson:Class;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var resource:SLTResourceMock;

    public function SLTRegisterDeviceApiCallTest() {
        super(SLTApiFactory.API_CALL_REGISTER_DEVICE);
    }

    [Before]
    public function tearUp():void {
    }

    [After]
    public function tearDown():void {
        clearCall();
    }

    /**
     * mobileCallParamsValidationSuccessTest.
     * The intent of this test is to validate passing mobile parameters.
     * Correct parameters provided.
     */
    [Test]
    public function mobileCallParamsValidationSuccessTest():void {
        createCallMobile();
        var isValidParams:Boolean = true;
        var callback:Function = function (result:SLTApiCallResult):void {
            if (result.success) {
                isValidParams = true;
            } else {
                isValidParams = false;
            }
        };
        _call.call(getCorrectMobileCallParams(), callback);
        assertEquals(true, isValidParams);
    }

    /**
     * mobileCallMissingEmailParamValidationFailTest.
     * The intent of this test is to validate passing mobile parameters.
     * Email needed but not passed, an Error expected.
     */
    [Test]
    public function mobileCallMissingEmailParamValidationFailTest():void {
        createCallMobile();
        var isValidParams:Boolean = true;
        var callback:Function = function (result:SLTApiCallResult):void {
            if (result.success) {
                isValidParams = true;
            } else {
                isValidParams = false;
            }
        };
        _call.call(getMobileParamsWithMissingEmail(), callback);
        assertEquals(false, isValidParams);
    }

    /**
     * callRequestCompletedHandlerTest.
     * The intent of this test is to check the success request handling
     */
    [Test]
    public function callRequestCompletedHandlerTest():void {
        var result:SLTApiCallResult;
        stub(resource).method("getResponseJsonData").returns(JSON.parse(new ResponseSuccessJson()));
        assertEquals(true, getMobileCallRequestCompletedResult(result, resource));
    }

    /**
     * callRequestCompletedWithFailHandlerTest.
     * The intent of this test is to check the failed request handling
     */
    [Test]
    public function callRequestCompletedWithFailHandlerTest():void {
        var result:SLTApiCallResult;
        stub(resource).method("getResponseJsonData").returns(JSON.parse(new ResponseFailJson()));
        assertEquals(false, getMobileCallRequestCompletedResult(result, resource));
    }

    override protected function getCorrectMobileCallParams():Object {
        var deviceInfo:Object = {
            device: "iPad 4",
            os: "iOS 8.0"
        };

        return {
            email: "valid.email@plexonic.com",
            clientKey: "clientKey",
            deviceId: "deviceId",
            deviceInfo: deviceInfo,
            devMode: true
        };
    }

    private function getMobileParamsWithMissingEmail():Object {
        var deviceInfo:Object = {
            device: "iPad 4",
            os: "iOS 8.0"
        };

        return {
            clientKey: "clientKey",
            deviceId: "deviceId",
            deviceInfo: deviceInfo,
            devMode: true
        };
    }
}
}
