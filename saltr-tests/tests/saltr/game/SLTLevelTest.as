/**
 * Created by TIGR on 5/4/2015.
 */
package tests.saltr.game {
import org.flexunit.asserts.assertEquals;

import saltr.game.SLTLevel;

/**
 * The SLTLevelTest class contain the SLTLevel method tests
 */
public class SLTLevelTest {
    [Embed(source="../../../../build/tests/saltr/slt_level_test/level_0_correct.json", mimeType="application/octet-stream")]
    private static const CorrectLevelDataJson:Class;

    [Embed(source="../../../../build/tests/saltr/slt_level_test/level_0_missing_assets.json", mimeType="application/octet-stream")]
    private static const MissingAssetsLevelDataJson:Class;

    [Embed(source="../../../../build/tests/saltr/slt_level_test/level_0_missing_boards.json", mimeType="application/octet-stream")]
    private static const MissingBoardsLevelDataJson:Class;

    private var _level:SLTLevel;

    public function SLTLevelTest() {
    }

    [Before]
    public function tearUp():void {
        _level = new SLTLevel(225045, 246970, 0, "pack_0/level_0.json","","", "44");
    }

    [After]
    public function tearDown():void {
        _level = null;
    }

    /**
     * updateContentCorrectTest.
     * The intent of this test is to check the updateContent method.
     * Correct input data provided. ContentReady expected.
     */
    [Test]
    public function updateContentCorrectTest():void {
        var testPassed:Boolean = false;
        if (false == _level.contentReady) {
            _level.updateContent(JSON.parse(new CorrectLevelDataJson()));
            if (true == _level.contentReady) {
                testPassed = true;
            }
        }
        assertEquals(true, testPassed);
    }

    /**
     * updateContentMissingAssetsTest.
     * The intent of this test is to check the updateContent method.
     * Assets data missing in provided input data. Error should be thrown.
     */
    [Test(expects="Error")]
    public function updateContentMissingAssetsTest():void {
        _level.updateContent(JSON.parse(new MissingAssetsLevelDataJson()));
    }

    /**
     * updateContentMissingBoardsTest.
     * The intent of this test is to check the updateContent method.
     * Boards data missing in provided input data. Error should be thrown.
     */
    [Test(expects="Error")]
    public function updateContentMissingBoardsTest():void {
        _level.updateContent(JSON.parse(new MissingBoardsLevelDataJson()));
    }
}
}
