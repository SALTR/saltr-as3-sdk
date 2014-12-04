/**
 * Created by TIGR on 12/3/14.
 */
package saltr.utils {
import flash.display.Stage;

public class DialogController {
    private var _flashStage:Stage;
    private var _deviceRegistrationDialog:DeviceRegistrationDialog;
    private var _alertDialog:AlertDialog;

    public function DialogController(flashStage:Stage) {
        _flashStage = flashStage;
        _deviceRegistrationDialog = new DeviceRegistrationDialog(_flashStage);
        _alertDialog = new AlertDialog(_flashStage);
    }

    public function showDeviceRegistrationDialog(submitCallback:Function):void {
        _deviceRegistrationDialog.show(submitCallback);
    }

    public function showDeviceRegistrationStatus(status:String):void {
        showAlertDialog(AlertDialog.DLG_DEVICE_REGISTRATION_TITLE, status);
    }

    public function showAlertDialog(title:String, message:String, okCallback:Function = null):void {
        _alertDialog.show(title, message, okCallback);
    }
}
}
