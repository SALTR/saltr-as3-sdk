/**
 * Created by TIGR on 7/9/2015.
 */
package tests.saltr.game.matching {
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;

import saltr.game.SLTCheckpoint;
import saltr.game.SLTLevel;
import saltr.game.matching.SLTMatchingBoard;

/**
 * The SLTMatchingBoardTest class contain the SLTMatchingBoard method tests.
 */
public class SLTMatchingBoardTest {
    [Embed(source="../../../../../build/tests/saltr/slt_matching_board_test/level_0.json", mimeType="application/octet-stream")]
    private static const LevelDataJson:Class;

    private var _level:SLTLevel;

    public function SLTMatchingBoardTest() {
    }

    [Before]
    public function tearUp():void {
        _level = new SLTLevel(225045, 246970, 0, "pack_0/level_0.json", "44", SLTLevel.LEVEL_TYPE_MATCHING);
    }

    [After]
    public function tearDown():void {
        _level = null;
    }

    /**
     * checkpointTest.
     * The intent of this test is to check the updateContent method.
     * Correct input data provided. ContentReady expected.
     */
    [Test]
    public function checkpointTest():void {
        var checkpoint:SLTCheckpoint;
        if (false == _level.contentReady) {
            _level.updateContent(JSON.parse(new LevelDataJson()));
            if (true == _level.contentReady) {
                var board:SLTMatchingBoard = _level.getBoard("main") as SLTMatchingBoard;
                checkpoint = board.getCheckpoint("checkpoint_1");

            }
        }
        assertNotNull(checkpoint);
        assertEquals(SLTCheckpoint.CHECKPOINT_ORIENTATION_VERTICAL, checkpoint.orientation);
        assertEquals(8, checkpoint.position);
    }
}
}
