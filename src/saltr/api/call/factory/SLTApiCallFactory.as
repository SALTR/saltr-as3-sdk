/**
 * Created by daal on 4/13/15.
 */
package saltr.api.call.factory {
import plexonic.error.ErrorAbstractMethodInvokation;

import saltr.SLTAppData;
import saltr.api.call.SLTApiCall;

public class SLTApiCallFactory {
    public static const API_CALL_ADD_PROPERTIES:String = "AddProperties";
    public static const API_CALL_APP_DATA:String = "AppData";
    public static const API_CALL_HEARTBEAT:String = "Heartbeat";
    public static const API_CALL_LEVEL_CONTENT:String = "LevelContent";
    public static const API_CALL_LOCALE_CONTENT:String = "LocaleContent";
    public static const API_CALL_SEND_LEVEL_END:String = "SendLevelEnd";
    public static const API_CALL_LEVEL_REPORT:String = "LevelReport";

    private static var _factory:SLTApiCallFactory;

    public static function get factory():SLTApiCallFactory {
        return _factory;
    }

    public static function set factory(value:SLTApiCallFactory):void {
        _factory = value;
    }


    public function getCall(name:String, appData:SLTAppData = null):SLTApiCall {
        throw new ErrorAbstractMethodInvokation();
    }
}
}
