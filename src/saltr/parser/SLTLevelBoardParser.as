/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: sarg
 * Date: 4/12/12
 * Time: 9:01 PM
 */
package saltr.parser {
import flash.utils.Dictionary;

import saltr.SLTLevelBoard;
import saltr.parser.data.SLTCellMatrix;
import saltr.parser.gameeditor.SLTAsset;
import saltr.parser.gameeditor.SLTCell;
import saltr.parser.gameeditor.SLTLevelSettings;
import saltr.parser.gameeditor.chunk.SLTChunkAssetInfo;
import saltr.parser.gameeditor.chunk.SLTChunk;
import saltr.parser.gameeditor.composite.SLTCompositeInfo;
import saltr.parser.gameeditor.composite.SLTCompositeAsset;

final public class SLTLevelBoardParser {

    public static function parseLevelBoards(boardNodes:Object, levelSettings:SLTLevelSettings):Dictionary {
        var boards:Dictionary = new Dictionary();
        for (var boardId:String in boardNodes) {
            var boardNode:Object = boardNodes[boardId];
            boards[boardId] = parseLevelBoard(boardNode, levelSettings);
        }
        return boards;
    }

    public static function parseLevelBoard(boardNode:Object, levelSettings:SLTLevelSettings):SLTLevelBoard {
        var boardProperties:Object = {};
        var cells:SLTCellMatrix = parseBoardCells(boardNode, levelSettings);
        if (boardNode.hasOwnProperty("properties") && boardNode.properties.hasOwnProperty("board")) {
            boardProperties = boardNode.properties.board;
        }
        return new SLTLevelBoard(cells, boardProperties);
    }

    private static function parseBoardCells(boardNode:Object, levelSettings:SLTLevelSettings):SLTCellMatrix {
        var cells:SLTCellMatrix = new SLTCellMatrix(boardNode.cols, boardNode.rows);
        createEmptyBoard(cells, boardNode);
        var composites:Dictionary = parseComposites(boardNode.composites as Array, cells, levelSettings);
        var boardChunks:Dictionary = parseChunks(boardNode.chunks as Array, cells, levelSettings);
        generateComposites(composites);
        generateChunks(boardChunks);

        return cells;
    }

    private static function generateChunks(chunks:Dictionary):void {
        for (var key:Object in chunks) {
            (chunks[key] as SLTChunk).generate();
        }
    }

    private static function generateComposites(composites:Dictionary):void {
        for (var key:Object in composites) {
            (composites[key] as SLTCompositeInfo).generate();
        }
    }

    private static function createEmptyBoard(board:SLTCellMatrix, boardNode:Object):void {
        var blockedCells:Array = boardNode.hasOwnProperty("blockedCells") ? boardNode.blockedCells : [];
        var cellProperties:Array = boardNode.hasOwnProperty("properties") && boardNode.properties.hasOwnProperty("cell") ? boardNode.properties.cell : [];
        var cols:int = board.width;
        var rows:int = board.height;
        var len:int = 0;
        for (var i:int = 0; i < rows; ++i) {
            for (var j:int = 0; j < cols; ++j) {
                var cell:SLTCell = new SLTCell(j, i);
                board.insert(j, i, cell);
                len = cellProperties.length;
                for (var p:int = 0; p < len; ++p) {
                    var property:Object = cellProperties[p];
                    if (property.coords[0] == j && property.coords[1] == i) {
                        cell.properties = property.value;
                        break;
                    }
                }
                len = blockedCells.length;
                for (var b:int = 0; b < len; ++b) {
                    var blockedCell:Array = blockedCells[b];
                    if (blockedCell[0] == j && blockedCell[1] == i) {
                        cell.isBlocked = true;
                        break;
                    }
                }
            }
        }
    }

    private static function parseChunks(chunkNodes:Array, outputBoard:SLTCellMatrix, levelSettings:SLTLevelSettings):Dictionary {
        var chunks:Dictionary = new Dictionary();
        for each (var chunkNode:* in chunkNodes) {
            var cellsNode:Array = chunkNode.cells as Array;
            var chunkCells:Vector.<SLTCell> = new <SLTCell>[];
            for each(var cellNode:* in cellsNode) {
                chunkCells.push(outputBoard.retrieve(cellNode[0], cellNode[1]) as SLTCell);
            }


            var assetNodes:Array = chunkNode.assets as Array;
            var chunkAssetInfoList:Vector.<SLTChunkAssetInfo> = new <SLTChunkAssetInfo>[];
            for each (var assetNode:* in assetNodes) {
                chunkAssetInfoList.push(new SLTChunkAssetInfo(assetNode.assetId, assetNode.count, assetNode.stateId));
            }

            var chunkId:String = chunkNode.chunkId;
            var chunk:SLTChunk = new SLTChunk(chunkId, chunkCells, chunkAssetInfoList, levelSettings);
            chunks[chunk.id] = chunk;
        }
        return chunks;
    }

    //TODO @GSAR: check if we need to use outputBoard!
    private static function parseComposites(compositeNodes:Array, outputBoard:SLTCellMatrix, levelSettings:SLTLevelSettings):Dictionary {
        var compositesMap:Dictionary = new Dictionary();
        for each(var compositeNode:* in compositeNodes) {
            var compositeInfo:SLTCompositeInfo = new SLTCompositeInfo(compositeNode.assetId, compositeNode.stateId, outputBoard.retrieve(compositeNode.position[0], compositeNode.position[1]) as SLTCell, levelSettings);
            compositesMap[compositeInfo.assetId] = compositeInfo;
        }
        return compositesMap;
    }

    public static function parseLevelSettings(rootNode:Object):SLTLevelSettings {
        return new SLTLevelSettings(parseBoardAssets(rootNode["assets"]), rootNode["keySets"], parseAssetStates(rootNode["assetStates"]));
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
        if (assetNode.cells/*if asset is composite asset*/) {
            //TODO @GSAR: rename asset.type_key to asset.type when everyone is ready!
            return new SLTCompositeAsset(assetNode.cells as Array, assetNode.type_key, assetNode.keys);
        }
        return new SLTAsset(assetNode.type_key, assetNode.keys);
    }
}
}
