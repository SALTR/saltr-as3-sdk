/**
 * Created by TIGR on 7/6/2015.
 */
package saltr.api.handler {
import saltr.api.call.SLTApiCallResult;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTApiCallHandler implements ISLTApiCallHandler {
    protected var _result:SLTApiCallResult;
    protected var _successMessage:String;
    protected var _failMessage:String;
    protected var _successHandler:Function;
    protected var _failHandler:Function;

    public function SLTApiCallHandler(successMessage:String = null, failMessage:String = null, successHandler:Function = null, failHandler:Function = null):void {
        _successMessage = successMessage;
        _failMessage = failMessage;
        _successHandler = successHandler;
        _failHandler = failHandler;
    }

    public function handle(result:SLTApiCallResult):void {
        _result = result;
        if (_result.success) {
            handleSuccess();
        } else {
            handleFail();
        }
    }

    protected function handleSuccess():void {
        traceMessage(_successMessage);
        if (_successHandler) {
            _successHandler(_result.data);
        }
    }

    protected function handleFail():void {
        traceMessage(_failMessage);
        if (_failHandler) {
            _failHandler(_result.status);
        }
    }

    protected function traceMessage(message:String):void {
        if (message) {
            trace(message);
        }
    }

}
}
