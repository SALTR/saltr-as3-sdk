/**
 * User: sarg
 * Date: 8/2/13
 * Time: 5:28 PM
 */
package saltr.parser.gameeditor {
internal class SLTAssetInstance {
    protected var _keys:Object;
    protected var _state:String;
    protected var _type:String;

    public function SLTAssetInstance(keys:Object, state:String, type:String) {
        _keys = keys;
        _state = state;
        _type = type;
    }

    public function get state():String {
        return _state;
    }

    public function get keys():Object {
        return _keys;
    }

    public function get type():String {
        return _type;
    }

}
}
