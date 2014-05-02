/**
 * User: gsar
 * Date: 5/2/14
 * Time: 10:41 AM
 */
package saltr.parser.game {
internal class SLTLevelBoardLayer {
    private var _layerId:String;
    private var _layerIndex:int;
    private var _fixedAssetsNodes:Array;
    private var _chunkNodes:Array;
    private var _compositeNodes:Array;

    public function SLTLevelBoardLayer(layerId:String, layerIndex:int, fixedAssetsNodes:Array, chunkNodes:Array, compositeNodes:Array) {
        _layerId = layerId;
        _layerIndex = layerIndex;
        _fixedAssetsNodes = fixedAssetsNodes;
        _chunkNodes = chunkNodes;
        _compositeNodes = compositeNodes;
    }

    public function get layerId():String {
        return _layerId;
    }

    public function get layerIndex():int {
        return _layerIndex;
    }

    public function get fixedAssetsNodes():Array {
        return _fixedAssetsNodes;
    }

    public function get chunkNodes():Array {
        return _chunkNodes;
    }

    public function get compositeNodes():Array {
        return _compositeNodes;
    }
}
}
