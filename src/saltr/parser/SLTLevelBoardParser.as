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
import saltr.parser.gameeditor.chunk.SLTAssetInChunk;
import saltr.parser.gameeditor.chunk.SLTChunk;
import saltr.parser.gameeditor.composite.SLTComposite;
import saltr.parser.gameeditor.composite.SLTCompositeAsset;

final public class SLTLevelBoardParser {

    public static function parseLevelBoards(boardsObject:Object, levelSettings:SLTLevelSettings):Dictionary {
        var boards:Dictionary = new Dictionary();
        for (var id:String in boardsObject) {
            boards[id] = parseLevelBoard(id, boardsObject, levelSettings);
        }
        return boards;
    }

    public static function parseLevelBoard(boardId:String, boardsObject:Object, levelSettings:SLTLevelSettings):SLTLevelBoard {
        var cells:SLTCellMatrix = parseBoardCells(boardsObject[boardId], levelSettings);
        return new SLTLevelBoard(boardId, cells);
    }

    private static function parseBoardCells(boardData:Object, levelSettings:SLTLevelSettings):SLTCellMatrix {
        var cells:SLTCellMatrix = new SLTCellMatrix(boardData.cols, boardData.raws);
        createEmptyBoard(cells, boardData);
        var composites:Dictionary = parseComposites(boardData.composites as Array, cells, levelSettings);
        var boardChunks:Dictionary = parseChunks(boardData.chunks as Array, cells, levelSettings);
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
            (composites[key] as SLTComposite).generate();
        }
    }

    private static function createEmptyBoard(board:SLTCellMatrix, rawBoard:Object):void {
        var blockedCells:Array = rawBoard.hasOwnProperty("blockedCells") ? rawBoard.blockedCells : [];
        var cellProperties:Array = rawBoard.hasOwnProperty("properties") && rawBoard.properties.hasOwnProperty("cell") ? rawBoard.properties.cell : [];
        var cols:int = board.width;
        var rows:int = board.height;
        for (var i:int = 0; i < rows; ++i) {
            for (var j:int = 0; j < cols; ++j) {
                var cell:SLTCell = new SLTCell(j, i);
                board.insert(j, i, cell);
                for (var p:int = 0; p < cellProperties.length; p++) {
                    var property:Object = cellProperties[p];
                    if (property.coords[0] == j && property.coords[1] == i) {
                        cell.properties = property.value;
                        break;
                    }
                }
                for (var b:int = 0; b < blockedCells.length; b++) {
                    var blockedCell:Array = blockedCells[b];
                    if (blockedCell[0] == j && blockedCell[1] == i) {
                        cell.isBlocked = true;
                        break;
                    }
                }
            }
        }
    }

    private static function parseChunks(chunksPrototype:Array, outputBoard:SLTCellMatrix, levelSettings:SLTLevelSettings):Dictionary {
        var chunks:Dictionary = new Dictionary();
        for each (var chunkPrototype:* in chunksPrototype) {
            var chunk:SLTChunk = new SLTChunk(String(chunkPrototype.chunkId), levelSettings);
            var assetsPrototype:Array = chunkPrototype.assets as Array;
            for each (var assetPrototype:* in assetsPrototype) {
                var chunkAsset:SLTAssetInChunk = new SLTAssetInChunk(assetPrototype.assetId, assetPrototype.count, assetPrototype.stateId);
                chunk.addChunkAsset(chunkAsset);
            }
            var cellsPrototype:Array = chunkPrototype.cells as Array;
            for each(var cellPrototype:* in cellsPrototype) {
                chunk.addCell(outputBoard.retrieve(cellPrototype[0], cellPrototype[1]) as SLTCell);
            }
            chunks[chunk.id] = chunk;
        }
        return chunks;
    }

    private static function parseComposites(composites:Array, outputBoard:SLTCellMatrix, levelSettings:SLTLevelSettings):Dictionary {
        var compositesMap:Dictionary = new Dictionary();
        for each(var compositePrototype:* in composites) {
            var composite:SLTComposite = new SLTComposite(compositePrototype.assetId, outputBoard.retrieve(compositePrototype.position[0], compositePrototype.position[1]) as SLTCell, levelSettings);
            compositesMap[composite.id] = composite;
        }
        return compositesMap;
    }

    public static function parseLevelSettings(data:Object):SLTLevelSettings {
        var levelSettings:SLTLevelSettings = new SLTLevelSettings();
        levelSettings.assetMap = parseBoardAssets(data["assets"]);
        levelSettings.keyset = data["keySets"];
        levelSettings.stateMap = parseAssetStates(data["assetStates"]);
        return levelSettings;
    }

    private static function parseAssetStates(states:Object):Dictionary {
        var statesMap:Dictionary = new Dictionary();
        for (var object:Object in states) {
            //noinspection JSUnfilteredForInLoop
            statesMap[object] = states[object];
        }
        return statesMap;
    }

    private static function parseBoardAssets(assets:Object):Dictionary {
        var assetMap:Dictionary = new Dictionary();
        for (var object:Object in assets) {
            //noinspection JSUnfilteredForInLoop
            assetMap[object] = parseAsset(assets[object]);
        }
        return assetMap;

    }

    private static function parseAsset(asset:Object):SLTAsset {
        if (asset.cells/*if asset is composite asset*/) {
            return new SLTCompositeAsset(asset.cells as Array, asset.type_key, asset.keys);
        }
        return new SLTAsset(asset.type_key, asset.keys);
    }
}
}
