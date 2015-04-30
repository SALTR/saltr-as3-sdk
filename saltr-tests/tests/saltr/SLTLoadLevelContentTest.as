/**
 * Created by TIGR on 4/30/2015.
 */
package tests.saltr {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.SLTSaltrMobile;
import saltr.api.ApiFactory;
import saltr.game.SLTLevel;
import saltr.repository.SLTMobileRepository;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTLoadLevelContentTest class contain the tests which can be performed with saltr.loadLevelContent()
 */
public class SLTLoadLevelContentTest {
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

    public function SLTLoadLevelContentTest() {
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
    }

    [After]
    public function tearDown():void {
        _saltr = null;
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

    /**
     * loadLevelContentTestFromApplicationCacheDisabled.
     * The intent of this test is to check the loadLevelContent function.
     * Not connected state, useCache = false. Data from application expected.
     */
    [Test]
    public function loadLevelContentTestFromApplicationCacheDisabled():void {
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
        _saltr.loadLevelContent(level, successCallback, failCallback, false);

        assertEquals(true, levelLoaded);
        assertEquals(true, level.contentReady);
        assertEquals("default", level.getBoard("main").layers[0].token);
        assertEquals("application", level.properties.levelDataFrom);
    }

    /**
     * loadLevelContentTestFromApplicationCacheEnabled.
     * The intent of this test is to check the loadLevelContent function.
     * Not connected state, useCache = true. Data from application expected.
     */
    [Test]
    public function loadLevelContentTestFromApplicationCacheEnabled():void {
        stub(mobileRepository).method("cacheObject").calls(function ():void {
            trace("cacheObject");
        });
        stub(mobileRepository).method("getObjectFromCache").returns(null);
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
        assertEquals("application", level.properties.levelDataFrom);
    }

    /**
     * loadLevelContentTestFromSaltrCacheDisabled
     * The intent of this test is to check the loadLevelContent function.
     * connected = true, useCache = false. Data from saltr expected.
     */
    [Test]
    public function loadLevelContentTestFromSaltrCacheDisabled():void {
//        var apiCallResult:ApiCallResult = new ApiCallResult();
//        apiCallResult.data = JSON.parse(new LevelDataFromSaltrJson());
//        apiCallResult.success = true;
//        stub(apiCallMock).method("getMockedCallResult").returns(apiCallResult);
//
//        var levelLoaded:Boolean = false;
//        var failCallback:Function = function ():void {
//            levelLoaded = false;
//        };
//        var successCallback:Function = function ():void {
//            levelLoaded = true;
//        };
//        var levelProperties:Object = {
//            "movesCount": "18",
//            "objectives": {
//                "explode-melon": "2"
//            },
//            "star_milestones": "150,350,1150",
//            "boosts": {
//                "BOOST_COLOR_REMOVER": false,
//                "BOOST_MAGIC_SEED": false,
//                "BOOST_SHOVEL": false
//            },
//            "isMelnSplashDisabled": true,
//            "isMatchFourExplosionDisabled": true,
//            "isMatchCrossExplosionDisabled": true,
//            "isMatchFiveExplosionDisabled": true,
//            "isTutorialDisabled": true
//        };
//        var level:SLTLevel = new SLTLevel("225045", "246970", "matching", 0, 0, 0, "pack_0/level_0.json", levelProperties, "44");
//        assertEquals(false, level.contentReady);
//        _saltr.loadLevelContent(level, successCallback, failCallback, false);
    }
}
}
