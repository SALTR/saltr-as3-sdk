/**
 * Created by daal on 4/13/15.
 */
package saltr.api {
public class ApiFactory {
    public static const API_CALL_ADD_PROPERTIES:String = "AddProperties";
    public static const API_CALL_APP_DATA:String = "AppData";
    public static const API_CALL_HEARTBEAT:String = "Heartbeat";
    public static const API_CALL_LEVEL_CONTENT:String = "LevelContent";
    public static const API_CALL_REGISTER_DEVICE:String = "RegisterDevice";
    public static const API_CALL_REGISTER_USER:String = "RegisterUser";
    public static const API_CALL_SEND_LEVEL_END:String = "SendLevelEnd";
    public static const API_CALL_SYNC:String = "Sync";

    public function getCall(name:String, isMobile:Boolean):ApiCall {
        var apiCall:ApiCall = null;
        switch (name) {
            case API_CALL_ADD_PROPERTIES :
                apiCall = new AddPropertiesApiCall(isMobile);
                break;
            case API_CALL_APP_DATA :
                apiCall = new AppDataApiCall(isMobile);
                break;
            case API_CALL_HEARTBEAT :
                apiCall = new HeartbeatApiCall(isMobile);
                break;
            case API_CALL_LEVEL_CONTENT :
                apiCall = new LevelContentApiCall(isMobile);
                break;
            case API_CALL_REGISTER_DEVICE :
                apiCall = new RegisterDeviceApiCall(isMobile);
                break;
            case API_CALL_REGISTER_USER :
                apiCall = new RegisterUserApiCall(isMobile);
                break;
            case API_CALL_SEND_LEVEL_END :
                apiCall = new SendLevelEndEventApiCall(isMobile);
                break;
            case API_CALL_SYNC :
                apiCall = new SyncApiCall(isMobile);
                break;
            default :
                throw new Error("Unknown call API name.");
                break;
        }
        return apiCall;
    }


}
}
