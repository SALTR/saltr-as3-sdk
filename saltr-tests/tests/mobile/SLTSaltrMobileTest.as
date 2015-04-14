/**
 * Created by TIGR on 4/10/2015.
 */
package tests.mobile {
import flash.filesystem.FileStream;

import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNull;

import saltr.SLTSaltrMobile;
import saltr.game.SLTLevel;
import saltr.game.SLTLevelPack;
import saltr.repository.SLTMobileRepository;

/**
 * The SLTSaltrMobileTest class contain the tests which can be performed without saltr.connect()
 */
public class SLTSaltrMobileTest {
    [Embed(source="../../../build/tests/saltr/level_packs.json", mimeType="application/octet-stream")]
    private static const AppDataJson:Class;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var mobileRepository:SLTMobileRepository;

    private var clientKey:String = "";
    private var deviceId:String = "";
    private var _saltr:SLTSaltrMobile;

    public function SLTSaltrMobileTest() {
    }

    [Before]
    public function tearUp():void {
        stub(mobileRepository).method("getObjectFromApplication").returns(getJson(new AppDataJson()));
        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.repository = mobileRepository;
    }

    [After]
    public function tearDown():void {
        _saltr = null;
    }

    /**
     * importLevelsTest.
     * The intent of this test is to check the levels importing.
     * Mobile repository's getObjectFromApplication() mocked in order to provide levels data
     */
    [Test]
    public function importLevelsTest():void {
        //importLevels() takes as input levels path, in this test it is just a dummy value because of MobileRepository's mocking
        _saltr.importLevels("Levels Path");
        assertEquals(75, _saltr.allLevelsCount);
    }

    /**
     * defineFeatureTest.
     * The intent of this test is to check the define feature.
     */
    [Test]
    public function defineFeatureTest():void {
        _saltr.defineFeature("SETTINGS", {
            general: {
                lifeRefillTime: 30
            }
        }, true);

        _saltr.getFeatureProperties("SETTINGS");
        assertEquals(30, _saltr.getFeatureProperties("SETTINGS").general.lifeRefillTime);
    }

    /**
     * getLevelByGlobalIndex_A
     * The intent of this test is to get the SLTLevel by valid global index.
     */
    [Test]
    public function getLevelByGlobalIndex_A():void {
        _saltr.importLevels("Levels Path");
        var level:SLTLevel = _saltr.getLevelByGlobalIndex(20);
        assertEquals(5, level.localIndex);
    }

    /**
     * getLevelByGlobalIndex_B
     * The intent of this test is to pass incorrect index and get null as a result
     */
    [Test]
    public function getLevelByGlobalIndex_B():void {
        _saltr.importLevels("Levels Path");
        var level:SLTLevel = _saltr.getLevelByGlobalIndex(-1);
        assertNull(level);
    }

    /**
     * getPackByLevelGlobalIndex_A
     * The intent of this test is to get the SLTLevelPack by valid global index.
     */
    [Test]
    public function getPackByLevelGlobalIndex_A():void {
        _saltr.importLevels("Levels Path");
        var levelPack:SLTLevelPack = _saltr.getPackByLevelGlobalIndex(20)
        assertEquals(1, levelPack.index);
    }

    /**
     * getPackByLevelGlobalIndex_B
     * The intent of this test is to pass incorrect index and get null as a result
     */
    [Test]
    public function getPackByLevelGlobalIndex_B():void {
        _saltr.importLevels("Levels Path");
        var levelPack:SLTLevelPack = _saltr.getPackByLevelGlobalIndex(-1);
        assertNull(levelPack);
    }

    private function getJson(stringData:String):Object {
        return JSON.parse(stringData);
    }
}
}
