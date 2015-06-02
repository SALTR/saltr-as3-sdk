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
 * The SLTSendLevelEndApiCallTest class contain the SendLevelEndApiCall tests
 */
public class SLTSendLevelEndApiCallTest extends SLTApiCallTest {
    [Embed(source="../../../../build/tests/saltr/api_call_tests/send_level_end/response_success.json", mimeType="application/octet-stream")]
    private static const ResponseSuccessJson:Class;
    [Embed(source="../../../../build/tests/saltr/api_call_tests/send_level_end/response_fail.json", mimeType="application/octet-stream")]
    private static const ResponseFailJson:Class;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var resource:SLTResourceMock;

    public function SLTSendLevelEndApiCallTest() {
        super(SLTApiFactory.API_CALL_SEND_LEVEL_END);
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
     * mobileCallParamsValidationFailTest.
     * The intent of this test is to validate passing mobile parameters.
     * Incorrect parameters provided.
     */
    [Test]
    public function mobileCallParamsValidationFailTest():void {
        createCallMobile();
        var isValidParams:Boolean = true;
        var callback:Function = function (result:SLTApiCallResult):void {
            if (result.success) {
                isValidParams = true;
            } else {
                isValidParams = false;
            }
        };
        _call.call(getCorrectWebCallParams(), callback);
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
        return {
            clientKey: "clientKey",
            deviceId: "deviceId",
            variationId: "260552",
            endReason: "Win",
            endStatus: "Win",
            score: 5500,
            customNumbericProperties: [0, 1, 3, 21],
            customTextProperties: [],
            devMode: true
        };
    }

    override protected function getCorrectWebCallParams():Object {
        return {
            clientKey: "clientKey",
            socialId: "socialId",
            variationId: "260552",
            endReason: "Win",
            endStatus: "Win",
            score: 5500,
            customNumbericProperties: [0, 1, 3, 21],
            customTextProperties: [],
            devMode: true
        };
    }
}
}
