/**
 * Created by TIGR on 5/28/2015.
 */
package tests.saltr.game.canvas2d {
import flash.geom.Point;

import org.flexunit.asserts.assertEquals;

import saltr.game.SLTAssetState;
import saltr.game.SLTLevel;
import saltr.game.canvas2d.SLT2DAssetInstance;
import saltr.game.canvas2d.SLT2DAssetState;
import saltr.game.canvas2d.SLT2DBoard;

/**
 * The SLT2DAssetInstanceTest class contain the SLT2DAssetInstance method tests
 */
public class SLT2DAssetInstanceTest {
    [Embed(source="../../../../../build/tests/saltr/slt_2d_asset_instance_test/scale_test_level.json", mimeType="application/octet-stream")]
    private static const ScaleTestLevelDataJson:Class;
    [Embed(source="../../../../../build/tests/saltr/slt_2d_asset_instance_test/positions_test_level.json", mimeType="application/octet-stream")]
    private static const PositionTestLevelDataJson:Class;

    private static const STATE_0_WIDTH:Number = 1.0 * 199.0;
    private static const STATE_0_HEIGHT:Number = 1.286 * 199.0;
    private static const STATE_1_WIDTH:Number = 1.528 * 199.0;
    private static const STATE_1_HEIGHT:Number = 1.0 * 199.0;

    private var _level:SLTLevel;

    public function SLT2DAssetInstanceTest() {
    }

    [Before]
    public function tearUp():void {
        var levelProperties:Object = {
            "movesCount": "18"
        };
        _level = new SLTLevel("225045", "246970", "canvas2D", 0, 0, 0, "pack_0/level_0.json", levelProperties, "44");
    }

    [After]
    public function tearDown():void {
        _level = null;
    }

    /**
     * assetStateWidthHeightTest
     * The intent of this test is to check the SLT2DAssetState width / height, which are SLT2DInstance's scale factor depended values.
     */
    [Test]
    public function assetStateWidthHeightTest():void {
        var testPassed:Boolean = false;
        if (false == _level.contentReady) {
            _level.updateContent(JSON.parse(new ScaleTestLevelDataJson()));
            if (true == _level.contentReady) {
                var board:SLT2DBoard = _level.getBoard("UNTITLED_1") as SLT2DBoard;
                var assetInstances:Vector.<SLT2DAssetInstance> = board.getAssetInstancesByLayerId("default");
                var states_0:Vector.<SLTAssetState> = assetInstances[0].states;
                var states_1:Vector.<SLTAssetState> = assetInstances[1].states;
                var state_0:SLT2DAssetState = states_0[0] as SLT2DAssetState;
                var state_1:SLT2DAssetState = states_1[0] as SLT2DAssetState;
                if (STATE_0_WIDTH == state_0.width && STATE_0_HEIGHT == state_0.height && STATE_1_WIDTH == state_1.width && STATE_1_HEIGHT == state_1.height) {
                    testPassed = true;
                }
            }
        }
        assertEquals(true, testPassed);
    }

    /**
     * assetInstancePositionsTest
     * The intent of this test is to check the SLT2DAssetInstance positions.
     */
    [Test]
    public function assetInstancePositionsTest():void {
        var testPassed:Boolean = false;
        if (false == _level.contentReady) {
            _level.updateContent(JSON.parse(new PositionTestLevelDataJson()));
            if (true == _level.contentReady) {
                var board:SLT2DBoard = _level.getBoard("Board") as SLT2DBoard;
                var assetInstances:Vector.<SLT2DAssetInstance> = board.getAssetInstancesByLayerId("default");

                var assetInstance:SLT2DAssetInstance = assetInstances[0];
                var positionA:Point = assetInstance.getPositionById("pointA");
                var positionB:Point = assetInstance.getPositionById("pointB");
                var positionUnknown:Point = assetInstance.getPositionById("pointUnknown");
                if (checkAssetInstancePosition(positionA, "pointA") && checkAssetInstancePosition(positionB, "pointB") && null == positionUnknown) {
                    testPassed = true;
                }
            }
        }
        assertEquals(true, testPassed);
    }

    private function checkAssetInstancePosition(position:Point, positionId:String):Boolean {
        var isCorrect:Boolean = false;
        switch (positionId) {
            case "pointA" :
            {
                if (399.98685 == position.x && 310.48752 == position.y) {
                    isCorrect = true;
                }
                break;
            }
            case "pointB" :
            {
                if (442.0 == position.x && 356.0 == position.y) {
                    isCorrect = true;
                }
                break;
            }
            default :
            {
                isCorrect = false;
            }
        }
        return isCorrect;
    }
}
}
