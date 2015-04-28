/**
 * Created by daal on 4/13/15.
 */
package saltr.api {
public class ApiFactory{

    public function getCall(name:String, isMobile:Boolean) : ApiCall {
        switch (name) {
            case "heartbeat":
                    return new HeartbeatApiCall(null, isMobile);
                break;
            default :
                return null;
                break;
        }
    }




}
}
