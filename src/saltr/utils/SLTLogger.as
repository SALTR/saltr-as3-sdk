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
    private var _verboseLogging:Boolean;

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
            throw new Error("[SALTR] Class cannot be instantiated. Please use the method called getInstance.");
        }
        _isDebug = false;
        _verboseLogging = false;
    }

    saltr_internal function set debug(value:Boolean):void {
        _isDebug = value;
    }

    saltr_internal function set verboseLogging(value:Boolean):void {
        _verboseLogging = value;
    }

    saltr_internal function log(message:String):void {
        if (_isDebug && _verboseLogging) {
            trace("[SALTR] " + message);
        }
    }
}
}

class Singleton {
}