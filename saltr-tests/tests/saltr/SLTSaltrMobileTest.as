/**
 * Created by TIGR on 4/10/2015.
 */
package tests.saltr {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.SLTSaltrMobile;
import saltr.repository.SLTMobileRepository;
import saltr.repository.SLTRepositoryStorageManager;

/**
 * The SLTSaltrMobileTest class contain the tests which can be performed without saltr.connect()
 */
public class SLTSaltrMobileTest extends SLTSaltrTest {
    [Embed(source="../../../build/tests/saltr/level_data.json", mimeType="application/octet-stream")]
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
        _saltr.repositoryStorageManager = new SLTRepositoryStorageManager(mobileRepository);

        //defineGameLevels("GAME_LEVELS") in this test it is just a dummy value because of MobileRepository's mocking
        _saltr.defineGameLevels("GAME_LEVELS");
        setSaltrMobile(_saltr);
    }

    [After]
    public function tearDown():void {
        clearSaltr();
        _saltr = null;
    }

    /**
     * allLevelsTest.
     * The intent of this test is to check the levels importing.
     * Mobile repository's getObjectFromApplication() mocked in order to provide levels data
     */
    [Test]
    public function allLevelsTest():void {
        assertEquals(true, allLevelsTestPassed());
    }

    /**
     * defineFeatureTest.
     * The intent of this test is to check the define feature.
     */
    [Test]
//    public function defineFeatureTest():void {
//        assertEquals(true, defineFeatureTestPassed());
//    }

    /**
     * getLevelByGlobalIndexWithValidIndex
     * The intent of this test is to get the SLTLevel by valid global index.
     */
    [Test]
//    public function getLevelByGlobalIndexWithValidIndex():void {
//        assertEquals(true, getLevelByGlobalIndexWithValidIndexTestPassed());
//    }

    /**
     * getLevelByGlobalIndexWithInvalidIndex
     * The intent of this test is to pass incorrect index and get null as a result
     */
    [Test]
//    public function getLevelByGlobalIndexWithInvalidIndex():void {
//        assertEquals(true, getLevelByGlobalIndexWithInvalidIndexPassed());
//    }

    /**
     * getPackByLevelGlobalIndexWithValidIndex
     * The intent of this test is to get the SLTLevelPack by valid global index.
     */
    [Test]
//    public function getPackByLevelGlobalIndexWithValidIndex():void {
//        assertEquals(true, getPackByLevelGlobalIndexWithValidIndexPassed());
//    }

    /**
     * getPackByLevelGlobalIndexWithInvalidIndex
     * The intent of this test is to pass incorrect index and get null as a result
     */
    [Test]
//    public function getPackByLevelGlobalIndexWithInvalidIndex():void {
//        assertEquals(true, getPackByLevelGlobalIndexWithInvalidIndexPassed());
//    }

    private function getJson(stringData:String):Object {
        return JSON.parse(stringData);
    }
}
}
