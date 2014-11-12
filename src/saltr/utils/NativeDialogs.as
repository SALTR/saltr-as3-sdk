/**
 * User: kron
 * Date: 29/09/2014
 * Time: 05:34
 */
package saltr.utils {

import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextInputDialog;
import pl.mateuszmackowiak.nativeANE.dialogs.support.NativeTextField;
import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;
import pl.mateuszmackowiak.nativeANE.notifications.Toast;

public class NativeDialogs {

    private static var _instance:NativeDialogs;
    private var _dlgDeviceReg:NativeTextInputDialog;
    private var _submitDeviceRegCallback:Function;

    public function NativeDialogs() {
    }

    public static function getInstance():NativeDialogs {
        if (!_instance) {
            _instance = new NativeDialogs();
        }
        return _instance;
    }

    // Add new user device management functions
    public function openDeviceRegisterDialog(submitCallback:Function):void {
        if(!validateDeviceRegistrationSubmitCallback(submitCallback)) {
            throw new Error(NativeDialogUtils.DLG_ERROR_SUBMIT_FUNC);
        }
        _submitDeviceRegCallback = submitCallback;

        _dlgDeviceReg = buildDeviceRegistrationDialog();
        _dlgDeviceReg.addEventListener(NativeDialogEvent.CLOSED, dialogDeviceRegistrationClosedHandler);
        _dlgDeviceReg.show();
    }

    private function validateDeviceRegistrationSubmitCallback(callback:Function) : Boolean {
        return callback != null && callback.length == 2;
    }

    private function buildDeviceRegistrationDialog() : NativeTextInputDialog {
        var dialog : NativeTextInputDialog =  new NativeTextInputDialog();

        dialog.buttons = new <String>[NativeDialogUtils.DLG_BUTTON_SUBMIT, NativeDialogUtils.DLG_BUTTON_CANCEL];
        dialog.title = NativeDialogUtils.DLG_TITLE;

        dialog.textInputs = new <NativeTextField>[
            NativeDialogUtils.buildDescriptionTextField(NativeDialogUtils.DLG_DEVICE_REGISTRATION_DESCRIPTION),
            NativeDialogUtils.buildEmailTextField(),
            NativeDialogUtils.buildDeviceNameTextField()
        ];

        return dialog;
    }

    private function dialogDeviceRegistrationClosedHandler(event:NativeDialogEvent):void {
        var dlgReg:NativeTextInputDialog = NativeTextInputDialog(event.target);
        var pressedButtonName : String = dlgReg.buttons[event.index];

        if (pressedButtonName == NativeDialogUtils.DLG_BUTTON_SUBMIT) {
            var submittedDeviceName:String = dlgReg.getTextInputByName("dlgTextFieldDeviceName").text;
            var submittedEmailText:String = dlgReg.getTextInputByName("dlgTextFieldEmail").text;

            var validationResult : Object = getDeviceRegistrationSubmittedValuesValidationResults(submittedDeviceName, submittedEmailText);
            if(validationResult.isValid) {
                Toast.show(NativeDialogUtils.DLG_SUBMIT_SUCCESSFUL, NativeDialogUtils.DLG_TIMER);
                _submitDeviceRegCallback(submittedDeviceName, submittedEmailText);
            }
            else {
                NativeDialogUtils.showDialogAfterDelay(dlgReg);
                Toast.show(validationResult.notificationText, NativeDialogUtils.TOAST_TIMER);
                return
            }
        }
        dlgReg.removeEventListener(NativeDialogEvent.CLOSED, dialogDeviceRegistrationClosedHandler);
        dlgReg.dispose();
    }

    private function getDeviceRegistrationSubmittedValuesValidationResults(deviceName:String, email : String) : Object {
        var isDeviceNameValid:Boolean = deviceName != null && deviceName != "";
        var isEmailValid:Boolean = NativeDialogUtils.checkEmailValidation(email);

        var notificationText : String = "";
        if(!isDeviceNameValid || !isEmailValid) {
            notificationText = isEmailValid ? NativeDialogUtils.DLG_NAME_NOT_VALID : NativeDialogUtils.DLG_EMAIL_NOT_VALID;
            notificationText = !isEmailValid && !isDeviceNameValid ? NativeDialogUtils.DLG_BOTH_NOT_VALID : notificationText;
        }

        return {
            isValid : isDeviceNameValid && isEmailValid,
            isDeviceNameValid : isDeviceNameValid,
            isEmailValid : isEmailValid,
            notificationText : notificationText
        }
    }
}
}

