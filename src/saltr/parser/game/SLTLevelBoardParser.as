/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.parser.game {
import flash.utils.Dictionary;

internal class SLTLevelBoardParser {

    public static function parseLevelBoards(boardNodes:Object, levelSettings:SLTLevelSettings):Dictionary {
        var boards:Dictionary = new Dictionary();
        for (var boardId:String in boardNodes) {
            var boardNode:Object = boardNodes[boardId];
            boards[boardId] = parseLevelBoard(boardNode, levelSettings);
        }
        return boards
    }

    public static function parseLevelBoard(boardNode:Object, levelSettings:SLTLevelSettings):SLTLevelBoard {
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
            var layer:SLTLevelBoardLayer = new SLTLevelBoardLayer(layerNode.layerId, i, layerNode.fixedAssets, layerNode.chunks, layerNode.composites);
            parseLayer(layer, cells, levelSettings);
            layers[layer.layerId] = layer.layerIndex;
        }

        return new SLTLevelBoard(cells, layers, boardProperties);
    }


    private static function parseLayer(layer:SLTLevelBoardLayer, cells:SLTCellMatrix, levelSettings:SLTLevelSettings):void {
        parseFixedAssets(layer, cells, levelSettings);
        parseChunks(layer, cells, levelSettings);
        parseComposites(layer, cells, levelSettings);
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
            var cell3 = cells.retrieve(blockedCell[0], blockedCell[1]);
            if (cell3 != null) {
                cell3.isBlocked = true;
            }
        }
    }

    private static function parseFixedAssets(layer:SLTLevelBoardLayer, cells:SLTCellMatrix, levelSettings:SLTLevelSettings):void {
        var fixedAssetsNode:Array = layer.fixedAssetsNodes;
        var assetMap:Dictionary = levelSettings.assetMap;
        var stateMap:Dictionary = levelSettings.stateMap;

        for (var i:int = 0, iLen:int = fixedAssetsNode.length; i < iLen; ++i) {
            var fixedAsset:Object = fixedAssetsNode[i];
            var asset:SLTAsset = assetMap[fixedAsset.assetId] as SLTAsset;
            var state:String = stateMap[fixedAsset.stateId] as String;
            var cellPositions:Array = fixedAsset.cells;

            for (var j:int = 0, jLen:int = cellPositions.length; j < jLen; ++j) {
                var position:Array = cellPositions[j];
                var cell:SLTCell = cells.retrieve(position[0], position[1]);
                cell.setAssetInstance(layer.layerId, layer.layerIndex, new SLTAssetInstance(asset.token, state, asset.properties))
            }
        }
    }

    private static function parseChunks(layer:SLTLevelBoardLayer, cellMatrix:SLTCellMatrix, levelSettings:SLTLevelSettings):void {
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
                chunkAssetRules.push(new SLTChunkAssetRule(assetNode.assetId, assetNode.distributionType, assetNode.distributionValue, assetNode.stateId));
            }

            new SLTChunk(layer, chunkCells, chunkAssetRules, levelSettings);
        }
    }

    private static function parseComposites(layer:SLTLevelBoardLayer, cellMatrix:SLTCellMatrix, levelSettings:SLTLevelSettings):void {
        var compositeNodes:Array = layer.compositeNodes;
        for (var i:int = 0, len:int = compositeNodes.length; i < len; ++i) {
            var compositeNode:Object = compositeNodes[i];
            var cellPosition:Array = compositeNode.cell;
            new SLTComposite(layer, compositeNode.assetId, compositeNode.stateId, cellMatrix.retrieve(cellPosition[0], cellPosition[1]) as SLTCell, levelSettings);
        }
    }

    public static function parseLevelSettings(rootNode:Object):SLTLevelSettings {
        return new SLTLevelSettings(parseBoardAssets(rootNode["assets"]), parseAssetStates(rootNode["assetStates"]));
    }

    private static function parseAssetStates(states:Object):Dictionary {
        var statesMap:Dictionary = new Dictionary();
        for (var object:Object in states) {
            //noinspection JSUnfilteredForInLoop
            statesMap[object] = states[object];
        }
        return statesMap;
    }

    private static function parseBoardAssets(assetNodes:Object):Dictionary {
        var assetMap:Dictionary = new Dictionary();
        for (var assetId:Object in assetNodes) {
            //noinspection JSUnfilteredForInLoop
            assetMap[assetId] = parseAsset(assetNodes[assetId]);
        }
        return assetMap;

    }

    private static function parseAsset(assetNode:Object):SLTAsset {
        var token:String;
        var properties:Object = assetNode.properties;

        //TODO @daal. supporting type(old) and token.
        if (assetNode.hasOwnProperty("token")) {
            token = assetNode.token;
        } else if (assetNode.hasOwnProperty("type")) {
            token = assetNode.type;
        }

        //if asset is a composite asset!
        if (assetNode.cells || assetNode.cellInfos) {
            return new SLTCompositeAsset(token, assetNode.cellInfos, properties);
        }

        return new SLTAsset(token, properties);
    }
}
}
