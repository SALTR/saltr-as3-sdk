/**
 * Created by TIGR on 4/30/2015.
 */
package tests.saltr {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;

import saltr.SLTSaltrMobile;
import saltr.api.call.SLTApiCallFactory;
import saltr.game.SLTLevel;
import saltr.repository.SLTMobileRepository;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTLoadLevelContentTest class contain the tests which can be performed with saltr.loadLevelContent()
 */
public class SLTInitLevelContentMobileTest {
    [Embed(source="../../../build/tests/saltr/level_0_chached.json", mimeType="application/octet-stream")]
    private static const LevelDataCachedJson:Class;
    [Embed(source="../../../build/tests/saltr/level_0_from_application.json", mimeType="application/octet-stream")]
    private static const LevelDataFromApplicationJson:Class;

    [Embed(source="../../../build/tests/saltr/slt_init_level_content_test/app_data_initial.json", mimeType="application/octet-stream")]
    private static const AppDataInitialJson:Class;
    [Embed(source="../../../build/tests/saltr/slt_init_level_content_test/app_data_new.json", mimeType="application/octet-stream")]
    private static const AppDataNewJson:Class;

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
    public var apiCallAppDataMock:ApiCallMock;
    [Mock(type="nice")]
    public var apiCallLevelContentMock:ApiCallMock;
    [Mock(type="nice")]
    public var apiCallSyncMock:ApiCallMock;

    public function SLTInitLevelContentMobileTest() {
    }

    [Before]
    public function tearUp():void {
        stub(apiFactory).method("getCall").args("AppData", true).returns(apiCallAppDataMock);
        stub(apiFactory).method("getCall").args("LevelContent", true).returns(apiCallLevelContentMock);
        stub(apiFactory).method("getCall").args("Sync", true).returns(apiCallSyncMock);

        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.apiFactory = apiFactory;
        _saltr.repository = mobileRepository;

        _saltr.defineGenericFeature("SETTINGS", {
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
     * initLevelContentLocallyTestFromCache.
     * The intent of this test is to check the initLevelContentLocally function.
     * Not connected state. Cached data expected.
     */
    [Test]
    public function initLevelContentLocallyTestFromCache():void {
        stub(mobileRepository).method("cacheObject").calls(function ():void {
            trace("cacheObject");
        });
        stub(mobileRepository).method("getObjectFromCache").returns(JSON.parse(new LevelDataCachedJson()));
        stub(mobileRepository).method("getObjectFromApplication").returns(JSON.parse(new LevelDataFromApplicationJson()));

        var level:SLTLevel = new SLTLevel(225045, 246970, 0, "pack_0/level_0.json", "44", SLTLevel.LEVEL_TYPE_MATCHING);

        var testPassed:Boolean = false;
        if (false == level.contentReady) {
            var initResult:Boolean = _saltr.initLevelContentLocally(SLTSaltrTest.GAME_LEVELS_FEATURE, level);
            if (true == initResult && true == level.contentReady && "default" == level.getBoard("main").layers[0].token && "cached" == level.properties.levelDataFrom) {
                testPassed = true;
            }
        }
        assertEquals(true, testPassed);
    }

    /**
     * initLevelContentLocallyTestFromApplication.
     * The intent of this test is to check the initLevelContentLocally function.
     * Not connected state. Data from application expected.
     */
    [Test]
    public function initLevelContentLocallyTestFromApplication():void {
        stub(mobileRepository).method("cacheObject").calls(function ():void {
            trace("cacheObject");
        });
        stub(mobileRepository).method("getObjectFromCache").returns(null);
        stub(mobileRepository).method("getObjectFromApplication").returns(JSON.parse(new LevelDataFromApplicationJson()));

        var level:SLTLevel = new SLTLevel(225045, 246970, 0, "pack_0/level_0.json", "44", SLTLevel.LEVEL_TYPE_MATCHING);

        var testPassed:Boolean = false;
        if (false == level.contentReady) {
            var initResult:Boolean = _saltr.initLevelContentLocally(SLTSaltrTest.GAME_LEVELS_FEATURE, level);
            if (true == initResult && true == level.contentReady && "default" == level.getBoard("main").layers[0].token && "application" == level.properties.levelDataFrom) {
                testPassed = true;
            }
        }
        assertEquals(true, testPassed);
    }

    /**
     * initLevelContentFromSaltrTestFromSaltr.
     * The intent of this test is to check the initLevelContentFromSaltr function.
     * Data from Saltr expected.
     */
    [Test]
    public function initLevelContentFromSaltrTestFromSaltr():void {
        _saltr.start();

        stub(apiCallSyncMock).method("getMockSuccess").returns(true);
        stub(apiCallSyncMock).method("getMockSuccessData").returns(new Object());

        stub(apiCallAppDataMock).method("getMockSuccess").returns(true);
        stub(apiCallAppDataMock).method("getMockSuccessData").returns(JSON.parse(new AppDataInitialJson()));

        var isConnected:Boolean = false;
        var failCallback:Function;
        var successCallback:Function = function ():void {
            isConnected = true;
        };
        _saltr.devMode = true;
        _saltr.connect(successCallback, failCallback);

        stub(apiCallAppDataMock).method("getMockSuccess").returns(true);
        stub(apiCallAppDataMock).method("getMockSuccessData").returns(JSON.parse(new AppDataNewJson()));

        stub(apiCallLevelContentMock).method("getParamsFieldName").returns("contentUrl");
        stub(apiCallLevelContentMock).method("getMockSuccess").returns(true);
        var contentUrl:String = "https://api.saltr.com/static_data/402e3c45-f934-535f-ae1a-6be2a90b4d2e/levels/310068_583.json";
        stub(apiCallLevelContentMock).method("getMockSuccessData").args(contentUrl).returns(JSON.parse(new LevelDataCachedJson()));
        stub(apiCallLevelContentMock).method("getMockSuccessData").returns(null);

        stub(mobileRepository).method("cacheObject").calls(function ():void {
            trace("cacheObject");
        });
        stub(mobileRepository).method("getObjectFromCache").returns(JSON.parse(new LevelDataCachedJson()));

        var level:SLTLevel = _saltr.getGameLevelFeatureProperties("GAME_LEVELS").getLevelByGlobalIndex(0);

        var testPassed:Boolean = false;
        var initLevelCallback:Function = function (success:Boolean):void {
            if (true == success && true == level.contentReady && "default" == level.getBoard("main").layers[0].token && "cached" == level.properties.levelDataFrom) {
                testPassed = true;
            }
        };
        _saltr.initLevelContentFromSaltr("GAME_LEVELS", level, initLevelCallback);
        assertEquals(testPassed, true);
    }
}
}
