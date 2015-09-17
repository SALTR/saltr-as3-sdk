/**
 * Created by GSAR on 7/5/14.
 */

package saltr.game {

/**
 * The SLTAssetState class represents the asset state and provides the state related properties.
 */
public class SLTAssetState {

    private var _token:String;

    /**
     * Class constructor.
     * @param token The unique identifier of the state.
     */
    public function SLTAssetState(token:String) {
        _token = token;
    }

    /**
     * The unique identifier of the state.
     */
    public function get token():String {
        return _token;
    }
}
}
