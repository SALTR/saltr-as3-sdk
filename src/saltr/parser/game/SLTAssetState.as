/**
 * Created by GSAR on 7/5/14.
 */

package saltr.parser.game {
public class SLTAssetState {

    private var _token:String;
    private var _properties:Object;

    public function SLTAssetState(token:String, properties:Object) {
        _token = token;
        _properties = properties;
    }

    public function get token():String {
        return _token;
    }

    public function get properties():Object {
        return _properties;
    }
}
}
