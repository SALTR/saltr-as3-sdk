/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.parser.game {
import flash.utils.Dictionary;

internal class SLTLevelBoardParser {

    //TODO @GSAR: add try catch here, and handle situation when parse fails!!!
    public static function parseLevelBoards(boardNodes:Object, assetMap:Dictionary):Dictionary {
        var boards:Dictionary = new Dictionary();
        for (var boardId:String in boardNodes) {
            var boardNode:Object = boardNodes[boardId];
            boards[boardId] = parseLevelBoard(boardNode, assetMap);
        }
        return boards;
    }

    public static function parseLevelBoard(boardNode:Object, assetMap:Dictionary):SLTMatchBoard {
        var boardProperties:Object = {};
        if (boardNode.hasOwnProperty("properties") && boardNode.properties.hasOwnProperty("board")) {
            boardProperties = boardNode.properties.board;
        }

        var cells:SLTCellMatrix = new SLTCellMatrix(boardNode.cols, boardNode.rows);
        initializeCells(cells, boardNode);


        var layers:Dictionary = new Dictionary();
        var layerNodes:Array = boardNode.layers;
        for (var i:int = 0, len:int = layerNodes.length; i < len; ++i) {
            var layerNode:Object = layerNodes[i];
            var layer:SLTMatchBoardLayer = new SLTMatchBoardLayer(layerNode.layerId, i, layerNode.fixedAssets, layerNode.chunks, layerNode.composites);
            parseLayer(layer, cells, assetMap);
            layers[layer.layerId] = layer.layerIndex;
        }

        return new SLTMatchBoard(cells, layers, boardProperties);
    }


    private static function parseLayer(layer:SLTMatchBoardLayer, cells:SLTCellMatrix, assetMap:Dictionary):void {
        parseFixedAssets(layer, cells, assetMap);
        parseChunks(layer, cells, assetMap);
    }

    private static function initializeCells(cells:SLTCellMatrix, boardNode:Object):void {
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

    private static function parseFixedAssets(layer:SLTMatchBoardLayer, cells:SLTCellMatrix, assetMap:Dictionary):void {
        var assetInstancesNode:Array = layer.fixedAssetInstancesNodes;
        //creating fixed asset instances and assigning them to cells where they belong
        for (var i:int = 0, iLen:int = assetInstancesNode.length; i < iLen; ++i) {
            var assetInstanceNode:Object = assetInstancesNode[i];
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

    private static function parseChunks(layer:SLTMatchBoardLayer, cellMatrix:SLTCellMatrix, assetMap:Dictionary):void {
        var chunkNodes:Array = layer.chunkNodes;
        for (var i:int = 0, len:int = chunkNodes.length; i < len; ++i) {
            var chunkNode:Object = chunkNodes[i];
            var cellNodes:Array = chunkNode.cells as Array;
            var chunkCells:Vector.<SLTCell> = new <SLTCell>[];
            for each(var cellNode:Object in cellNodes) {
                chunkCells.push(cellMatrix.retrieve(cellNode[0], cellNode[1]) as SLTCell);
            }

            var assetNodes:Array = chunkNode.assets as Array;
            var chunkAssetRules:Vector.<SLTChunkAssetRule> = new <SLTChunkAssetRule>[];
            for each (var assetNode:Object in assetNodes) {
                chunkAssetRules.push(new SLTChunkAssetRule(assetNode.assetId, assetNode.distributionType, assetNode.distributionValue, assetNode.states));
            }

            new SLTChunk(layer, chunkCells, chunkAssetRules, assetMap);
        }
    }

//    private static function parseComposites(layer:SLTLevelBoardLayer, cellMatrix:SLTCellMatrix, assetMap:Dictionary):void {
//        var compositeNodes:Array = layer.compositeNodes;
//        for (var i:int = 0, len:int = compositeNodes.length; i < len; ++i) {
//            var compositeNode:Object = compositeNodes[i];
//            var cellPosition:Array = compositeNode.cell;
//            new SLTComposite(layer, compositeNode.assetId, compositeNode.stateId, cellMatrix.retrieve(cellPosition[0], cellPosition[1]) as SLTCell, assetMap);
//        }
//    }

    public static function parseLevelAssets(rootNode:Object):Dictionary {
        var assetNodes:Object = rootNode["assets"];
        var assetMap:Dictionary = new Dictionary();
        for (var assetId:Object in assetNodes) {
            //noinspection JSUnfilteredForInLoop
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
}
}
