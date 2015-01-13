/**
 * Created by TIGR on 12/3/14.
 */
package saltr.utils {
import flash.display.Stage;

/**
 * The DialogController class represents the dialog controller.
 */
public class DialogController {
    private var _flashStage:Stage;
    private var _deviceRegistrationDialog:DeviceRegistrationDialog;
    private var _deviceRegistrationCallback:Function;
    private var _alertDialog:AlertDialog;

    /**
     * Class constructor.
     * @param flashStage The flash stage.
     * @param deviceRegistrationCallback The device registration callback function.
     */
    public function DialogController(flashStage:Stage, deviceRegistrationCallback:Function) {
        _flashStage = flashStage;
        _deviceRegistrationDialog = new DeviceRegistrationDialog(_flashStage);
        _deviceRegistrationCallback = deviceRegistrationCallback;
        _alertDialog = new AlertDialog(_flashStage);
    }

    /**
     * Show the device registration dialog.
     */
    public function showDeviceRegistrationDialog():void {
        _deviceRegistrationDialog.show(_deviceRegistrationCallback);
    }

    /**
     * Show the alert dialog with device registration failed status message.
     */
    public function showDeviceRegistrationFailStatus(status:String):void {
        showAlertDialog(AlertDialog.DLG_DEVICE_REGISTRATION_TITLE, status, showDeviceRegistrationDialog);
    }

    /**
     * Show the alert dialog.
     * @param title The title.
     * @param message The message.
     * @param okCallback The callback function for OK button press event.
     */
    public function showAlertDialog(title:String, message:String, okCallback:Function = null):void {
        _alertDialog.show(title, message, okCallback);
    }
}
}
