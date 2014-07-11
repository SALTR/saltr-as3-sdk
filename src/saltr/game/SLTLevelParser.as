/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {
import flash.utils.Dictionary;

internal class SLTLevelParser {

    public static function parseLevelContent(boardNodes:Object, assetMap:Dictionary):Dictionary {
        var boards:Dictionary = new Dictionary();
        for (var boardId:String in boardNodes) {
            var boardNode:Object = boardNodes[boardId];
            boards[boardId] = parseLevelBoard(boardNode, assetMap);
        }
        return boards;
    }

    private static function parseLevelBoard(boardNode:Object, assetMap:Dictionary):SLTMatchingBoard {
        var boardProperties:Object = {};
        if (boardNode.hasOwnProperty("properties") && boardNode.properties.hasOwnProperty("board")) {
            boardProperties = boardNode.properties.board;
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

        return new SLTMatchingBoard(cells, layers, boardProperties);
    }

    private static function parseLayer(layerNode:Object, layerIndex:int, cells:SLTCells, assetMap:Dictionary):SLTMatchingBoardLayer {
        var layerId:String = layerNode.layerId;
        var layer:SLTMatchingBoardLayer = new SLTMatchingBoardLayer(layerId, layerIndex);
        parseFixedAssets(layer, layerNode.fixedAssets as Array, cells, assetMap);
        parseLayerChunks(layer, layerNode.chunks as Array, cells, assetMap);
        return layer;
    }

    private static function initializeCells(cells:SLTCells, boardNode:Object):void {
        var blockedCells:Array = boardNode.hasOwnProperty("blockedCells") ? boardNode.blockedCells : [];
        var cellProperties:Array = boardNode.hasOwnProperty("properties") && boardNode.properties.hasOwnProperty("cell") ? boardNode.properties.cell : [];
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

    private static function parseFixedAssets(layer:SLTMatchingBoardLayer, assetNodes:Array, cells:SLTCells, assetMap:Dictionary):void {
        //creating fixed asset instances and assigning them to cells where they belong
        for (var i:int = 0, iLen:int = assetNodes.length; i < iLen; ++i) {
            var assetInstanceNode:Object = assetNodes[i];
            var asset:SLTAsset = assetMap[assetInstanceNode.assetId] as SLTAsset;
            var stateIds:Array = assetInstanceNode.states as Array;
            var cellPositions:Array = assetInstanceNode.cells;

            for (var j:int = 0, jLen:int = cellPositions.length; j < jLen; ++j) {
                var position:Array = cellPositions[j];
                var cell:SLTCell = cells.retrieve(position[0], position[1]);
                cell.setAssetInstance(layer.layerId, layer.layerIndex, asset.getInstance(stateIds))
            }
        }
    }

    private static function parseLayerChunks(layer:SLTMatchingBoardLayer, chunkNodes:Array, cells:SLTCells, assetMap:Dictionary):void {
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

            layer.addChunk(new SLTChunk(layer, chunkCells, chunkAssetRules, assetMap));
        }
    }

    //Parsing assets here
    public static function parseLevelAssets(rootNode:Object):Dictionary {
        var assetNodes:Object = rootNode["assets"];
        var assetMap:Dictionary = new Dictionary();
        for (var assetId:Object in assetNodes) {
            assetMap[assetId] = parseAsset(assetNodes[assetId]);
        }
        return assetMap;
    }

    private static function parseAsset(assetNode:Object):SLTAsset {
        var token:String;
        var statesMap:Dictionary;
        var properties:Object = null;

        if (assetNode.hasOwnProperty("token")) {
            token = assetNode.token;
        }

        if (assetNode.hasOwnProperty("states")) {
            statesMap = parseAssetStates(assetNode.states);
        }

        if (assetNode.hasOwnProperty("properties")) {
            properties = assetNode.properties;
        }

        return new SLTAsset(token, statesMap, properties);
    }

    private static function parseAssetStates(stateNodes:Object):Dictionary {
        var statesMap:Dictionary = new Dictionary();
        for (var stateId:Object in stateNodes) {
            statesMap[stateId] = parseAssetState(stateNodes[stateId]);
        }

        return statesMap;
    }

    private static function parseAssetState(stateNode:Object):SLTAssetState {
        var token:String;
        var properties:Object = null;

        if (stateNode.hasOwnProperty("token")) {
            token = stateNode.token;
        }

        if (stateNode.hasOwnProperty("properties")) {
            properties = stateNode.properties;
        }

        return new SLTAssetState(token, properties);
    }

//    private static function parseComposites(layer:SLTLevelBoardLayer, cellMatrix:SLTCellMatrix, assetMap:Dictionary):void {
//        var compositeNodes:Array = layer.compositeNodes;
//        for (var i:int = 0, len:int = compositeNodes.length; i < len; ++i) {
//            var compositeNode:Object = compositeNodes[i];
//            var cellPosition:Array = compositeNode.cell;
//            new SLTComposite(layer, compositeNode.assetId, compositeNode.stateId, cellMatrix.retrieve(cellPosition[0], cellPosition[1]) as SLTCell, assetMap);
//        }
//    }

}
}
