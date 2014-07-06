/**
 * Created by GSAR on 7/6/14.
 */
package saltr.parser.game {
import flash.utils.Dictionary;

internal class SLTBoard {

    protected var _properties:Object;
    protected var _layers:Dictionary;

    public function SLTBoard(layers:Dictionary, properties:Object) {
        _properties = properties;
        _layers = layers;
    }

    public function get properties():Object {
        return _properties;
    }

    public function get layers():Dictionary {
        return _layers;
    }

}
}
