/**
 * User: kron
 * Date: 29/09/2014
 * Time: 05:34
 */

package saltr.utils.dialog {

import flash.events.Event;

public class Dialogs {

    private static var _instance:Dialogs;
    private var _dlgDeviceReg:DeviceRegistrationDialog;
    private var _submitDeviceRegCallback:Function;

    public function Dialogs() {
    }

    public static function getInstance():Dialogs {
        if (!_instance) {
            _instance = new Dialogs();
        }
        return _instance;
    }

    // Add new user device management functions
    public function openDeviceRegisterDialog(submitCallback:Function):void {
        if (!validateDeviceRegistrationSubmitCallback(submitCallback)) {
            throw new Error(DialogUtils.DLG_ERROR_SUBMIT_FUNC);
        }
        _submitDeviceRegCallback = submitCallback;

        _dlgDeviceReg = new DeviceRegistrationDialog();
        _dlgDeviceReg.addEventListener(DialogUtils.DIALOG_EVENT_CLOSED, dialogDeviceRegistrationClosedHandler);
        _dlgDeviceReg.show();
    }

    private function validateDeviceRegistrationSubmitCallback(callback:Function):Boolean {
        return callback != null && callback.length == 2;
    }

    private function dialogDeviceRegistrationClosedHandler(event:Event):void {
        var dlgReg:DeviceRegistrationDialog = DeviceRegistrationDialog(event.target);
        //var pressedButtonName : String = dlgReg.buttons[event.index];

        //if (pressedButtonName == NativeDialogUtils.DLG_BUTTON_SUBMIT) {
        var submittedDeviceName:String = dlgReg.getTextInputByName(DeviceRegistrationDialog.INPUT_FIELD_DEVICE_NAME);
        var submittedEmailText:String = dlgReg.getTextInputByName(DeviceRegistrationDialog.INPUT_FIELD_EMAIL);

        var validationResult:Object = getDeviceRegistrationSubmittedValuesValidationResults(submittedDeviceName, submittedEmailText);
        if (validationResult.isValid) {
            //Toast.show(NativeDialogUtils.DLG_SUBMIT_SUCCESSFUL, NativeDialogUtils.DLG_TIMER);
            _submitDeviceRegCallback(submittedDeviceName, submittedEmailText);
        }
        else {
            DialogUtils.showDialogAfterDelay(dlgReg);
            //Toast.show(validationResult.notificationText, NativeDialogUtils.TOAST_TIMER);
            return
        }
        //}
        dlgReg.removeEventListener(DialogUtils.DIALOG_EVENT_CLOSED, dialogDeviceRegistrationClosedHandler);
        dlgReg.dispose();
    }

    private function getDeviceRegistrationSubmittedValuesValidationResults(deviceName:String, email:String):Object {
        var isDeviceNameValid:Boolean = deviceName != null && deviceName != "";
        var isEmailValid:Boolean = DialogUtils.checkEmailValidation(email);

        var notificationText:String = "";
        if (!isDeviceNameValid || !isEmailValid) {
            notificationText = isEmailValid ? DialogUtils.DLG_NAME_NOT_VALID : DialogUtils.DLG_EMAIL_NOT_VALID;
            notificationText = !isEmailValid && !isDeviceNameValid ? DialogUtils.DLG_BOTH_NOT_VALID : notificationText;
        }

        return {
            isValid: isDeviceNameValid && isEmailValid,
            isDeviceNameValid: isDeviceNameValid,
            isEmailValid: isEmailValid,
            notificationText: notificationText
        }
    }
}
}

