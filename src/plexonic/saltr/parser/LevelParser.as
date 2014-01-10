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
package plexonic.saltr.parser {
import de.polygonal.ds.Array2;
import de.polygonal.ds.HashMap;
import de.polygonal.ds.Itr;
import de.polygonal.ds.Map;

import plexonic.saltr.parser.gameeditor.BoardData;
import plexonic.saltr.parser.gameeditor.Cell;
import plexonic.saltr.parser.gameeditor.chunk.AssetInChunk;
import plexonic.saltr.parser.gameeditor.chunk.Chunk;
import plexonic.saltr.parser.gameeditor.composite.Composite;
import plexonic.saltr.parser.gameeditor.composite.CompositeAssetTemplate;
import plexonic.saltr.parser.gameeditor.simple.SimpleAssetTemplate;

final public class LevelParser {

    public function LevelParser() {
//        throw new StaticClassError();
    }

    public static function parseBoard(outputBoard:Array2, board:Object, boardData:BoardData):void {
        createEmptyBoard(outputBoard);
        var composites:HashMap = parseComposites(board.composites as Array, outputBoard, boardData);
        var boardChunks:HashMap = parseChunks(board.chunks as Array, outputBoard, boardData);
        generateComposites(composites);
        generateChunks(boardChunks);
    }

    public static function regenerateChunks(outputBoard:Array2, board:Object, boardData:BoardData):void {
        var boardChunks:HashMap = parseChunks(board.chunks as Array, outputBoard, boardData);
        generateChunks(boardChunks);
    }

    private static function generateChunks(chunks:HashMap):void {
        var iterator:Itr = chunks.iterator();
        iterator.reset();
        while (iterator.hasNext()) {
            (iterator.next() as Chunk).generate();
        }
    }

    private static function generateComposites(composites:HashMap):void {
        var iterator:Itr = composites.iterator();
        iterator.reset();
        while (iterator.hasNext()) {
            (iterator.next() as Composite).generate();
        }
    }

    private static function createEmptyBoard(board:Array2):void {
        var cols:int = board.getW();
        var rows:int = board.getH();
        for (var i:int = 0; i < rows; ++i) {
            for (var j:int = 0; j < cols; ++j) {
                board.set(j, i, {
                    col: j,
                    row: i
                });
            }
        }
    }

    private static function parseChunks(chunksPrototype:Array, outputBoard:Array2, boardData:BoardData):HashMap {
        var chunkAsset:AssetInChunk;
        var chunk:Chunk;
        var assetsPrototype:Array;
        var cellsPrototype:Array;
        var chunks:HashMap = new HashMap(false, chunksPrototype.length);
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
            chunks.set(chunk.id, chunk);
        }
        return chunks;
    }


    private static function parseComposites(composites:Array, outputBoard:Array2, boardData:BoardData):HashMap {
        var composite:Composite;
        var compositesMap:HashMap = new HashMap();
        for each(var compositePrototype:* in composites) {
            composite = new Composite(compositePrototype.assetId,
                    new Cell(compositePrototype.position[0], compositePrototype.position[1]),
                    outputBoard, boardData);
            compositesMap.set(composite.id, composite);
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

    private static function parseAssetStates(states:Object):Map {
        var statesMap:Map = new HashMap();
        for (var object:Object in states) {
            //noinspection JSUnfilteredForInLoop
            statesMap.set(object, states[object]);
        }
        return statesMap;
    }

    private static function parseBoardAssets(asetts:Object):Map {
        var assetMap:Map = new HashMap();
        for (var object:Object in asetts) {
            //noinspection JSUnfilteredForInLoop
            assetMap.set(object, parseAsset(asetts[object]));
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
