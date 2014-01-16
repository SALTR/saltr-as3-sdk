/**
 * User: sarg
 * Date: 8/2/13
 * Time: 5:28 PM
 */
package saltr.parser.gameeditor {
public class BoardAsset {
    protected var _state:String;
    protected var _keys:Object;
    protected var _type:String;

    public function BoardAsset() {
    }

    public function get state():String {
        return _state;
    }

    public function set state(value:String):void {
        _state = value;
    }

    public function set keys(keys:Object):void {
        _keys = keys;
    }

    public function set type(type:String):void {
        _type = type;
    }

    public function get keys():Object {
        return _keys;
    }

    public function get type():String {
        return _type;
    }

}
}
