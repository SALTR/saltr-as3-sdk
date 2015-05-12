/**
 * Created by TIGR on 5/12/2015.
 */
package tests.saltr {
import org.flexunit.asserts.assertEquals;

import saltr.SLTSaltrWeb;

/**
 * The SLTSaltrWebTest class contain the tests which can be performed without saltr.connect()
 */
public class SLTSaltrWebTest extends SLTSaltrTest {
    [Embed(source="../../../build/tests/saltr/level_packs.json", mimeType="application/octet-stream")]
    private static const LevelPacksJson:Class;

    private var clientKey:String = "";
    private var socialId:String = "";
    private var _saltr:SLTSaltrWeb;

    public function SLTSaltrWebTest() {
    }

    [Before]
    public function tearUp():void {
        _saltr = new SLTSaltrWeb(FlexUnitRunner.STAGE, clientKey, socialId);
        _saltr.importLevelsFromJSON(new LevelPacksJson());
        setSaltrWeb(_saltr);
    }

    [After]
    public function tearDown():void {
        clearSaltr();
        _saltr = null;
    }

    /**
     * allLevelsTest.
     * The intent of this test is to check the levels importing.
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
    public function defineFeatureTest():void {
        assertEquals(true, defineFeatureTestPassed());
    }

    /**
     * getLevelByGlobalIndexWithValidIndex
     * The intent of this test is to get the SLTLevel by valid global index.
     */
    [Test]
    public function getLevelByGlobalIndexWithValidIndex():void {
        assertEquals(true, getLevelByGlobalIndexWithValidIndexTestPassed());
    }

    /**
     * getLevelByGlobalIndexWithInvalidIndex
     * The intent of this test is to pass incorrect index and get null as a result
     */
    [Test]
    public function getLevelByGlobalIndexWithInvalidIndex():void {
        assertEquals(true, getLevelByGlobalIndexWithInvalidIndexPassed());
    }

    /**
     * getPackByLevelGlobalIndexWithValidIndex
     * The intent of this test is to get the SLTLevelPack by valid global index.
     */
    [Test]
    public function getPackByLevelGlobalIndexWithValidIndex():void {
        assertEquals(true, getPackByLevelGlobalIndexWithValidIndexPassed());
    }

    /**
     * getPackByLevelGlobalIndexWithInvalidIndex
     * The intent of this test is to pass incorrect index and get null as a result
     */
    [Test]
    public function getPackByLevelGlobalIndexWithInvalidIndex():void {
        assertEquals(true, getPackByLevelGlobalIndexWithInvalidIndexPassed());
    }
}
}
