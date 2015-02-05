package saltr.api {
import saltr.status.SLTStatus;

public class ApiCallResult {
    private var _success:Boolean;

    private var _status:SLTStatus;
    private var _data:Object;

    public function ApiCallResult() {
    }

    public function get success():Boolean {
        return _success;
    }

    public function set success(value:Boolean):void {
        _success = value;
    }

    public function get data():Object {
        return _data;
    }

    public function set data(value:Object):void {
        _data = value;
    }

    public function get status():SLTStatus {
        return _status;
    }

    public function set status(value:SLTStatus):void {
        _status = value;
    }
}
}