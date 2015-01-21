package saltr.api {

public class ApiCallResult {
    private var _success:Boolean;
    private var _errorMessage:String;
    private var _errorCode:int;
    private var _data:Object;

    public function ApiCallResult() {
    }

    public function get success():Boolean {
        return _success;
    }

    public function set success(value:Boolean):void {
        _success = value;
    }

    public function get errorMessage():String {
        return _errorMessage;
    }

    public function set errorMessage(value:String):void {
        _errorMessage = value;
    }

    public function get data():Object {
        return _data;
    }

    public function set data(value:Object):void {
        _data = value;
    }

    public function get errorCode():int {
        return _errorCode;
    }

    public function set errorCode(value:int):void {
        _errorCode = value;
    }
}
}