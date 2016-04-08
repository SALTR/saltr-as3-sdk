/**
 * Created by TIGR on 5/8/2015.
 */
package tests.saltr.api {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.api.call.factory.SLTApiCallFactory;
import saltr.api.call.SLTApiCallResult;
import saltr.saltr_internal;
import saltr.status.SLTStatus;

use namespace saltr_internal;

/**
 * The SLTLevelContentApiCallTest class contain the LevelContentApiCall tests
 */
public class SLTLevelContentApiCallTest extends SLTApiCallTest {
    [Embed(source="../../../../build/tests/saltr/api_call_tests/level_content/response_success.json", mimeType="application/octet-stream")]
    private static const ResponseSuccessJson:Class;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var resource:SLTResourceMock;

    public function SLTLevelContentApiCallTest() {
        super(SLTApiCallFactory.API_CALL_LEVEL_CONTENT);
    }

    [Before]
    public function tearUp():void {
    }

    [After]
    public function tearDown():void {
        clearCall();
    }

    /**
     * callParamsValidationSuccessTest.
     * The intent of this test is to validate passing mobile parameters.
     * Correct parameters provided.
     */
    [Test]
    public function callParamsValidationSuccessTest():void {
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
        stub(resource).method("getResponseJsonData").returns(null);
        assertEquals(false, getMobileCallRequestCompletedResult(successData, failStatus, resource));
    }

    override protected function getCorrectMobileCallParams():Object {
        return {
            levelContentUrl: "https://api.saltr.com/static_data/402e3c45-f934-535f-ae1a-6be2a90b4d2e/levels/260557_604.json?_time_=1431091498203"
        };
    }
}
}
