/**
 * Created by GSAR on 7/10/14.
 */
package saltr.game.matching {
import flash.utils.Dictionary;

import saltr.game.SLTAsset;
import saltr.game.SLTAssetInstance;
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
     * @param boardNodes The board nodes.
     * @param assetMap The asset map.
     * @return The parsed boards.
     */
    override saltr_internal function parseLevelContent(boardNodes:Object, assetMap:Dictionary):Dictionary {
        var boards:Dictionary = new Dictionary();
        for (var boardId:String in boardNodes) {
            var boardNode:Object = boardNodes[boardId];
            boards[boardId] = parseLevelBoard(boardNode, assetMap);
        }
        return boards;
    }

    private function parseLevelBoard(boardNode:Object, assetMap:Dictionary):SLTMatchingBoard {
        var boardProperties:Object = {};
        if (boardNode.hasOwnProperty("properties")) {
            boardProperties = boardNode.properties;
        }

        var cells:SLTCells = new SLTCells(boardNode.cols, boardNode.rows);
        initializeCells(cells, boardNode);

        var matchingRulesEnabled:Boolean = false;
        if (boardNode.hasOwnProperty("matchingRulesEnabled")) {
            matchingRulesEnabled = boardNode.matchingRulesEnabled;
        }
        var squareMatchingRuleEnabled:Boolean = false;
        if (boardNode.hasOwnProperty("squareMatchingRuleEnabled")) {
            squareMatchingRuleEnabled = boardNode.squareMatchingRuleEnabled;
        }

        var layers:Vector.<SLTBoardLayer> = new Vector.<SLTBoardLayer>();
        var layerNodes:Array = boardNode.layers;
        for (var i:int = 0, len:int = layerNodes.length; i < len; ++i) {
            var layerNode:Object = layerNodes[i];
            var layer:SLTMatchingBoardLayer = parseLayer(layerNode, i, cells, assetMap);
            layers.push(layer);
        }

        var alternativeMatchAssets:Vector.<SLTMatchingRuleAsset> = new <SLTMatchingRuleAsset>[];
        if (boardNode.hasOwnProperty("alternativeMatchAssets")) {
            var alternativeAssetNodes:Array = boardNode.alternativeMatchAssets as Array;
            for each (var alternativeAssetNode:Object in alternativeAssetNodes) {
                alternativeMatchAssets.push(new SLTMatchingRuleAsset(alternativeAssetNode.assetId, alternativeAssetNode.stateId));
            }
        }

        var excludedMatchAssets:Vector.<SLTMatchingRuleAsset> = new <SLTMatchingRuleAsset>[];
        if (boardNode.hasOwnProperty("excludedMatchAssets")) {
            var excludedAssetNodes:Array = boardNode.excludedMatchAssets as Array;
            for each (var excludedAssetNode:Object in excludedAssetNodes) {
                excludedMatchAssets.push(new SLTMatchingRuleAsset(excludedAssetNode.assetId, excludedAssetNode.stateId));
            }
        }

        var board:SLTMatchingBoard = new SLTMatchingBoard(cells, layers, boardProperties);
        var boardImplementation:SLTMatchingBoardImpl = new SLTMatchingBoardImpl(board, matchingRulesEnabled, squareMatchingRuleEnabled, alternativeMatchAssets, excludedMatchAssets);
        board.implementation = boardImplementation;
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

            layer.addChunk(new SLTChunk(layer.token, layer.index, chunkCells, chunkAssetRules, assetMap));
        }
    }

    private function parseFixedAssets(layer:SLTMatchingBoardLayer, assetNodes:Array, cells:SLTCells, assetMap:Dictionary):void {
        //creating fixed asset instances and assigning them to cells where they belong
        for (var i:int = 0, iLen:int = assetNodes.length; i < iLen; ++i) {
            var assetInstanceNode:Object = assetNodes[i];
            var asset:SLTAsset = assetMap[assetInstanceNode.assetId] as SLTAsset;
            var stateIds:Array = assetInstanceNode.states as Array;
            var cellPositions:Array = assetInstanceNode.cells;

            for (var j:int = 0, jLen:int = cellPositions.length; j < jLen; ++j) {
                var position:Array = cellPositions[j];
                var cell:SLTCell = cells.retrieve(position[0], position[1]);
                cell.setAssetInstance(layer.token, layer.index, new SLTAssetInstance(asset.token, asset.getInstanceStates(stateIds), asset.properties));
            }
        }
    }


    private function parseLayer(layerNode:Object, index:int, cells:SLTCells, assetMap:Dictionary):SLTMatchingBoardLayer {
        //temporarily checking for 2 names until "layerId" is removed!
        var token:String = layerNode.hasOwnProperty("token") ? layerNode.token : layerNode.layerId;
        var matchingRulesEnabled:Boolean = false;
        if (layerNode.hasOwnProperty("matchingRulesEnabled")) {
            matchingRulesEnabled = layerNode.matchingRulesEnabled;
        }
        var matchSize:int = -1;
        if (layerNode.hasOwnProperty("matchSize")) {
            matchSize = layerNode.matchSize;
        }
        var layer:SLTMatchingBoardLayer = new SLTMatchingBoardLayer(token, index);
        var layerImplementation:SLTMatchingBoardLayerImpl = new SLTMatchingBoardLayerImpl(layer, matchingRulesEnabled, matchSize);
        layer.implementation = layerImplementation;
        parseFixedAssets(layer, layerNode.fixedAssets as Array, cells, assetMap);
        parseLayerChunks(layer, layerNode.chunks as Array, cells, assetMap);
        return layer;
    }
}
}

class Singleton {
}