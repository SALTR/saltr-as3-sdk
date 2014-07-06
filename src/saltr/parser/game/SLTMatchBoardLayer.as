/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.parser.game {
internal class SLTMatchBoardLayer extends SLTBoardLayer {

    private var _chunks:Vector.<SLTChunk>;

    //TODO @GSAR: assign existing chunk objects here so you can regenerate chunks without parsing again!
    public function SLTMatchBoardLayer(layerId:String, layerIndex:int) {
        super(layerId, layerIndex);
        _chunks = new Vector.<SLTChunk>()
    }

    public function regenerateChunks():void {
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
