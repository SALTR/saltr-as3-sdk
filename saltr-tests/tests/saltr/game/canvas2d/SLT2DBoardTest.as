/**
 * Created by TIGR on 7/9/2015.
 */
package tests.saltr.game.canvas2d {
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;

import saltr.game.SLTBoard;

import saltr.game.SLTCheckpoint;
import saltr.game.SLTLevel;
import saltr.game.canvas2d.SLT2DBoard;

public class SLT2DBoardTest {
    [Embed(source="../../../../../build/tests/saltr/slt_2d_board_test/level_0.json", mimeType="application/octet-stream")]
    private static const LevelDataJson:Class;

    private var _level:SLTLevel;

    public function SLT2DBoardTest() {
    }

    [Before]
    public function tearUp():void {
        _level = new SLTLevel(225045, 246970, 0, "pack_0/level_0.json", "","","44");
    }

    [After]
    public function tearDown():void {
        _level = null;
    }

    /**
     * checkpointTest.
     * The intent of this test is to check the getCheckpoint method.
     */
    [Test]
    public function checkpointTest():void {
        var checkpoint:SLTCheckpoint;
        if (false == _level.contentReady) {
            _level.updateContent(JSON.parse(new LevelDataJson()));
            if (true == _level.contentReady) {
                var board:SLT2DBoard = _level.getBoard(SLTBoard.BOARD_TYPE_CANVAS_2D, "Board") as SLT2DBoard;
                checkpoint = board.getCheckpoint("token_1");

            }
        }
        assertNotNull(checkpoint);
        assertEquals(SLTCheckpoint.CHECKPOINT_ORIENTATION_HORIZONTAL, checkpoint.orientation);
        assertEquals(215, checkpoint.position);
    }

    /**
     * checkpointsTest.
     * The intent of this test is to check the getCheckpoints method.
     */
    [Test]
    public function checkpointsTest():void {
        var checkpoints:Vector.<SLTCheckpoint>;
        if (false == _level.contentReady) {
            _level.updateContent(JSON.parse(new LevelDataJson()));
            if (true == _level.contentReady) {
                var board:SLT2DBoard = _level.getBoard(SLTBoard.BOARD_TYPE_CANVAS_2D, "Board") as SLT2DBoard;
                checkpoints = board.getCheckpoints();

            }
        }
        assertEquals(1, checkpoints.length);
        assertEquals(215, checkpoints[0].position);
    }
}
}
