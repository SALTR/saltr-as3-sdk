/**
 * Created by TIGR on 7/2/2015.
 */
package saltr.utils {
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTLogger {
    private static var INSTANCE:SLTLogger;

    private var _isDebug:Boolean;

    /**
     * Returns an instance of SLTLogger class.
     */
    saltr_internal static function getInstance():SLTLogger {
        if (!INSTANCE) {
            INSTANCE = new SLTLogger(new Singleton());
        }
        return INSTANCE;
    }

    public function SLTLogger(singleton:Singleton) {
        if (null == singleton) {
            throw new Error("Class cannot be instantiated. Please use the method called getInstance.");
        }
        _isDebug = false;
    }

    saltr_internal function set debug(value:Boolean):void {
        _isDebug = value;
    }

    saltr_internal function log(message:String):void {
        if (_isDebug) {
            trace("SLTLogger: " + message);
        }
    }
}
}

class Singleton {
}