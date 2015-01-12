/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {
import saltr.game.SLTBoardLayer;

/**
 * The SLTMatchingBoardLayer class represents the matching board.
 */
public class SLTMatchingBoardLayer extends SLTBoardLayer {

    private var _chunks:Vector.<SLTChunk>;

    /**
     * Class constructor.
     * @param layerId The layer's identifier.
     * @param layerIndex The layer's index.
     */
    public function SLTMatchingBoardLayer(layerId:String, layerIndex:int) {
        super(layerId, layerIndex);
        _chunks = new Vector.<SLTChunk>()
    }

    /**
     * Regenerates the content of the layer.
     */
    override public function regenerate():void {
        for (var i:int = 0, len:int = _chunks.length; i < len; ++i) {
            _chunks[i].generateContent();
        }
    }

    /**
     * Adds a chunk.
     * @param chunk The chunk to add.
     */
    public function addChunk(chunk:SLTChunk):void {
        _chunks.push(chunk);
    }

}
}
