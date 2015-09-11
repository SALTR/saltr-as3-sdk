///**
// * Created by TIGR on 5/12/2015.
// */
//package tests.saltr {
//import mockolate.runner.MockolateRule;
//import mockolate.stub;
//
//import org.flexunit.asserts.assertEquals;
//
//import saltr.SLTSaltrWeb;
//import saltr.api.SLTApiCallResult;
//import saltr.api.SLTApiCallFactory;
//import saltr.game.SLTLevel;
//import saltr.saltr_internal;
//
//use namespace saltr_internal;
//
///**
// * The SLTSaltrWebTest class contain the tests which can be performed without saltr.connect()
// */
//public class SLTSaltrWebTest extends SLTSaltrTest {
//    [Embed(source="../../../build/tests/saltr/app_data.json", mimeType="application/octet-stream")]
//    private static const AppDataJson:Class;
//    [Embed(source="../../../build/tests/saltr/level_packs.json", mimeType="application/octet-stream")]
//    private static const LevelPacksJson:Class;
//    [Embed(source="../../../build/tests/saltr/level_0_from_saltr.json", mimeType="application/octet-stream")]
//    private static const LevelDataFromSaltrJson:Class;
//
//    private var clientKey:String = "";
//    private var socialId:String = "";
//    private var _saltr:SLTSaltrWeb;
//
//    [Rule]
//    public var mocks:MockolateRule = new MockolateRule();
//    [Mock(type="nice")]
//    public var apiFactory:SLTApiCallFactory;
//    [Mock(type="nice")]
//    public var apiCallGeneralMock:ApiCallMock;
//    [Mock(type="nice")]
//    public var apiCallLevelContentMock:ApiCallMock;
//
//    public function SLTSaltrWebTest() {
//    }
//
//    [Before]
//    public function tearUp():void {
//        stub(apiFactory).method("getCall").args("AppData", false).returns(apiCallGeneralMock);
//        stub(apiFactory).method("getCall").args("LevelContent", false).returns(apiCallLevelContentMock);
//
//        _saltr = new SLTSaltrWeb(FlexUnitRunner.STAGE, clientKey, socialId);
//        _saltr.apiFactory = apiFactory;
//        _saltr.importLevelsFromJSON(new LevelPacksJson());
//        setSaltrWeb(_saltr);
//    }
//
//    [After]
//    public function tearDown():void {
//        clearSaltr();
//        _saltr = null;
//    }
//
//    /**
//     * allLevelsTest.
//     * The intent of this test is to check the levels importing.
//     */
//    [Test]
//    public function allLevelsTest():void {
//        assertEquals(true, allLevelsTestPassed());
//    }
//
//    /**
//     * defineFeatureTest.
//     * The intent of this test is to check the define feature.
//     */
//    [Test]
//    public function defineFeatureTest():void {
//        assertEquals(true, defineFeatureTestPassed());
//    }
//
//    /**
//     * getLevelByGlobalIndexWithValidIndex
//     * The intent of this test is to get the SLTLevel by valid global index.
//     */
//    [Test]
//    public function getLevelByGlobalIndexWithValidIndex():void {
//        assertEquals(true, getLevelByGlobalIndexWithValidIndexTestPassed());
//    }
//
//    /**
//     * getLevelByGlobalIndexWithInvalidIndex
//     * The intent of this test is to pass incorrect index and get null as a result
//     */
//    [Test]
//    public function getLevelByGlobalIndexWithInvalidIndex():void {
//        assertEquals(true, getLevelByGlobalIndexWithInvalidIndexPassed());
//    }
//
//    /**
//     * getPackByLevelGlobalIndexWithValidIndex
//     * The intent of this test is to get the SLTLevelPack by valid global index.
//     */
//    [Test]
//    public function getPackByLevelGlobalIndexWithValidIndex():void {
//        assertEquals(true, getPackByLevelGlobalIndexWithValidIndexPassed());
//    }
//
//    /**
//     * getPackByLevelGlobalIndexWithInvalidIndex
//     * The intent of this test is to pass incorrect index and get null as a result
//     */
//    [Test]
//    public function getPackByLevelGlobalIndexWithInvalidIndex():void {
//        assertEquals(true, getPackByLevelGlobalIndexWithInvalidIndexPassed());
//    }
//
//    /**
//     * loadLevelContentTest
//     * The intent of this test is to check loadLevelContent.
//     */
//    [Test]
//    public function loadLevelContentTest():void {
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
//        _saltr.loadLevelContent(level, loadLevelContentSuccessCallback, loadLevelContentFailCallback);
//        var testPassed:Boolean = true;
//        if (false == levelLoaded || false == level.contentReady || "default" != level.getBoard("main").layers[0].token || "saltr" != level.properties.levelDataFrom) {
//            testPassed = false;
//        }
//        assertEquals(true, testPassed);
//    }
//
//    private function prepareLoadLevelContentConnected():void {
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
//        _saltr.defineFeature("SETTINGS", {
//            general: {
//                lifeRefillTime: 30
//            }
//        }, true);
//        _saltr.start();
//        _saltr.connect(connectSuccessCallback, connectFailCallback);
//    }
//}
//}
