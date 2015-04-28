/**
 * Created by TIGR on 4/10/2015.
 */
package tests.saltr {
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

        //importLevels() takes as input levels path, in this test it is just a dummy value because of MobileRepository's mocking
        _saltr.importLevels("");
    }

    [After]
    public function tearDown():void {
        _saltr = null;
    }

    /**
     * allLevelsTest.
     * The intent of this test is to check the levels importing.
     * Mobile repository's getObjectFromApplication() mocked in order to provide levels data
     */
    [Test]
    public function allLevelsTest():void {

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
     * getLevelByGlobalIndexWithValidIndex
     * The intent of this test is to get the SLTLevel by valid global index.
     */
    [Test]
    public function getLevelByGlobalIndexWithValidIndex():void {
        var level:SLTLevel = _saltr.getLevelByGlobalIndex(20);
        assertEquals(5, level.localIndex);
    }

    /**
     * getLevelByGlobalIndexWithInvalidIndex
     * The intent of this test is to pass incorrect index and get null as a result
     */
    [Test]
    public function getLevelByGlobalIndexWithInvalidIndex():void {
        var level:SLTLevel = _saltr.getLevelByGlobalIndex(-1);
        assertNull(level);
    }

    /**
     * getPackByLevelGlobalIndexWithValidIndex
     * The intent of this test is to get the SLTLevelPack by valid global index.
     */
    [Test]
    public function getPackByLevelGlobalIndexWithValidIndex():void {
        var levelPack:SLTLevelPack = _saltr.getPackByLevelGlobalIndex(20);
        assertEquals(1, levelPack.index);
    }

    /**
     * getPackByLevelGlobalIndexWithInvalidIndex
     * The intent of this test is to pass incorrect index and get null as a result
     */
    [Test]
    public function getPackByLevelGlobalIndexWithInvalidIndex():void {
        var levelPack:SLTLevelPack = _saltr.getPackByLevelGlobalIndex(-1);
        assertNull(levelPack);
    }

    private function getJson(stringData:String):Object {
        return JSON.parse(stringData);
    }
}
}
