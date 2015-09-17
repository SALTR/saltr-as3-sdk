/**
 * Created by GSAR on 7/10/14.
 */
package saltr.game.matching {
import flash.utils.Dictionary;

import saltr.game.SLTAssetState;
import saltr.game.SLTBoardParser;
import saltr.game.SLTCheckPointParser;
import saltr.game.SLTLevelParser;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTMatchingBoardParser class represents the matching level parser.
 * @private
 */
public class SLTMatchingBoardParser extends SLTBoardParser {

    private static function initializeCells(cells:SLTCells, boardNode:Object):void {
        var cols:int = cells.width;
        var rows:int = cells.height;

        for (var i:int = 0; i < cols; ++i) {
            for (var j:int = 0; j < rows; ++j) {
                var sltCell:SLTCell = new SLTCell(i, j);
                cells.insert(i, j, sltCell);
            }
        }

        var cellsArray:Array = boardNode.cells;
        for (var k:int = 0; k < cellsArray.length; ++k) {
            var cellObject:Object = cellsArray[k];
            var cell:SLTCell = cells.retrieve(cellObject.col, cellObject.row);
            //blocking check
            if (cellObject.hasOwnProperty("isBlocked") && true == cellObject.isBlocked) {
                cell.isBlocked = true;
            }
            //assigning cell properties
            if (cellObject.hasOwnProperty(SLTLevelParser.NODE_PROPERTY_OBJECTS)) {
                var propertyObjects:Object = cellObject[SLTLevelParser.NODE_PROPERTY_OBJECTS];
                var cellProperties:Dictionary = new Dictionary();
                for (var propertyKey:String in propertyObjects) {
                    cellProperties[propertyKey] = propertyObjects[propertyKey];
                }
                cell.properties = cellProperties;
            }
        }
    }

    /**
     * Class constructor.
     */
    public function SLTMatchingBoardParser() {
    }

    override saltr_internal function parseAssetState(stateNode:Object):SLTAssetState {
        var token:String;

        if (stateNode.hasOwnProperty("token")) {
            token = stateNode.token;
        }
        return new SLTAssetState(token);
    }

    /**
     * Parses the board content.
     * @param rootNode The root node.
     * @param assetMap The asset map.
     * @return The parsed boards.
     */
    override saltr_internal function parseBoardContent(rootNode:Object, assetMap:Dictionary):Dictionary {
        var boardNodes:Object = getBoardsNode(rootNode, SLTLevelParser.BOARD_TYPE_MATCHING);
        if (null == boardNodes) {
            return null;
        }

        var matchingRules:SLTMatchingRules = parseMatchingRules(rootNode, assetMap);
        var matchingRuleIncludedBoards:Array = parseMatchingRuleIncludedBoards(rootNode);

        var boards:Dictionary = new Dictionary();
        for (var boardId:String in boardNodes) {
            var boardRelatedMatchingRules:SLTMatchingRules = new SLTMatchingRules();
            if (matchingRules.matchingRuleEnabled && -1 != matchingRuleIncludedBoards.indexOf(boardId)) {
                boardRelatedMatchingRules = matchingRules;
            }
            var boardNode:Object = boardNodes[boardId];
            boards[boardId] = parseLevelBoard(boardRelatedMatchingRules, boardNode, assetMap);
        }
        return boards;
    }

    private function parseMatchingRules(rootNode:Object, assetMap:Dictionary):SLTMatchingRules {
        var matchingRules:SLTMatchingRules = new SLTMatchingRules();
        if (rootNode.hasOwnProperty(SLTMatchingRules.MATCHING_RULES)) {
            matchingRules.matchingRuleEnabled = true;
            matchingRules.squareRuleEnabled = rootNode.matchingRules.squareMatch;
            matchingRules.matchSize = rootNode.matchingRules.matchSize;

            var excludedAssetNodes:Array = rootNode.matchingRules.excludedAssets as Array;
            var excludedMatchAssets:Vector.<SLTChunkAssetDatum> = new Vector.<SLTChunkAssetDatum>();
            for each (var excludedAssetId:String in excludedAssetNodes) {
                excludedMatchAssets.push(new SLTChunkAssetDatum(excludedAssetId, "", assetMap));
            }
            matchingRules.excludedAssets = excludedMatchAssets;
        }
        return matchingRules;
    }

    private function parseMatchingRuleIncludedBoards(rootNode:Object):Array {
        var boards:Array = null;
        if (rootNode.hasOwnProperty(SLTMatchingRules.MATCHING_RULES)) {
            boards = rootNode.matchingRules.includedBoards as Array;
        }
        return boards;
    }

    private final function parseLevelBoard(matchingRuleProperties:SLTMatchingRules, boardNode:Object, assetMap:Dictionary):SLTMatchingBoard {
        var boardPropertyObjects:Dictionary = parseBoardProperties(boardNode);

        var cells:SLTCells = new SLTCells(boardNode.cols, boardNode.rows);
        initializeCells(cells, boardNode);

        var layers:Dictionary = new Dictionary();
        var layerNodes:Object = boardNode.layers;
        for (var layerToken:String in layerNodes) {
            var layerNode:Object = layerNodes[layerToken];
            var layer:SLTMatchingBoardLayer = parseLayer(layerNode, layerToken, cells, assetMap);
            layers[layerToken] = layer;
        }
        var config:SLTMatchingBoardConfig = new SLTMatchingBoardConfig(cells, layers, boardNode, assetMap, matchingRuleProperties);
        var board:SLTMatchingBoard = new SLTMatchingBoard(config, boardPropertyObjects, SLTCheckPointParser.parseCheckpoints(boardNode));

        return board;
    }

    private function parseLayerChunks(layer:SLTMatchingBoardLayer, chunkNodes:Array, cells:SLTCells, assetMap:Dictionary):void {
        for (var i:int = 0, len:int = chunkNodes.length; i < len; ++i) {
            var chunkNode:Object = chunkNodes[i];
            var cellNodes:Array = chunkNode.cells as Array;
            var chunkCells:Vector.<SLTCell> = new <SLTCell>[];
            for each(var cellNode:Object in cellNodes) {
                chunkCells.push(cells.retrieve(cellNode[0], cellNode[1]) as SLTCell);
            }

            var assetRuleNodes:Array = chunkNode.assetRules as Array;
            var chunkAssetRules:Vector.<SLTChunkAssetRule> = new <SLTChunkAssetRule>[];
            for each (var ruleNode:Object in assetRuleNodes) {
                chunkAssetRules.push(new SLTChunkAssetRule(ruleNode.assetId, ruleNode.distributionType, ruleNode.distributionValue, ruleNode.stateId));
            }

            var matchingRuleEnabled:Boolean = true;
            if (chunkNode.hasOwnProperty("matchingRuleDisabled")) {
                matchingRuleEnabled = false;
            }

            layer.addChunk(new SLTChunk(layer.token, layer.index, chunkCells, chunkAssetRules, matchingRuleEnabled, assetMap));
        }
    }

    private function parseLayer(layerNode:Object, layerToken:String, cells:SLTCells, assetMap:Dictionary):SLTMatchingBoardLayer {
        var layer:SLTMatchingBoardLayer = new SLTMatchingBoardLayer(layerToken, layerNode.index, layerNode.assetRules as Array);
        parseLayerChunks(layer, layerNode.chunks as Array, cells, assetMap);
        return layer;
    }
}
}