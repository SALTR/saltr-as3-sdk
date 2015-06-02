/**
 * Created by TIGR on 5/5/2015.
 */
package tests.saltr.api {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.SLTConfig;
import saltr.api.SLTApiCallResult;
import saltr.api.SLTApiFactory;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTAddPropertiesApiCallTest class contain the AddPropertiesApiCall tests
 */
public class SLTAddPropertiesApiCallTest extends SLTApiCallTest {
    [Embed(source="../../../../build/tests/saltr/api_call_tests/add_properties/response_success.json", mimeType="application/octet-stream")]
    private static const ResponseSuccessJson:Class;
    [Embed(source="../../../../build/tests/saltr/api_call_tests/add_properties/response_fail.json", mimeType="application/octet-stream")]
    private static const ResponseFailJson:Class;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var resource:SLTResourceMock;

    public function SLTAddPropertiesApiCallTest() {
        super(SLTApiFactory.API_CALL_ADD_PROPERTIES);
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
        assertEquals(true, validateParams(getCorrectMobileCallParams(), SLTConfig.ACTION_ADD_PROPERTIES));
    }

    /**
     * mobileCallParamsValidationFailTest.
     * The intent of this test is to validate passing mobile parameters.
     * Incorrect parameters provided.
     */
    [Test]
    public function mobileCallParamsValidationFailTest():void {
        createCallMobile();
        assertEquals(false, validateParams(getCorrectWebCallParams(), SLTConfig.ACTION_ADD_PROPERTIES));
    }

    /**
     * webCallParamsValidationSuccessTest.
     * The intent of this test is to validate passing web parameters.
     * Correct parameters provided.
     */
    [Test]
    public function webCallParamsValidationSuccessTest():void {
        createCallWeb();
        assertEquals(true, validateParams(getCorrectWebCallParams(), SLTConfig.ACTION_ADD_PROPERTIES));
    }

    /**
     * webCallParamsValidationFailTest.
     * The intent of this test is to validate passing mobile parameters.
     * Incorrect parameters provided.
     */
    [Test]
    public function webCallParamsValidationFailTest():void {
        createCallWeb();
        assertEquals(false, validateParams(getCorrectMobileCallParams(), SLTConfig.ACTION_ADD_PROPERTIES));
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
            basicProperties: {type: "basic"},
            customProperties: {type: "custom"}
        };
    }

    override protected function getCorrectWebCallParams():Object {
        return {
            clientKey: "clientKey",
            socialId: "socialId",
            basicProperties: {type: "basic"},
            customProperties: {type: "custom"}
        };
    }
}
}
