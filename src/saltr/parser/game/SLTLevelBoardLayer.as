/**
 * User: gsar
 * Date: 5/2/14
 * Time: 10:41 AM
 */
package saltr.parser.game {
public class SLTLevelBoardLayer {
    private var _layerId:String;
    private var _layerIndex:int;
    private var _fixedAssets:Array;
    private var _chunks:Array;
    private var _composites:Array;

    public function SLTLevelBoardLayer(layerId:String, layerIndex:int, fixedAssets:Array, chunks:Array, composites:Array) {
        _layerId = layerId;
        _layerIndex = layerIndex;
        _fixedAssets = fixedAssets;
        _chunks = chunks;
        _composites = composites;
    }

    public function get layerId():String {
        return _layerId;
    }

    public function get layerIndex():int {
        return _layerIndex;
    }

    public function get fixedAssets():Array {
        return _fixedAssets;
    }

    public function get chunks():Array {
        return _chunks;
    }

    public function get composites():Array {
        return _composites;
    }
}
}
