/**
 * Created by TIGR on 7/22/2015.
 */
package tests.saltr.utils.level.updater {
import flash.events.Event;
import flash.utils.Dictionary;

import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.async.Async;

import saltr.SLTConfig;
import saltr.SLTDeserializer;
import saltr.api.call.SLTApiCallFactory;
import saltr.game.SLTLevel;
import saltr.repository.SLTMobileRepository;
import saltr.repository.SLTRepositoryStorageManager;
import saltr.saltr_internal;
import saltr.utils.level.updater.SLTMobileLevelsFeaturesUpdater;

use namespace saltr_internal;

public class SLTMobileLevelsFeaturesUpdaterTest {
    [Embed(source="../../../../../../build/tests/saltr/slt_utils_level_updater_test/app_data_cache_3_levels.json", mimeType="application/octet-stream")]
    private static const AppData3LevelsJson:Class;
    [Embed(source="../../../../../../build/tests/saltr/slt_utils_level_updater_test/app_data_cache_5_levels.json", mimeType="application/octet-stream")]
    private static const AppData5LevelsJson:Class;
    [Embed(source="../../../../../../build/tests/saltr/level_0_chached.json", mimeType="application/octet-stream")]
    private static const LevelDataCachedJson:Class;

    private var _featuresUpdater:SLTMobileLevelsFeaturesUpdater;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var mobileRepository:SLTMobileRepository;
    [Mock(type="nice")]
    public var apiFactory:SLTApiCallFactory;
    [Mock(type="nice")]
    public var apiCallLevelContentMock:ApiCallMock;

    public function SLTMobileLevelsFeaturesUpdaterTest() {
    }

    [Before]
    public function tearUp():void {
        stub(mobileRepository).method("cacheObject").calls(function ():void {
            trace("cacheObject");
        });
        stub(mobileRepository).method("getObjectFromCache").returns(null);

        stub(apiCallLevelContentMock).method("getMockSuccess").returns(true);
        stub(apiCallLevelContentMock).method("getMockSuccessData").returns(JSON.parse(new LevelDataCachedJson()));

        stub(apiFactory).method("getCall").args("LevelContent", true).returns(apiCallLevelContentMock);

        _featuresUpdater = new SLTMobileLevelsFeaturesUpdater(new SLTRepositoryStorageManager(mobileRepository), apiFactory, 0);
    }

    [After]
    public function tearDown():void {
        _featuresUpdater = null;
    }

    /**
     * updateCompleteTest.
     * The intent of this test is to check the update function.
     */
    [Test(async, timeout=10000)]
    public function updateCompleteTest():void {
        var gameLevelsFeatures:Dictionary = SLTDeserializer.decodeFeatures(JSON.parse(new AppData5LevelsJson()), SLTConfig.FEATURE_TYPE_LEVEL_COLLECTION);
        Async.proceedOnEvent(this, _featuresUpdater, Event.COMPLETE, 5000);
        _featuresUpdater.update(gameLevelsFeatures);
    }

    /**
     * updateCancelUpdateTest.
     * The intent of this test is to check the update function.
     * At first the game levels group with 5 levels provided. At the next step the smaller group of levels provided (number of levels 3).
     * Expect behaviour is cancel updating of thirst provided group and updating the new group provided.
     */
    [Test(async, timeout=1000)]
    public function updateCancelUpdateTest():void {
        var gameLevelsFeatures5Levels:Dictionary = SLTDeserializer.decodeFeatures(JSON.parse(new AppData5LevelsJson()), SLTConfig.FEATURE_TYPE_LEVEL_COLLECTION);
        var gameLevelsFeatures3Levels:Dictionary = SLTDeserializer.decodeFeatures(JSON.parse(new AppData3LevelsJson()), SLTConfig.FEATURE_TYPE_LEVEL_COLLECTION);
        Async.proceedOnEvent(this, _featuresUpdater, Event.COMPLETE, 500);
        _featuresUpdater.update(gameLevelsFeatures5Levels);
        _featuresUpdater.update(gameLevelsFeatures3Levels);
    }

    /**
     * updateCancelUpdateTest.
     * The intent of this test is to check the update function.
     * At first the game levels group with 5 levels provided. At the next step the single level is provided for update.
     * Expect behaviour is cancel updating of thirst provided group and updating the new level provided.
     */
    [Test(async, timeout=1000)]
    public function updateCancelUpdateLevelTest():void {
        var gameLevelsFeatures5Levels:Dictionary = SLTDeserializer.decodeFeatures(JSON.parse(new AppData5LevelsJson()), SLTConfig.FEATURE_TYPE_LEVEL_COLLECTION);
        Async.proceedOnEvent(this, _featuresUpdater, Event.COMPLETE, 500);
        _featuresUpdater.update(gameLevelsFeatures5Levels);
        var level:SLTLevel = new SLTLevel(225045, 246970, 0, "pack_0/level_0.json", "44");
        _featuresUpdater.updateLevel("GAME_LEVELS", level);
    }
}
}
