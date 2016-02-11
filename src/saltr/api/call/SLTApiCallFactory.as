/**
 * Created by daal on 4/13/15.
 */
package saltr.api.call {

public class SLTApiCallFactory {
    public static const API_CALL_ADD_PROPERTIES:String = "AddProperties";
    public static const API_CALL_APP_DATA:String = "AppData";
    public static const API_CALL_HEARTBEAT:String = "Heartbeat";
    public static const API_CALL_LEVEL_CONTENT:String = "LevelContent";
    public static const API_CALL_SEND_LEVEL_END:String = "SendLevelEnd";

    public function getCall(name:String, isMobile:Boolean):SLTApiCall {
        var apiCall:SLTApiCall = null;
        switch (name) {
            case API_CALL_ADD_PROPERTIES :
                apiCall = new SLTAddPropertiesApiCall(isMobile);
                break;
            case API_CALL_APP_DATA :
                apiCall = new SLTAppDataApiCall(isMobile);
                break;
            case API_CALL_HEARTBEAT :
                apiCall = new SLTHeartbeatApiCall(isMobile);
                break;
            case API_CALL_LEVEL_CONTENT :
                apiCall = new SLTLevelContentApiCall(isMobile);
                break;
            case API_CALL_SEND_LEVEL_END :
                apiCall = new SLTSendLevelEndEventApiCall(isMobile);
                break;
            default :
                throw new Error("Unknown call API name.");
                break;
        }
        return apiCall;
    }


}
}
