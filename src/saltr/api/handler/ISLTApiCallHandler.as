/**
 * Created by TIGR on 7/6/2015.
 */
package saltr.api.handler {
import saltr.api.call.SLTApiCallResult;

public interface ISLTApiCallHandler {

    /**
     * Process the API call result.
     * @param result The API call result.
     */
    function handle(result:SLTApiCallResult):void;
}
}
