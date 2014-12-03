/**
 * Created by TIGR on 12/3/14.
 */
package saltr.utils {
import flash.display.Stage;

public class DialogController {
    private var _flashStage:Stage;
    private var _deviceRegistrationDialog:DeviceRegistrationDialog;
    private var _submitDeviceRegCallback:Function;

    public function DialogController(flashStage:Stage) {
        _flashStage = flashStage;
        _deviceRegistrationDialog = new DeviceRegistrationDialog(_flashStage);
    }

    public function showDeviceRegistrationDialog(submitCallback:Function):void {
        _submitDeviceRegCallback = submitCallback;
        _deviceRegistrationDialog.show(deviceRegistrationSubmitSuccessHandler, deviceRegistrationSubmitFailHandler);
    }

    public function showDeviceRegistrationStatus(status:String):void {
        //
    }

    private function deviceRegistrationSubmitSuccessHandler(deviceName:String, email:String):void {
        _submitDeviceRegCallback(deviceName, email);
    }

    private function deviceRegistrationSubmitFailHandler(reason:String):void {
        //
    }
}
}
