/**
* Created by TIGR on 5/12/2015.
*/
package tests.saltr.api {
import flash.utils.Dictionary;

import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.SLTConfig;

import saltr.SLTFeature;
import saltr.api.SLTApiCallResult;
import saltr.api.SLTApiFactory;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
* The SLTSyncApiCallTest class contain the SyncApiCall tests
*/
public class SLTSyncApiCallTest extends SLTApiCallTest {
    [Embed(source="../../../../build/tests/saltr/api_call_tests/sync/response_success.json", mimeType="application/octet-stream")]
    private static const ResponseSuccessJson:Class;
    [Embed(source="../../../../build/tests/saltr/api_call_tests/sync/response_fail.json", mimeType="application/octet-stream")]
    private static const ResponseFailJson:Class;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var resource:SLTResourceMock;

    public function SLTSyncApiCallTest() {
        super(SLTApiFactory.API_CALL_SYNC);
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
     * webCallParamsValidationFailTest.
     * The intent of this test is to validate passing web parameters.
     * Incorrect parameters provided.
     */
    [Test]
    public function webCallParamsValidationFailTest():void {
        createCallWeb();
        var isValidParams:Boolean = true;
        var callback:Function = function (result:SLTApiCallResult):void {
            if (result.success) {
                isValidParams = true;
            } else {
                isValidParams = false;
            }
        };
        _call.call(getCorrectMobileCallParams(), callback);
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
        var features:Dictionary = new Dictionary();
        features["COLLECT_SCROLLING"] = new SLTFeature("COLLECT_SCROLLING", SLTConfig.FEATURE_TYPE_GENERIC, {"bottom-row-limit": 3}, true);
        return {
            clientKey: "clientKey",
            deviceId: "deviceId",
            devMode: true,
            defaultFeatures: features
        };
    }

    override protected function getCorrectWebCallParams():Object {
        var features:Dictionary = new Dictionary();
        features["COLLECT_SCROLLING"] = new SLTFeature("COLLECT_SCROLLING", SLTConfig.FEATURE_TYPE_GENERIC, {"bottom-row-limit": 3}, true);
        return {
            clientKey: "clientKey",
            socialId: "socialId",
            devMode: true,
            defaultFeatures: features
        };
    }
}
}
