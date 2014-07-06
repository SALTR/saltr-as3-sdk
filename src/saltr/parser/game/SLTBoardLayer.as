/**
 * Created by GSAR on 7/6/14.
 */
package saltr.parser.game {
public class SLTBoardLayer {

    private var _layerId:String;
    private var _layerIndex:int;

    public function SLTBoardLayer(layerId:String, layerIndex:int) {
        _layerId = layerId;
        _layerIndex = layerIndex;
    }

    public function get layerId():String {
        return _layerId;
    }

    public function get layerIndex():int {
        return _layerIndex;
    }

}
}
