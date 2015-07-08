/**
 * Created by TIGR on 7/7/2015.
 */
package saltr.api.call {
import saltr.game.SLTLevel;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTApiCallLevelContentResult extends SLTApiCallResult {
    private var _featureToken:String;
    private var _level:SLTLevel;

    public function SLTApiCallLevelContentResult() {
    }

    saltr_internal function get level():SLTLevel {
        return _level;
    }

    saltr_internal function set level(value:SLTLevel):void {
        _level = value;
    }

    saltr_internal function get featureToken():String {
        return _featureToken;
    }

    saltr_internal function set featureToken(value:String):void {
        _featureToken = value;
    }
}
}
