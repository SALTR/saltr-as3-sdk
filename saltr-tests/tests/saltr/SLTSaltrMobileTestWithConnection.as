/**
 * Created by TIGR on 4/28/2015.
 */
package tests.saltr {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.SLTExperiment;
import saltr.SLTSaltrMobile;
import saltr.api.call.SLTApiCallFactory;
import saltr.repository.SLTMobileRepository;
import saltr.saltr_internal;
import saltr.status.SLTStatus;

use namespace saltr_internal;

/**
 * The SLTSaltrMobileTestWithConnection class contain the tests which can be performed with saltr.connect()
 */
public class SLTSaltrMobileTestWithConnection {
    [Embed(source="../../../build/tests/saltr/app_data_cache.json", mimeType="application/octet-stream")]
    private static const AppDataJson:Class;

    [Embed(source="../../../build/tests/saltr/level_data.json", mimeType="application/octet-stream")]
    private static const LevelPacksJson:Class;

    private var clientKey:String = "";
    private var deviceId:String = "";
    private var _saltr:SLTSaltrMobile;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var mobileRepository:SLTMobileRepository;
    [Mock(type="nice")]
    public var apiFactory:SLTApiCallFactory;
    [Mock(type="nice")]
    public var apiCallMock:ApiCallMock;

    public function SLTSaltrMobileTestWithConnection() {
    }

    [Before]
    public function tearUp():void {
        stub(mobileRepository).method("getObjectFromApplication").returns(JSON.parse(new LevelPacksJson()));
        stub(mobileRepository).method("cacheObject").calls(function ():void {
            trace("cacheObject");
        });
        stub(mobileRepository).method("getObjectFromCache").returns(null);

        stub(apiFactory).method("getCall").returns(apiCallMock);

        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.apiFactory = apiFactory;
        _saltr.repository = mobileRepository;

        _saltr.defineGenericFeature("SETTINGS", {
            general: {
                lifeRefillTime: 30
            }
        }, true);

        //importLevels() takes as input levels path, in this test it is just a dummy value because of MobileRepository's mocking
        //_saltr.importLevels("");
    }

    [After]
    public function tearDown():void {
        _saltr = null;
    }

    /**
     * connectTestNotStarted.
     * The intent of this test is to check the connect function without start(). An Error should be thrown.
     */
    [Test(expects="Error")]
    public function connectTestNotStarted():void {
        var successCallback:Function;
        var failCallback:Function;
        _saltr.connect(successCallback, failCallback);
    }

    /**
     * connectTestFailCallback.
     * The intent of this test is to check the connect function. Failed callback should be called.
     */
    [Test]
    public function connectTestFailCallback():void {
        stub(apiCallMock).method("getMockSuccess").returns(false);
        stub(apiCallMock).method("getMockFailStatus").returns(new SLTStatus(SLTStatus.API_ERROR, "API call request failed."));

        var isFailed:Boolean = false;
        var successCallback:Function;
        var failCallback:Function = function ():void {
            isFailed = true;
        };

        _saltr.start();
        _saltr.connect(successCallback, failCallback);
        assertEquals(true, isFailed);
    }

    /**
     * connectTestWithSuccess.
     * The intent of this test is to check the connect function.
     * Everything is OK, sync() not called.
     */
    [Test]
    public function connectTestWithSuccess():void {
        stub(apiCallMock).method("getMockSuccess").returns(true);
        stub(apiCallMock).method("getMockSuccessData").returns(JSON.parse(new AppDataJson()));

        var isConnected:Boolean = false;
        var failCallback:Function;
        var successCallback:Function = function ():void {
            isConnected = true;
        };

        _saltr.start();
        _saltr.connect(successCallback, failCallback);

        var experiments:Vector.<SLTExperiment> = _saltr.experiments;

        var testPassed:Boolean = true;
        if (false == isConnected || 1 != experiments.length || "EXP1" != experiments[0].token || "feature" != experiments[0].type ||
                "A" != experiments[0].partition || 5 != _saltr.getGameLevelFeatureProperties(SLTSaltrTest.GAME_LEVELS_FEATURE).allLevelsCount) {
            testPassed = false;
        }
        assertEquals(true, testPassed);
    }
}
}
