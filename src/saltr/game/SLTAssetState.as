/**
 * Created by GSAR on 7/5/14.
 */

package saltr.game {

/**
 * The SLTAssetState class represents the asset state and provides the state related properties.
 */
public class SLTAssetState {

    private var _token:String;
    private var _properties:Object;

    /**
     * Class constructor.
     * @param token - The unique identifier of the state.
     * @param properties - The current state related properties.
     */
    public function SLTAssetState(token:String, properties:Object) {
        _token = token;
        _properties = properties;
    }

    /**
     * The unique identifier of the state.
     */
    public function get token():String {
        return _token;
    }

    /**
     * The properties of the state.
     */
    public function get properties():Object {
        return _properties;
    }
}
}
