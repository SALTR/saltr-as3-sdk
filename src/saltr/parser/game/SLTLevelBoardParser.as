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
        var boardChunks:Vector.<SLTChunk> = parseChunks(boardNode.chunks as Array, cells, levelSettings);
        generateComposites(composites);
        generateChunks(boardChunks);

        return cells;
    }

    private static function generateChunks(chunks:Vector.<SLTChunk>):void {
        for (var i:int = 0, len:int = chunks.length; i < len; ++i) {
            chunks[i].generate();

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

    private static function parseChunks(chunkNodes:Array, cellMatrix:SLTCellMatrix, levelSettings:SLTLevelSettings):Vector.<SLTChunk> {
        var chunks:Vector.<SLTChunk> = new <SLTChunk>[];
        for each (var chunkNode:Object in chunkNodes) {
            var cellNodes:Array = chunkNode.cells as Array;
            var chunkCells:Vector.<SLTCell> = new <SLTCell>[];
            for each(var cellNode:Object in cellNodes) {
                chunkCells.push(cellMatrix.retrieve(cellNode[0], cellNode[1]) as SLTCell);
            }


            var assetNodes:Array = chunkNode.assets as Array;
            var chunkAssetInfoList:Vector.<SLTChunkAssetInfo> = new <SLTChunkAssetInfo>[];
            for each (var assetNode:Object in assetNodes) {
                chunkAssetInfoList.push(new SLTChunkAssetInfo(assetNode.assetId, assetNode.count, assetNode.stateId));
            }

            var chunk:SLTChunk = new SLTChunk(chunkCells, chunkAssetInfoList, levelSettings);
            chunks.push(chunk);
        }
        return chunks;
    }

    private static function parseComposites(compositeNodes:Array, cellMatrix:SLTCellMatrix, levelSettings:SLTLevelSettings):Dictionary {
        var compositesMap:Dictionary = new Dictionary();
        for each(var compositeNode:Object in compositeNodes) {
            //TODO @GSAR: rename .position to .cell when everyone is ready!
            var compositeInfo:SLTCompositeInfo = new SLTCompositeInfo(compositeNode.assetId, compositeNode.stateId, cellMatrix.retrieve(compositeNode.position[0], compositeNode.position[1]) as SLTCell, levelSettings);
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
            //TODO @GSAR: rename .cells to .cellInfos when everyone is ready!
            return new SLTCompositeAsset(assetNode.cells as Array, assetNode.type, assetNode.keys);
        }

        var type : String = assetNode.hasOwnProperty("type") ? assetNode.type : assetNode.type_key;
        return new SLTAsset(type, assetNode.keys);
    }
}
}
