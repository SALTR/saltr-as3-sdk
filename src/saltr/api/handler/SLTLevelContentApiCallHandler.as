/**
 * Created by TIGR on 7/7/2015.
 */
package saltr.api.handler {
import saltr.api.call.SLTApiCallLevelContentResult;
import saltr.api.call.SLTApiCallResult;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTLevelContentApiCallHandler extends SLTApiCallHandler {
    private var _levelContentHandler:Function;

    public function SLTLevelContentApiCallHandler(levelContentHandler:Function):void {
        _levelContentHandler = levelContentHandler;
    }

    override public function handle(result:SLTApiCallResult):void {
        _result = result;
        _levelContentHandler(_result as SLTApiCallLevelContentResult);
    }
}
}
