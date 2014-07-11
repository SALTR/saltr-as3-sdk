/**
 * Created by GSAR on 7/6/14.
 */
package saltr.game {

public class SLTBoard {

    protected var _properties:Object;
    protected var _layers:Vector.<SLTBoardLayer>;

    public function SLTBoard(layers:Vector.<SLTBoardLayer>, properties:Object) {
        _properties = properties;
        _layers = layers;
    }

    public function get properties():Object {
        return _properties;
    }

    public function get layers():Vector.<SLTBoardLayer> {
        return _layers;
    }

}
}
