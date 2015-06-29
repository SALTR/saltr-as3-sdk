///**
// * Created by TIGR on 4/30/2015.
// */
//package tests.saltr {
//import mockolate.runner.MockolateRule;
//import mockolate.stub;
//
//import org.flexunit.asserts.assertEquals;
//
//import saltr.SLTConfig;
//import saltr.SLTSaltrMobile;
//import saltr.api.SLTApiCallResult;
//import saltr.api.SLTApiFactory;
//import saltr.game.SLTLevel;
//import saltr.repository.SLTMobileRepository;
//import saltr.saltr_internal;
//
//use namespace saltr_internal;
//
///**
// * The SLTLoadLevelContentTest class contain the tests which can be performed with saltr.loadLevelContent()
// */
//public class SLTLoadLevelContentMobileTest {
//    [Embed(source="../../../build/tests/saltr/app_data.json", mimeType="application/octet-stream")]
//    private static const AppDataJson:Class;
//
//    [Embed(source="../../../build/tests/saltr/level_packs.json", mimeType="application/octet-stream")]
//    private static const LevelPacksJson:Class;
//
//    [Embed(source="../../../build/tests/saltr/level_0_chached.json", mimeType="application/octet-stream")]
//    private static const LevelDataCachedJson:Class;
//    [Embed(source="../../../build/tests/saltr/level_0_from_application.json", mimeType="application/octet-stream")]
//    private static const LevelDataFromApplicationJson:Class;
//    [Embed(source="../../../build/tests/saltr/level_0_from_saltr.json", mimeType="application/octet-stream")]
//    private static const LevelDataFromSaltrJson:Class;
//
//    private var clientKey:String = "";
//    private var deviceId:String = "";
//    private var _saltr:SLTSaltrMobile;
//
//    [Rule]
//    public var mocks:MockolateRule = new MockolateRule();
//    [Mock(type="nice")]
//    public var mobileRepository:SLTMobileRepository;
//    [Mock(type="nice")]
//    public var apiFactory:SLTApiFactory;
//    [Mock(type="nice")]
//    public var apiCallGeneralMock:ApiCallMock;
//    [Mock(type="nice")]
//    public var apiCallLevelContentMock:ApiCallMock;
//
//    public function SLTLoadLevelContentMobileTest() {
//    }
//
//    [Before]
//    public function tearUp():void {
//        stub(apiFactory).method("getCall").args("AppData", true).returns(apiCallGeneralMock);
//        stub(apiFactory).method("getCall").args("LevelContent", true).returns(apiCallLevelContentMock);
//
//        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
//        _saltr.apiFactory = apiFactory;
//        _saltr.repository = mobileRepository;
//
//        _saltr.defineFeature("SETTINGS", {
//            general: {
//                lifeRefillTime: 30
//            }
//        }, true);
//    }
//
//    [After]
//    public function tearDown():void {
//        _saltr = null;
//    }
//
//    /**
//     * loadLevelContentTestFromCache
//     * The intent of this test is to check the loadLevelContent function.
//     * Not connected state, useCache = true. Cached data expected.
//     */
//    [Test]
//    public function loadLevelContentTestFromCache():void {
//        stub(mobileRepository).method("cacheObject").calls(function ():void {
//            trace("cacheObject");
//        });
//        stub(mobileRepository).method("getObjectFromCache").returns(JSON.parse(new LevelDataCachedJson()));
//        stub(mobileRepository).method("getObjectFromApplication").returns(JSON.parse(new LevelDataFromApplicationJson()));
//
//        var levelLoaded:Boolean = false;
//        var failCallback:Function = function ():void {
//            levelLoaded = false;
//        };
//        var successCallback:Function = function ():void {
//            levelLoaded = true;
//        };
//        var levelProperties:Object = {
//            "movesCount": "18"
//        };
//        var level:SLTLevel = new SLTLevel("225045", "246970", "matching", 0, 0, 0, "pack_0/level_0.json", levelProperties, "44");
//
//        var testPassed:Boolean = false;
//        if (false == level.contentReady) {
//            _saltr.loadLevelContent(level, successCallback, failCallback);
//            if (true == levelLoaded && true == level.contentReady && "default" == level.getBoard("main").layers[0].token && "cached" == level.properties.levelDataFrom) {
//                testPassed = true;
//            }
//        }
//        assertEquals(true, testPassed);
//    }
//
//    /**
//     * loadLevelContentTestFromApplicationCacheDisabled.
//     * The intent of this test is to check the loadLevelContent function.
//     * Not connected state, useCache = false. Data from application expected.
//     */
//    [Test]
//    public function loadLevelContentTestFromApplicationCacheDisabled():void {
//        stub(mobileRepository).method("cacheObject").calls(function ():void {
//            trace("cacheObject");
//        });
//        stub(mobileRepository).method("getObjectFromCache").returns(JSON.parse(new LevelDataCachedJson()));
//        stub(mobileRepository).method("getObjectFromApplication").returns(JSON.parse(new LevelDataFromApplicationJson()));
//
//        var levelLoaded:Boolean = false;
//        var failCallback:Function = function ():void {
//            levelLoaded = false;
//        };
//        var successCallback:Function = function ():void {
//            levelLoaded = true;
//        };
//        var levelProperties:Object = {
//            "movesCount": "18"
//        };
//        var level:SLTLevel = new SLTLevel("225045", "246970", "matching", 0, 0, 0, "pack_0/level_0.json", levelProperties, "44");
//
//        var testPassed:Boolean = false;
//        if (false == level.contentReady) {
//            _saltr.loadLevelContent(level, successCallback, failCallback, false);
//            if (true == levelLoaded && true == level.contentReady && "default" == level.getBoard("main").layers[0].token && "application" == level.properties.levelDataFrom) {
//                testPassed = true;
//            }
//        }
//        assertEquals(true, testPassed);
//    }
//
//    /**
//     * loadLevelContentTestFromApplicationCacheEnabled.
//     * The intent of this test is to check the loadLevelContent function.
//     * Not connected state, useCache = true. Data from application expected.
//     */
//    [Test]
//    public function loadLevelContentTestFromApplicationCacheEnabled():void {
//        stub(mobileRepository).method("cacheObject").calls(function ():void {
//            trace("cacheObject");
//        });
//        stub(mobileRepository).method("getObjectFromCache").returns(null);
//        stub(mobileRepository).method("getObjectFromApplication").returns(JSON.parse(new LevelDataFromApplicationJson()));
//
//        var levelLoaded:Boolean = false;
//        var failCallback:Function = function ():void {
//            levelLoaded = false;
//        };
//        var successCallback:Function = function ():void {
//            levelLoaded = true;
//        };
//        var levelProperties:Object = {
//            "movesCount": "18"
//        };
//        var level:SLTLevel = new SLTLevel("225045", "246970", "matching", 0, 0, 0, "pack_0/level_0.json", levelProperties, "44");
//
//        var testPassed:Boolean = false;
//        if (false == level.contentReady) {
//            _saltr.loadLevelContent(level, successCallback, failCallback);
//            if (true == levelLoaded && true == level.contentReady && "default" == level.getBoard("main").layers[0].token && "application" == level.properties.levelDataFrom) {
//                testPassed = true;
//            }
//        }
//        assertEquals(true, testPassed);
//    }
//
//    /**
//     * loadLevelContentTestFromSaltrCacheDisabled.
//     * The intent of this test is to check the loadLevelContent function.
//     * connected = true, useCache = false. Data from saltr expected.
//     */
//    [Test]
//    public function loadLevelContentTestFromSaltrCacheDisabled():void {
//        prepareLoadLevelContentConnected();
//
//        var levelLoaded:Boolean = false;
//        var loadLevelContentFailCallback:Function = function ():void {
//            levelLoaded = false;
//        };
//        var loadLevelContentSuccessCallback:Function = function ():void {
//            levelLoaded = true;
//        };
//        var levelProperties:Object = {
//            "movesCount": "18"
//        };
//        var level:SLTLevel = new SLTLevel("225045", "246970", "matching", 0, 0, 0, "pack_0/level_0.json", levelProperties, "44");
//
//        var testPassed:Boolean = false;
//        if (false == level.contentReady) {
//            _saltr.loadLevelContent(level, loadLevelContentSuccessCallback, loadLevelContentFailCallback, false);
//            if (true == levelLoaded && true == level.contentReady && "default" == level.getBoard("main").layers[0].token && "saltr" == level.properties.levelDataFrom) {
//                testPassed = true;
//            }
//        }
//        assertEquals(true, testPassed);
//    }
//
//    /**
//     * loadLevelContentTestFromSaltrCacheEnabledDifferentVersions.
//     * The intent of this test is to check the loadLevelContent function.
//     * connected = true, useCache = true. Different level versions in cache. Data from saltr expected.
//     */
//    [Test]
//    public function loadLevelContentTestFromSaltrCacheEnabledDifferentVersions():void {
//        prepareLoadLevelContentConnected();
//
//        var levelLoaded:Boolean = false;
//        var loadLevelContentFailCallback:Function = function ():void {
//            levelLoaded = false;
//        };
//        var loadLevelContentSuccessCallback:Function = function ():void {
//            levelLoaded = true;
//        };
//        var levelProperties:Object = {
//            "movesCount": "18"
//        };
//        var level:SLTLevel = new SLTLevel("225045", "246970", "matching", 0, 0, 0, "pack_0/level_0.json", levelProperties, "44");
//
//        var testPassed:Boolean = false;
//        if (false == level.contentReady) {
//            _saltr.loadLevelContent(level, loadLevelContentSuccessCallback, loadLevelContentFailCallback);
//            if (true == levelLoaded && true == level.contentReady && "default" == level.getBoard("main").layers[0].token && "saltr" == level.properties.levelDataFrom) {
//                testPassed = true;
//            }
//        }
//        assertEquals(true, testPassed);
//    }
//
//    /**
//     * loadLevelContentFromCacheConnected.
//     * The intent of this test is to check the loadLevelContent function.
//     * connected = true, useCache = true. Provided level version in cache matches with level version in cache. Data from cache expected.
//     */
//    [Test]
//    public function loadLevelContentFromCacheConnected():void {
//        prepareLoadLevelContentConnected();
//
//        var levelLoaded:Boolean = false;
//        var loadLevelContentFailCallback:Function = function ():void {
//            levelLoaded = false;
//        };
//        var loadLevelContentSuccessCallback:Function = function ():void {
//            levelLoaded = true;
//        };
//        var levelProperties:Object = {
//            "movesCount": "18"
//        };
//        var level:SLTLevel = new SLTLevel("225045", "246970", "matching", 0, 0, 0, "pack_0/level_0.json", levelProperties, "45");
//
//        var testPassed:Boolean = false;
//        if (false == level.contentReady) {
//            _saltr.loadLevelContent(level, loadLevelContentSuccessCallback, loadLevelContentFailCallback);
//            if (true == levelLoaded && true == level.contentReady && "default" == level.getBoard("main").layers[0].token && "cached" == level.properties.levelDataFrom) {
//                testPassed = true;
//            }
//        }
//        assertEquals(true, testPassed);
//    }
//
//    private function prepareLoadLevelContentConnected():void {
//        stub(mobileRepository).method("getObjectFromApplication").returns(JSON.parse(new LevelPacksJson()));
//        stub(mobileRepository).method("cacheObject").calls(function ():void {
//            trace("cacheObject");
//        });
//        stub(mobileRepository).method("getObjectFromCache").args(SLTConfig.APP_DATA_URL_CACHE).returns(null);
//        stub(mobileRepository).method("getObjectFromCache").args("pack_0_level_0.json").returns(JSON.parse(new LevelDataCachedJson()));
//        stub(mobileRepository).method("getObjectVersion").args("pack_0_level_0.json").returns("45");
//
//        _saltr.importLevels("");
//
//        var apiCallResultGeneral:SLTApiCallResult = new SLTApiCallResult();
//        apiCallResultGeneral.data = JSON.parse(new AppDataJson);
//        apiCallResultGeneral.success = true;
//        stub(apiCallGeneralMock).method("getMockedCallResult").returns(apiCallResultGeneral);
//
//        var apiCallResultLevelContent:SLTApiCallResult = new SLTApiCallResult();
//        apiCallResultLevelContent.data = JSON.parse(new LevelDataFromSaltrJson);
//        apiCallResultLevelContent.success = true;
//        stub(apiCallLevelContentMock).method("getMockedCallResult").returns(apiCallResultLevelContent);
//
//        var isConnected:Boolean = false;
//        var connectFailCallback:Function;
//        var connectSuccessCallback:Function = function ():void {
//            isConnected = true;
//        };
//
//        _saltr.start();
//        _saltr.connect(connectSuccessCallback, connectFailCallback);
//    }
//}
//}
