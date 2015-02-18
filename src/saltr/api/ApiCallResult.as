package saltr.api {
import saltr.saltr_internal;
import saltr.status.SLTStatus;

use namespace saltr_internal;

/**
 * @private
 */
public class ApiCallResult {
    private var _success:Boolean;

    private var _status:SLTStatus;
    private var _data:Object;

    public function ApiCallResult() {
    }

    saltr_internal function get success():Boolean {
        return _success;
    }

    saltr_internal function set success(value:Boolean):void {
        _success = value;
    }

    saltr_internal function get data():Object {
        return _data;
    }

    saltr_internal function set data(value:Object):void {
        _data = value;
    }

    saltr_internal function get status():SLTStatus {
        return _status;
    }

    saltr_internal function set status(value:SLTStatus):void {
        _status = value;
    }
}
}