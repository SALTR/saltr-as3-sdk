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
    private var _implementation:SLTMatchingBoardLayerImpl;

    /**
     * Class constructor.
     * @param layerId The layer's identifier.
     * @param layerIndex The layer's index.
     */
    public function SLTMatchingBoardLayer(layerId:String, layerIndex:int) {
        super(layerId, layerIndex);
        _chunks = new Vector.<SLTChunk>()
    }

    saltr_internal function set implementation(implementation:SLTMatchingBoardLayerImpl):void {
        _implementation = implementation;
    }

    saltr_internal function get implementation():SLTMatchingBoardLayerImpl {
        return _implementation;
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
