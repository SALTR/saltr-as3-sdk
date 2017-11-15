package saltr.core {
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTConfig {

    private static var INSTANCE:SLTConfig;

    private var _deviceId:String;
    private var _clientKey:String;

    public static function getInstance():SLTConfig {
        if (!INSTANCE) {
            INSTANCE = new SLTConfig();
        }
        return INSTANCE;
    }

    public function get deviceId():String {
        return _deviceId;
    }

    public function set deviceId(value:String):void {
        _deviceId = value;
    }

    public function get clientKey():String {
        return _clientKey;
    }

    public function set clientKey(value:String):void {
        _clientKey = value;
    }
}
}