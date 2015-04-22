/**
 * Created by GSAR on 7/10/14.
 */
package saltr.game.matching {
import flash.utils.Dictionary;

import saltr.game.SLTBoardLayer;
import saltr.game.SLTLevelParser;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTMatchingLevelParser class represents the matching level parser.
 * @private
 */
public class SLTMatchingLevelParser extends SLTLevelParser {

    private static var INSTANCE:SLTMatchingLevelParser;

    /**
     * Returns the instance of SLTMatchingLevelParser class.
     * @return The  instance of SLTMatchingLevelParser class.
     */
    saltr_internal static function getInstance():SLTMatchingLevelParser {
        if (!INSTANCE) {
            INSTANCE = new SLTMatchingLevelParser(new Singleton());
        }
        return INSTANCE;
    }

    private static function initializeCells(cells:SLTCells, boardNode:Object):void {
        var blockedCells:Array = boardNode.hasOwnProperty("blockedCells") ? boardNode.blockedCells : [];
        var cellProperties:Array = boardNode.hasOwnProperty("cellProperties") ? boardNode.cellProperties : [];
        var cols:int = cells.width;
        var rows:int = cells.height;

        for (var i:int = 0; i < cols; ++i) {
            for (var j:int = 0; j < rows; ++j) {
                var cell:SLTCell = new SLTCell(i, j);
                cells.insert(i, j, cell);
            }
        }

        //assigning cell properties
        for (var p:int = 0, pLen:int = cellProperties.length; p < pLen; ++p) {
            var property:Object = cellProperties[p];
            var cell2:SLTCell = cells.retrieve(property.coords[0], property.coords[1]);
            if (cell2 != null) {
                cell2.properties = property.value;
            }
        }

        //blocking cells
        for (var b:int = 0, bLen:int = blockedCells.length; b < bLen; ++b) {
            var blockedCell:Array = blockedCells[b];
            var cell3:SLTCell = cells.retrieve(blockedCell[0], blockedCell[1]);
            if (cell3 != null) {
                cell3.isBlocked = true;
            }
        }
    }

    /**
     * Class constructor.
     * @param singleton The Singleton class instance.
     */
    public function SLTMatchingLevelParser(singleton:Singleton) {
        if (singleton == null) {
            throw new Error("Class cannot be instantiated. Please use the method called getInstance.");
        }
    }

    /**
     * Parses the level content.
     * @param rootNode The root node.
     * @param assetMap The asset map.
     * @return The parsed boards.
     */
    override saltr_internal function parseLevelContent(rootNode:Object, assetMap:Dictionary):Dictionary {
        var matchingRuleProperties:SLTMatchingRuleProperties = parseMatchingRuleProperties(rootNode, assetMap);
        var matchingRuleIncludedBoards:Array = parseMatchingRuleIncludedBoards(rootNode);

        var boardNodes:Object = getBoardsNode(rootNode);
        var boards:Dictionary = new Dictionary();
        for (var boardId:String in boardNodes) {
            var boardRelatedMatchingRuleProperties:SLTMatchingRuleProperties = new SLTMatchingRuleProperties();
            if (matchingRuleProperties.matchingRuleEnabled && -1 != matchingRuleIncludedBoards.indexOf(boardId)) {
                boardRelatedMatchingRuleProperties = matchingRuleProperties;
            }
            var boardNode:Object = boardNodes[boardId];
            boards[boardId] = parseLevelBoard(boardRelatedMatchingRuleProperties, boardNode, assetMap);
        }
        return boards;
    }

    private function parseMatchingRuleProperties(rootNode:Object, assetMap:Dictionary):SLTMatchingRuleProperties {
        var matchingRuleProperties:SLTMatchingRuleProperties = new SLTMatchingRuleProperties();
        if (rootNode.hasOwnProperty("matchingRuleProperties")) {
            matchingRuleProperties.matchingRuleEnabled = true;
            matchingRuleProperties.squareRuleEnabled = rootNode.matchingRuleProperties.squareRuleEnabled;
            matchingRuleProperties.matchSize = rootNode.matchingRuleProperties.matchSize;

            var excludedAssetNodes:Array = rootNode.matchingRuleProperties.excludedAssets as Array;
            var excludedMatchAssets:Vector.<SLTChunkAssetDatum> = new Vector.<SLTChunkAssetDatum>();
            for each (var excludedAssetNode:Object in excludedAssetNodes) {
                excludedMatchAssets.push(new SLTChunkAssetDatum(excludedAssetNode.assetId, [excludedAssetNode.stateId], assetMap));
            }
            matchingRuleProperties.excludedAssets = excludedMatchAssets;
        }
        return matchingRuleProperties;
    }

    private function parseMatchingRuleIncludedBoards(rootNode:Object):Array {
        var boards:Array = null;
        if (rootNode.hasOwnProperty("matchingRuleProperties")) {
            boards = rootNode.matchingRuleProperties.includedBoards as Array;
        }
        return boards;
    }

    private function parseLevelBoard(matchingRuleProperties:SLTMatchingRuleProperties, boardNode:Object, assetMap:Dictionary):SLTMatchingBoard {
        var boardProperties:Object = {};
        if (boardNode.hasOwnProperty("properties")) {
            boardProperties = boardNode.properties;
        }

        var cells:SLTCells = new SLTCells(boardNode.cols, boardNode.rows);
        initializeCells(cells, boardNode);

        var layers:Vector.<SLTBoardLayer> = new Vector.<SLTBoardLayer>();
        var layerNodes:Array = boardNode.layers;
        for (var i:int = 0, len:int = layerNodes.length; i < len; ++i) {
            var layerNode:Object = layerNodes[i];
            var layer:SLTMatchingBoardLayer = parseLayer(layerNode, i, cells, assetMap);
            layers.push(layer);
        }
        var config:SLTMatchingBoardConfig = new SLTMatchingBoardConfig(cells, layers, boardNode, assetMap, matchingRuleProperties);
        var board:SLTMatchingBoard = new SLTMatchingBoard(config, boardProperties);

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

            var assetNodes:Array = chunkNode.assets as Array;
            var chunkAssetRules:Vector.<SLTChunkAssetRule> = new <SLTChunkAssetRule>[];
            for each (var assetNode:Object in assetNodes) {
                chunkAssetRules.push(new SLTChunkAssetRule(assetNode.assetId, assetNode.distributionType, assetNode.distributionValue, assetNode.states));
            }

            var matchingRuleEnabled:Boolean = true;
            if (chunkNode.hasOwnProperty("matchingRuleDisabled")) {
                matchingRuleEnabled = false;
            }

            layer.addChunk(new SLTChunk(layer.token, layer.index, chunkCells, chunkAssetRules, matchingRuleEnabled, assetMap));
        }
    }


    private function parseLayer(layerNode:Object, index:int, cells:SLTCells, assetMap:Dictionary):SLTMatchingBoardLayer {
        //temporarily checking for 2 names until "layerId" is removed!
        var token:String = layerNode.hasOwnProperty("token") ? layerNode.token : layerNode.layerId;
        var layer:SLTMatchingBoardLayer = new SLTMatchingBoardLayer(layerNode.fixedAssets as Array, token, index);
        parseLayerChunks(layer, layerNode.chunks as Array, cells, assetMap);
        return layer;
    }
}
}

class Singleton {
}