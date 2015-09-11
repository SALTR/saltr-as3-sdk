/**
 * Created by TIGR on 5/11/2015.
 */
package tests.saltr.api {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.api.call.SLTApiCallFactory;
import saltr.api.call.SLTApiCallResult;
import saltr.saltr_internal;
import saltr.status.SLTStatus;

use namespace saltr_internal;

/**
 * The SLTRegisterUserApiCallTest class contain the RegisterUserApiCall tests
 */
public class SLTRegisterUserApiCallTest extends SLTApiCallTest {
    [Embed(source="../../../../build/tests/saltr/api_call_tests/register_user/response_success.json", mimeType="application/octet-stream")]
    private static const ResponseSuccessJson:Class;
    [Embed(source="../../../../build/tests/saltr/api_call_tests/register_user/response_fail.json", mimeType="application/octet-stream")]
    private static const ResponseFailJson:Class;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var resource:SLTResourceMock;

    public function SLTRegisterUserApiCallTest() {
        super(SLTApiCallFactory.API_CALL_REGISTER_USER);
    }

    [Before]
    public function tearUp():void {
    }

    [After]
    public function tearDown():void {
        clearCall();
    }

    /**
     * webCallParamsValidationSuccessTest.
     * The intent of this test is to validate passing web parameters.
     * Correct parameters provided.
     */
    [Test]
    public function webCallParamsValidationSuccessTest():void {
        createCallWeb();
        var isValidParams:Boolean = true;
        var callback:Function = function (result:SLTApiCallResult):void {
            if (result.success) {
                isValidParams = true;
            } else {
                isValidParams = false;
            }
        };
        _call.call(getCorrectWebCallParams(), callback);
        assertEquals(true, isValidParams);
    }

    /**
     * webCallMissingEmailParamValidationFailTest.
     * The intent of this test is to validate passing web parameters.
     * Email needed but not passed, an Error expected.
     */
    [Test]
    public function webCallMissingEmailParamValidationFailTest():void {
        createCallMobile();
        var isValidParams:Boolean = true;
        var successCallback:Function = function (data:Object):void {
            isValidParams = true;
        };

        var failCallback:Function = function (status:SLTStatus):void {
            isValidParams = false;
        };
        _call.call(getWebParamsWithMissingEmail(), successCallback, failCallback);
        assertEquals(false, isValidParams);
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
        assertEquals(true, getWebCallRequestCompletedResult(successData, failStatus, resource));
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
        assertEquals(false, getWebCallRequestCompletedResult(successData, failStatus, resource));
    }

    override protected function getCorrectWebCallParams():Object {
        return {
            email: "valid.email@plexonic.com",
            clientKey: "clientKey",
            socialId: "socialId",
            platform: "fb",
            devMode: true
        };
    }

    private function getWebParamsWithMissingEmail():Object {
        return {
            clientKey: "clientKey",
            socialId: "socialId",
            platform: "fb",
            devMode: true
        };
    }
}
}
