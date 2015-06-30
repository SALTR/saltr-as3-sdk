/**
* Created by TIGR on 4/18/2015.
*/
package tests.saltr {
import org.flexunit.asserts.assertEquals;

import saltr.SLTLevelData;

/**
* The LevelDataTest class contain the LevelData method tests.
*/
public class SLTLevelDataTest {
    [Embed(source="../../../build/tests/saltr/level_data.json", mimeType="application/octet-stream")]
    private static const LevelDataJson:Class;

    [Embed(source="../../../build/tests/saltr/level_data_15_levels.json", mimeType="application/octet-stream")]
    private static const LevelData15LevelsJson:Class;

    private var _levelData:SLTLevelData;

    public function SLTLevelDataTest() {
    }

    [Before]
    public function tearUp():void {
        _levelData = new SLTLevelData();
    }

    [After]
    public function tearDown():void {
        _levelData = null;
    }

    /**
     * initWithCorrectDataTest.
     * The intent of this test is to check the initWithData method with correct data passing.
     */
    [Test]
    public function initWithCorrectDataTest():void {
        _levelData.initWithData(JSON.parse(new LevelDataJson()));
        assertEquals(75, _levelData.allLevelsCount);
    }

    /**
     * multipleInitWithCorrectDataTest.
     * The intent of this test is to check the multiple call result of the initWithData method with correct data passing.
     */
    [Test]
    public function multipleInitWithCorrectDataTest():void {
        _levelData.initWithData(JSON.parse(new LevelDataJson()));

        var testPassed:Boolean = false;
        if (75 == _levelData.allLevelsCount) {
            _levelData.initWithData(JSON.parse(new LevelData15LevelsJson()));
            if (15 == _levelData.allLevelsCount) {
                testPassed = true;
            }
        }
        assertEquals(true, testPassed);
    }

    /**
     * initWithNullDataTest.
     * The intent of this test is to check the initWithData method with null passing as data.
     */
    [Test(expects="Error")]
    public function initWithNullDataTest():void {
        _levelData.initWithData(null);
    }

    /**
     * initWithMissingLevelsNodeDataTest.
     * The intent of this test is to check the initWithData method with missing levels node in data passed.
     */
    [Test(expects="Error")]
    public function initWithMissingLevelsNodeDataTest():void {
        _levelData.initWithData({
            "levelType": "matching",
            "levelPacks": [
                {
                    "index": 0,
                    "token": "STAGE_1"
                }
            ]
        });
    }

    /**
     * allLevelsCountTest.
     * The intent of this test is to check the allLevelsCount.
     */
    [Test]
    public function allLevelsCountTest():void {
        _levelData.initWithData(JSON.parse(new LevelDataJson()));
        assertEquals(75, _levelData.allLevelsCount);
    }

    /**
     * getLevelByCorrectGlobalIndexTest.
     * The intent of this test is to check the getLevelByGlobalIndex.
     */
    [Test]
    public function getLevelByCorrectGlobalIndexTest():void {
        _levelData.initWithData(JSON.parse(new LevelDataJson()));
        assertEquals(25, _levelData.getLevelByGlobalIndex(25).globalIndex);
    }

    /**
     * getLevelWithNegativeIndexTest.
     * The intent of this test is to check the getLevelByGlobalIndex with passing negative index value. Null result value expected.
     */
    [Test]
    public function getLevelWithNegativeIndexTest():void {
        _levelData.initWithData(JSON.parse(new LevelDataJson()));
        assertEquals(null, _levelData.getLevelByGlobalIndex(-100));
    }

    /**
     * getLevelWithNotExistingIndexTest.
     * The intent of this test is to check the getLevelByGlobalIndex with passing not existing index value. Null result value expected.
     */
    [Test]
    public function getLevelWithNotExistingIndexTest():void {
        _levelData.initWithData(JSON.parse(new LevelDataJson()));
        assertEquals(null, _levelData.getLevelByGlobalIndex(1000000));
    }
}
}
