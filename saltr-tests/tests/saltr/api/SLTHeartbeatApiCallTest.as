/**
 * Created by TIGR on 5/8/2015.
 */
package tests.saltr.api {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.SLTConfig;
import saltr.api.call.factory.SLTApiCallFactory;
import saltr.saltr_internal;
import saltr.status.SLTStatus;

use namespace saltr_internal;

/**
 * The SLTHeartbeatApiCallTest class contain the HeartbeatApiCall tests
 */
public class SLTHeartbeatApiCallTest extends SLTApiCallTest {
    [Embed(source="../../../../build/tests/saltr/api_call_tests/heartbeat/response_success.json", mimeType="application/octet-stream")]
    private static const ResponseSuccessJson:Class;
    [Embed(source="../../../../build/tests/saltr/api_call_tests/heartbeat/response_fail.json", mimeType="application/octet-stream")]
    private static const ResponseFailJson:Class;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var resource:SLTResourceMock;

    public function SLTHeartbeatApiCallTest() {
        super(SLTApiCallFactory.API_CALL_HEARTBEAT);
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
        assertEquals(true, validateParams(getCorrectMobileCallParams(), SLTConfig.ACTION_HEARTBEAT));
    }

    /**
     * mobileCallParamsValidationFailTest.
     * The intent of this test is to validate passing mobile parameters.
     * Incorrect parameters provided.
     */
    [Test]
    public function mobileCallParamsValidationFailTest():void {
        createCallMobile();
        assertEquals(false, validateParams(getCorrectWebCallParams(), SLTConfig.ACTION_HEARTBEAT));
    }

    /**
     * webCallParamsValidationSuccessTest.
     * The intent of this test is to validate passing web parameters.
     * Correct parameters provided.
     */
    [Test]
    public function webCallParamsValidationSuccessTest():void {
        createCallWeb();
        assertEquals(true, validateParams(getCorrectWebCallParams(), SLTConfig.ACTION_HEARTBEAT));
    }

    /**
     * webCallParamsValidationFailTest.
     * The intent of this test is to validate passing mobile parameters.
     * Incorrect parameters provided.
     */
    [Test]
    public function webCallParamsValidationFailTest():void {
        createCallWeb();
        assertEquals(false, validateParams(getCorrectMobileCallParams(), SLTConfig.ACTION_HEARTBEAT));
    }

    /**
     * callRequestCompletedHandlerTest.
     * The intent of this test is to check the success request handling
     */
    [Test]
    public function callRequestCompletedHandlerTest():void {
        var successData:Object;
        var failStatus:SLTStatus;
        stub(resource).method("getResponseJsonData").returns(JSON.parse(new ResponseSuccessJson()));
        assertEquals(true, getMobileCallRequestCompletedResult(successData, failStatus, resource));
    }

    /**
     * callRequestCompletedWithFailHandlerTest.
     * The intent of this test is to check the failed request handling
     */
    [Test]
    public function callRequestCompletedWithFailHandlerTest():void {
        var successData:Object;
        var failStatus:SLTStatus;
        stub(resource).method("getResponseJsonData").returns(JSON.parse(new ResponseFailJson()));
        assertEquals(false, getMobileCallRequestCompletedResult(successData, failStatus, resource));
    }

    override protected function getCorrectMobileCallParams():Object {
        return {
            clientKey: "clientKey",
            deviceId: "deviceId",
            devMode: true
        };
    }

    override protected function getCorrectWebCallParams():Object {
        return {
            clientKey: "clientKey",
            socialId: "socialId",
            devMode: true
        };
    }
}
}
