/**
 * Created by daal on 4/8/16.
 */
package saltr.api.call.factory {
import saltr.SLTAppData;
import saltr.api.call.SLTLevelReportApiCall;
import saltr.api.call.SLTAddPropertiesApiCall;
import saltr.api.call.SLTApiCall;
import saltr.api.call.SLTHeartbeatApiCall;
import saltr.api.call.SLTLevelContentApiCall;
import saltr.api.call.SLTSendLevelEndEventApiCall;
import saltr.api.call.mobile.SLTMobileAppDataApiCall;

public class SLTMobileApiCallFactory extends SLTApiCallFactory {

    override public function getCall(name:String, appData:SLTAppData = null):SLTApiCall {
        var apiCall:SLTApiCall = null;
        switch (name) {
            case API_CALL_ADD_PROPERTIES :
                apiCall = new SLTAddPropertiesApiCall();
                break;
            case API_CALL_APP_DATA :
                apiCall = new SLTMobileAppDataApiCall(appData);
                break;
            case API_CALL_HEARTBEAT :
                apiCall = new SLTHeartbeatApiCall();
                break;
            case API_CALL_LEVEL_CONTENT :
                apiCall = new SLTLevelContentApiCall();
                break;
            case API_CALL_SEND_LEVEL_END :
                apiCall = new SLTSendLevelEndEventApiCall();
                break;
            case API_CALL_LEVEL_REPORT :
                apiCall = new SLTLevelReportApiCall();
                break;
            default :
                throw new Error("Unknown call API name.");
                break;
        }
        return apiCall;
    }
}
}
