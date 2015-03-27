/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {
import saltr.game.SLTBoardLayer;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTMatchingBoardLayer class represents the matching board.
 */
public class SLTMatchingBoardLayer extends SLTBoardLayer {

    private var _chunks:Vector.<SLTChunk>;

    private var _matchingRulesEnabled:Boolean;
    private var _matchSize:int;
    private var _fixedAssets:Array;

    /**
     * Class constructor.
     * @param layerId The layer's identifier.
     * @param layerIndex The layer's index.
     */
    public function SLTMatchingBoardLayer(matchingRulesEnabled : Boolean, matchSize : int, fixedAssets:Array, layerId:String, layerIndex:int) {
        super(layerId, layerIndex);
        _chunks = new Vector.<SLTChunk>()
        _matchingRulesEnabled = matchingRulesEnabled;
        _matchSize = matchSize;
        _fixedAssets = fixedAssets;
    }

    saltr_internal function getChunkWithCellPosition(col:uint, row:uint):SLTChunk {
        var chunkFound:SLTChunk = null;
        for each(var chunk:SLTChunk in _chunks) {
            if(chunk.hasCellWithPosition(col, row)) {
                chunkFound = chunk;
                break;
            }
        }
        return chunkFound;
    }

    public function get matchingRulesEnabled():Boolean {
        return _matchingRulesEnabled;
    }

    public function get matchSize():int {
        return _matchSize;
    }

    public function get fixedAssets():Array {
        return _fixedAssets;
    }

    saltr_internal function get chunks():Vector.<SLTChunk> {
        return _chunks;
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
