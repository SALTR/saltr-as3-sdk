/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {
import saltr.game.SLTBoardLayer;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTMatchingBoardLayer class represents the matching board.
 * @private
 */
internal class SLTMatchingBoardLayer extends SLTBoardLayer {
    private var _chunks:Vector.<SLTChunk>;
    private var _assetRules:Array;

    /**
     * Class constructor.
     * @param assetRules The fixed asset rules.
     * @param token The layer's identifier.
     * @param layerIndex The layer's index.
     */
    public function SLTMatchingBoardLayer(token:String, layerIndex:int, assetRules:Array) {
        super(token, layerIndex);
        _chunks = new Vector.<SLTChunk>();
        _assetRules = assetRules;
    }

    saltr_internal function get assetRules():Array {
        return _assetRules;
    }

    saltr_internal function get chunks():Vector.<SLTChunk> {
        return _chunks;
    }

    saltr_internal function getChunkWithCellPosition(col:uint, row:uint):SLTChunk {
        var chunkFound:SLTChunk = null;
        for each(var chunk:SLTChunk in _chunks) {
            if (chunk.hasCellWithPosition(col, row)) {
                chunkFound = chunk;
                break;
            }
        }
        return chunkFound;
    }

    /**
     * Adds a chunk.
     * @param chunk The chunk to add.
     * @private
     */
    saltr_internal function addChunk(chunk:SLTChunk):void {
        _chunks.push(chunk);
    }
}
}
