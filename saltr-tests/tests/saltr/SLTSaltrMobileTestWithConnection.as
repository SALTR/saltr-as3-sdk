/**
 * Created by TIGR on 4/28/2015.
 */
package tests.saltr {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.SLTExperiment;
import saltr.SLTSaltrMobile;
import saltr.api.ApiCallResult;
import saltr.api.ApiFactory;
import saltr.game.SLTLevel;
import saltr.repository.SLTMobileRepository;
import saltr.saltr_internal;
import saltr.status.SLTStatus;

use namespace saltr_internal;

/**
 * The SLTSaltrMobileTestWithConnection class contain the tests which can be performed with saltr.connect()
 */
public class SLTSaltrMobileTestWithConnection {
    [Embed(source="../../../build/tests/saltr/app_data.json", mimeType="application/octet-stream")]
    private static const AppDataJson:Class;

    [Embed(source="../../../build/tests/saltr/level_packs.json", mimeType="application/octet-stream")]
    private static const LevelPacksJson:Class;

    [Embed(source="../../../build/tests/saltr/level_0_chached.json", mimeType="application/octet-stream")]
    private static const LevelDataCachedJson:Class;
    [Embed(source="../../../build/tests/saltr/level_0_from_application.json", mimeType="application/octet-stream")]
    private static const LevelDataFromApplicationJson:Class;
    [Embed(source="../../../build/tests/saltr/level_0_from_saltr.json", mimeType="application/octet-stream")]
    private static const LevelDataFromSaltrJson:Class;

    private var clientKey:String = "";
    private var deviceId:String = "";
    private var _saltr:SLTSaltrMobile;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var mobileRepository:SLTMobileRepository;
    [Mock(type="nice")]
    public var apiFactory:ApiFactory;
    [Mock(type="nice")]
    public var apiCallMock:ApiCallMock;

    public function SLTSaltrMobileTestWithConnection() {
    }

    [Before]
    public function tearUp():void {
        stub(apiFactory).method("getCall").returns(apiCallMock);

        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.apiFactory = apiFactory;
        _saltr.repository = mobileRepository;

        _saltr.defineFeature("SETTINGS", {
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
        prepareStandard();

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
        prepareStandard();

        var apiCallResult:ApiCallResult = new ApiCallResult();
        apiCallResult.status = new SLTStatus(SLTStatus.API_ERROR, "API call request failed.");
        stub(apiCallMock).method("getMockedCallResult").returns(apiCallResult);

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
        prepareStandard();

        var apiCallResult:ApiCallResult = new ApiCallResult();
        apiCallResult.data = JSON.parse(new AppDataJson());
        apiCallResult.success = true;
        stub(apiCallMock).method("getMockedCallResult").returns(apiCallResult);

        var isConnected:Boolean = false;
        var failCallback:Function;
        var successCallback:Function = function ():void {
            isConnected = true;
        };

        _saltr.start();
        _saltr.connect(successCallback, failCallback);
        assertEquals(true, isConnected);

        var experiments:Vector.<SLTExperiment> = _saltr.experiments;
        assertEquals(1, experiments.length);
        assertEquals("EXP1", experiments[0].token);
        assertEquals("feature", experiments[0].type);
        assertEquals("A", experiments[0].partition);

        assertEquals(75, _saltr.allLevelsCount);
        assertEquals(5, _saltr.levelPacks.length);
    }

    /**
     * loadLevelContentTestFromCache
     * The intent of this test is to check the loadLevelContent function.
     * Not connected state, useCache = true. Cached data expected.
     */
    [Test]
    public function loadLevelContentTestFromCache():void {
        stub(mobileRepository).method("cacheObject").calls(function ():void {
            trace("cacheObject");
        });
        stub(mobileRepository).method("getObjectFromCache").returns(JSON.parse(new LevelDataCachedJson()));
        stub(mobileRepository).method("getObjectFromApplication").returns(JSON.parse(new LevelDataFromApplicationJson()));

        var levelLoaded:Boolean = false;
        var failCallback:Function = function ():void {
            levelLoaded = false;
        };
        var successCallback:Function = function ():void {
            levelLoaded = true;
        };
        var levelProperties:Object = {
            "movesCount": "18",
            "objectives": {
                "explode-melon": "2"
            },
            "star_milestones": "150,350,1150",
            "boosts": {
                "BOOST_COLOR_REMOVER": false,
                "BOOST_MAGIC_SEED": false,
                "BOOST_SHOVEL": false
            },
            "isMelnSplashDisabled": true,
            "isMatchFourExplosionDisabled": true,
            "isMatchCrossExplosionDisabled": true,
            "isMatchFiveExplosionDisabled": true,
            "isTutorialDisabled": true
        };
        var level:SLTLevel = new SLTLevel("225045", "246970", "matching", 0, 0, 0, "pack_0/level_0.json", levelProperties, "44");
        assertEquals(false, level.contentReady);
        _saltr.loadLevelContent(level, successCallback, failCallback);

        assertEquals(true, levelLoaded);
        assertEquals(true, level.contentReady);
        assertEquals("default", level.getBoard("main").layers[0].token);
        assertEquals("cached", level.properties.levelDataFrom);
    }

    private function prepareStandard():void {
        stub(mobileRepository).method("getObjectFromApplication").returns(JSON.parse(new LevelPacksJson()));
        stub(mobileRepository).method("cacheObject").calls(function ():void {
            trace("cacheObject");
        });
        stub(mobileRepository).method("getObjectFromCache").returns(null);
        //importLevels() takes as input levels path, in this test it is just a dummy value because of MobileRepository's mocking
        _saltr.importLevels("");
    }
}
}
