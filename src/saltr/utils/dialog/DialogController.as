/**
 * Created by TIGR on 12/3/14.
 */
package saltr.utils.dialog {
import flash.display.Stage;
import flash.errors.IllegalOperationError;

import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The DialogController class represents the dialog controller.
 * @private
 */
public class DialogController {
    protected var _flashStage:Stage;
    protected var _registrationDialog:RegistrationDialog;
    protected var _registrationCallback:Function;
    protected var _alertDialog:AlertDialog;

    /**
     * Class constructor.
     * @param flashStage The flash stage.
     * @param registrationCallback The registration callback function.
     */
    public function DialogController(flashStage:Stage, registrationCallback:Function) {
        _flashStage = flashStage;
        _registrationCallback = registrationCallback;
        _alertDialog = new AlertDialog(_flashStage);
        _registrationDialog = createRegistrationDialog();
    }

    /**
     * Show the registration dialog.
     */
    saltr_internal function showRegistrationDialog():void {
        _registrationDialog.show(_registrationCallback);
    }

    /**
     * Show the alert dialog with registration failed status message.
     */
    saltr_internal function showRegistrationFailStatus(status:String):void {
        var title:String = getRegistrationFailTitle();
        showAlertDialog(title, status, showRegistrationDialog);
    }

    /**
     * Show the alert dialog.
     * @param title The title.
     * @param message The message.
     * @param okCallback The callback function for OK button press event.
     */
    saltr_internal function showAlertDialog(title:String, message:String, okCallback:Function = null):void {
        _alertDialog.show(title, message, okCallback);
    }

    protected function createRegistrationDialog():RegistrationDialog {
        throw new IllegalOperationError("createRegistrationDialog is Pure Virtual");
    }

    protected function getRegistrationFailTitle():String {
        throw new IllegalOperationError("getRegistrationFailTitle is Pure Virtual");
    }
}
}
