/**
 * Created by GSAR on 7/6/14.
 */
package saltr.game {
public class SLTBoardLayer {

    private var _token:String;
    private var _index:int;

    public function SLTBoardLayer(token:String, layerIndex:int) {
        _token = token;
        _index = layerIndex;
    }

    public function get token():String {
        return _token;
    }

    public function get index():int {
        return _index;
    }

    public function regenerate():void {
        //override
    }
}
}
