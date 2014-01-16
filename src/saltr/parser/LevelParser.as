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

import saltr.parser.data.Vector2D;
import saltr.parser.gameeditor.BoardData;
import saltr.parser.gameeditor.Cell;
import saltr.parser.gameeditor.chunk.AssetInChunk;
import saltr.parser.gameeditor.chunk.Chunk;
import saltr.parser.gameeditor.composite.Composite;
import saltr.parser.gameeditor.composite.CompositeAssetTemplate;
import saltr.parser.gameeditor.simple.SimpleAssetTemplate;

final public class LevelParser {

    public function LevelParser() {
//        throw new StaticClassError();
    }

    public static function parseBoard(outputBoard:Vector2D, board:Object, boardData:BoardData):void {
        createEmptyBoard(outputBoard);
        var composites:Dictionary = parseComposites(board.composites as Array, outputBoard, boardData);
        var boardChunks:Dictionary = parseChunks(board.chunks as Array, outputBoard, boardData);
        generateComposites(composites);
        generateChunks(boardChunks);
    }

    public static function regenerateChunks(outputBoard:Vector2D, board:Object, boardData:BoardData):void {
        var boardChunks:Dictionary = parseChunks(board.chunks as Array, outputBoard, boardData);
        generateChunks(boardChunks);
    }

    private static function generateChunks(chunks:Dictionary):void {
        for (var key:Object in chunks) {
            (chunks[key] as Chunk).generate();
        }
    }

    private static function generateComposites(composites:Dictionary):void {
        for (var key:Object in composites) {
            (composites[key] as Composite).generate();
        }
    }

    private static function createEmptyBoard(board:Vector2D):void {
        var cols:int = board.width;
        var rows:int = board.height;
        for (var i:int = 0; i < rows; ++i) {
            for (var j:int = 0; j < cols; ++j) {
                board.insert(j, i, {
                    col: j,
                    row: i
                });
            }
        }
    }

    private static function parseChunks(chunksPrototype:Array, outputBoard:Vector2D, boardData:BoardData):Dictionary {
        var chunkAsset:AssetInChunk;
        var chunk:Chunk;
        var assetsPrototype:Array;
        var cellsPrototype:Array;
        var chunks:Dictionary = new Dictionary();
        for each (var chunkPrototype:* in chunksPrototype) {
            chunk = new Chunk(String(chunkPrototype.chunkId), outputBoard, boardData);
            assetsPrototype = chunkPrototype.assets as Array;
            for each (var assetPrototype:* in assetsPrototype) {
                chunkAsset = new AssetInChunk(assetPrototype.assetId, assetPrototype.count, assetPrototype.stateId);
                chunk.addChunkAsset(chunkAsset);
            }
            cellsPrototype = chunkPrototype.cells as Array;
            for each(var cellPrototype:* in cellsPrototype) {
                chunk.addCell(new Cell(cellPrototype[0], cellPrototype[1]));
            }
            chunks[chunk.id] = chunk;
        }
        return chunks;
    }


    private static function parseComposites(composites:Array, outputBoard:Vector2D, boardData:BoardData):Dictionary {
        var composite:Composite;
        var compositesMap:Dictionary = new Dictionary();
        for each(var compositePrototype:* in composites) {
            composite = new Composite(compositePrototype.assetId,
                    new Cell(compositePrototype.position[0], compositePrototype.position[1]),
                    outputBoard, boardData);
            compositesMap[composite.id] = composite;
        }
        return compositesMap;
    }

    public static function parseBoardData(data:Object):BoardData {
        var boardData:BoardData = new BoardData();
        boardData.assetMap = parseBoardAssets(data["assets"]);
        boardData.keyset = data["keySets"];
        boardData.stateMap = parseAssetStates(data["assetStates"]);
        return boardData;
    }

    private static function parseAssetStates(states:Object):Dictionary {
        var statesMap:Dictionary = new Dictionary();
        for (var object:Object in states) {
            //noinspection JSUnfilteredForInLoop
            statesMap[object] = states[object];
        }
        return statesMap;
    }

    private static function parseBoardAssets(asetts:Object):Dictionary {
        var assetMap:Dictionary = new Dictionary();
        for (var object:Object in asetts) {
            //noinspection JSUnfilteredForInLoop
            assetMap[object] = parseAsset(asetts[object]);
        }
        return assetMap;

    }

    private static function parseAsset(asset:Object):SimpleAssetTemplate {
        if (asset.cells/*if asset is composite asset*/) {
            return new CompositeAssetTemplate(asset.cells as Array, asset.type_key, asset.keys);
        }
        return new SimpleAssetTemplate(asset.type_key, asset.keys);
    }
}
}
