/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.parser.game {
internal class SLTMatchBoardLayer extends SLTBoardLayer {
    private var _fixedAssetInstancesNodes:Array;
    private var _chunkNodes:Array;
    private var _compositeNodes:Array;


    //TODO @GSAR: assign existing chunk objects here so you can regenerate chunks without parsing again!
    public function SLTMatchBoardLayer(layerId:String, layerIndex:int, fixedAssetInstancesNodes:Array, chunkNodes:Array, compositeNodes:Array) {
        super(layerId, layerIndex);
        _fixedAssetInstancesNodes = fixedAssetInstancesNodes;
        _chunkNodes = chunkNodes;
        _compositeNodes = compositeNodes;
    }

    public function get fixedAssetInstancesNodes():Array {
        return _fixedAssetInstancesNodes;
    }

    public function get chunkNodes():Array {
        return _chunkNodes;
    }

    public function get compositeNodes():Array {
        return _compositeNodes;
    }
}
}
