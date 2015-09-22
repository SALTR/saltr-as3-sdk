/**
 * Created by TIGR on 4/30/2015.
 */
package tests.saltr {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.SLTSaltrMobile;
import saltr.game.SLTBoard;
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

    private var clientKey:String = "";
    private var deviceId:String = "";
    private var _saltr:SLTSaltrMobile;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var mobileRepository:SLTMobileRepository;

    public function SLTInitLevelContentMobileTest() {
    }

    [Before]
    public function tearUp():void {
        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
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

        var level:SLTLevel = new SLTLevel(225045, 246970, 0, "pack_0/level_0.json", "44");

        var testPassed:Boolean = false;
        if (false == level.contentReady) {
            var initResult:Boolean = _saltr.initLevelContentLocally(SLTSaltrTest.GAME_LEVELS_FEATURE, level);
            if (true == initResult && true == level.contentReady && "default" == level.getBoard(SLTBoard.BOARD_TYPE_MATCHING, "main").layers["default"].token && "cached" == level.properties["levelProperty1"]["levelDataFrom"]) {
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

        var level:SLTLevel = new SLTLevel(225045, 246970, 0, "pack_0/level_0.json", "44");

        var testPassed:Boolean = false;
        if (false == level.contentReady) {
            var initResult:Boolean = _saltr.initLevelContentLocally(SLTSaltrTest.GAME_LEVELS_FEATURE, level);
            if (true == initResult && true == level.contentReady && "default" == level.getBoard(SLTBoard.BOARD_TYPE_MATCHING, "main").layers["default"].token && "application" == level.properties["levelProperty1"]["levelDataFrom"]) {
                testPassed = true;
            }
        }
        assertEquals(true, testPassed);
    }
}
}
