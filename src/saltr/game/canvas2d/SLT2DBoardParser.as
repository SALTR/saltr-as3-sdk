/**
 * Created by GSAR on 7/10/14.
 */
package saltr.game.canvas2d {
import flash.utils.Dictionary;

import saltr.game.SLTAssetState;
import saltr.game.SLTBoardParser;
import saltr.game.SLTCheckPointParser;
import saltr.game.SLTLevelParser;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLT2DLevelParser class represents the 2D level parser.
 * @private
 */
public class SLT2DBoardParser extends SLTBoardParser {

    /**
     * Class constructor.
     */
    public function SLT2DBoardParser() {
    }

    override saltr_internal function parseAssetState(stateNode:Object):SLTAssetState {
        var token:String = stateNode.hasOwnProperty("token") ? stateNode.token : null;
        var pivotX:Number = stateNode.hasOwnProperty("pivotX") ? stateNode.pivotX : 0;
        var pivotY:Number = stateNode.hasOwnProperty("pivotY") ? stateNode.pivotY : 0;
        var width:Number = stateNode.hasOwnProperty("width") ? stateNode.width : 0;
        var height:Number = stateNode.hasOwnProperty("height") ? stateNode.height : 0;

        return new SLT2DAssetState(token, pivotX, pivotY, width, height);
    }

    /**
     * Parses the board content.
     * @param rootNodes The root node.
     * @param assetMap The asset map.
     * @return The parsed boards.
     */
    override saltr_internal function parseBoardContent(rootNode:Object, assetMap:Dictionary):Dictionary {
        var boardNodes:Object = getBoardsNode(rootNode, SLTLevelParser.BOARD_TYPE_CANVAS_2D);
        if (null == boardNodes) {
            return null;
        }
        var boards:Dictionary = new Dictionary();
        for (var boardId:String in boardNodes) {
            var boardNode:Object = boardNodes[boardId];
            boards[boardId] = parseLevelBoard(boardNode, assetMap);
        }
        return boards;
    }

    private function parseLevelBoard(boardNode:Object, assetMap:Dictionary):SLT2DBoard {
        var boardPropertyObjects:Dictionary = parseBoardProperties(boardNode);

        var layers:Dictionary = new Dictionary();
        var layerNodes:Object = boardNode.layers;
        for (var layerToken:String in layerNodes) {
            var layerNode:Object = layerNodes[layerToken];
            var layer:SLT2DBoardLayer = parseLayer(layerNode, layerToken, assetMap);
            layers[layerToken] = layer;
        }

        var config:SLT2DBoardConfig = new SLT2DBoardConfig(layers, boardNode, assetMap);
        return new SLT2DBoard(config, boardPropertyObjects, SLTCheckPointParser.parseCheckpoints(boardNode));
    }

    private function parseLayer(layerNode:Object, layerToken:String, assetMap:Dictionary):SLT2DBoardLayer {
        var layer:SLT2DBoardLayer = new SLT2DBoardLayer(layerToken, layerNode.index, layerNode.assetRules as Array);
        return layer;
    }
}
}