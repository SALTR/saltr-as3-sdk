/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {
import saltr.game.SLTBoardLayer;

public class SLTMatchingBoardLayer extends SLTBoardLayer {

    private var _chunks:Vector.<SLTChunk>;

    public function SLTMatchingBoardLayer(layerId:String, layerIndex:int) {
        super(layerId, layerIndex);
        _chunks = new Vector.<SLTChunk>()
    }

    override public function regenerate():void {
        for (var i:int = 0, len:int = _chunks.length; i < len; ++i) {
            _chunks[i].generateContent();
        }
    }

    public function addChunk(chunk:SLTChunk):void {
        _chunks.push(chunk);
    }

    public function purgeChunks():void {
        for (var i:int = 0, len:int = _chunks.length; i < len; ++i) {
            _chunks[i].dispose();
        }
        _chunks.length = 0;
    }
}
}
