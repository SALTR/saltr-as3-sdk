/**
 * User: kron
 * Date: 29/09/2014
 * Time: 05:34
 */
package saltr.utils {
import flash.events.TimerEvent;
import flash.text.SoftKeyboardType;
import flash.utils.Timer;

import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextInputDialog;
import pl.mateuszmackowiak.nativeANE.dialogs.support.NativeTextField;
import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;
import pl.mateuszmackowiak.nativeANE.notifications.Toast;

public class NativeDialogs {

    // Set default vales for dialog management
    private static const DLG_BUTTON_SUBMIT:String = "Submit";
    private static const DLG_BUTTON_CANCEL:String = "Cancel";
    private static const DLG_DESCRIPTION:String = "Please insert your E-mail and device name";
    private static const DLG_PROMPT_EMAIL:String = "Valid E-mail";
    private static const DLG_PROMPT_DEVICE_NAME:String = "Device name";
    private static const DLG_TITLE:String = "Add Device";
    private static const DLG_EMAIL_NOT_VALID:String = "Please insert valid Email.";
    private static const DLG_SUBMIT_SUCCESSFUL:String = "Your data has been successfully submitted.";
    private static const DLG_NAME_NOT_VALID:String = "Please insert device name.";
    private static const DLG_BOTH_NOT_VALID:String = "Please insert device name and valid Email.";
    private static const DLG_ERROR_SUBMIT_FUNC:String = "Submit function should have two parameters - device name and email.";
    private static const DLG_TIMER:int = 2000;
    private static const TOAST_TIMER:int = 3;

    private static var _instance:NativeDialogs;
    private var _dlgReg:NativeTextInputDialog;
    private var _submitCallback:Function;

    public function NativeDialogs() {
    }

    public static function getInstance():NativeDialogs {
        if (!_instance) {
            _instance = new NativeDialogs();
        }
        return _instance;
    }

    // Add new user device management functions
    public function openRegisterDialog(submitCallback:Function):void {
        if(!validateSubmitCallback(submitCallback)) {
            throw new Error(DLG_ERROR_SUBMIT_FUNC);
        }
        _submitCallback = submitCallback;

        _dlgReg = buildRegistrationDialog();
        _dlgReg.show();
    }

    private function validateSubmitCallback(callback:Function) : Boolean {
        return callback != null && callback.length == 2;
    }

    private function buildRegistrationDialog() : NativeTextInputDialog {
        var dialog : NativeTextInputDialog =  new NativeTextInputDialog();

        dialog.buttons = new <String>[DLG_BUTTON_SUBMIT, DLG_BUTTON_CANCEL];
        dialog.title = DLG_TITLE;

        dialog.textInputs = new <NativeTextField>[
            buildDescriptionTextField(),
            buildEmailTextField(),
            buildDeviceNameTextField()
        ];

        return dialog;
    }

    private function buildDeviceNameTextField() : NativeTextField {
        var textField:NativeTextField = new NativeTextField("dlgTextFieldDeviceName");
        textField.prompText = DLG_PROMPT_DEVICE_NAME;
        textField.softKeyboardType = SoftKeyboardType.DEFAULT;
        return textField;
    }

    private function buildEmailTextField() : NativeTextField {
        var textField:NativeTextField = new NativeTextField("dlgTextFieldEmail");
        textField.prompText = DLG_PROMPT_EMAIL;
        textField.softKeyboardType = SoftKeyboardType.EMAIL;
        return textField;
    }

    private function buildDescriptionTextField() : NativeTextField {
        var textField : NativeTextField = new NativeTextField(null);
        textField.text = DLG_DESCRIPTION;
        textField.editable = false;
        return textField;
    }

    private function dialogClosedHandler(event:NativeDialogEvent):void {
        var dlgReg:NativeTextInputDialog = NativeTextInputDialog(event.target);
        var pressedButtonName : String = dlgReg.buttons[event.index];

        if (pressedButtonName == DLG_BUTTON_SUBMIT) {
            var submittedDeviceName:String = dlgReg.getTextInputByName("dlgTextFieldDeviceName").text;
            var submittedEmailText:String = dlgReg.getTextInputByName("dlgTextFieldEmail").text;

            var validationResult : Object = getSubmittedValuesValidationResults(submittedDeviceName, submittedEmailText);
            if(validationResult.isValid) {
                Toast.show(DLG_SUBMIT_SUCCESSFUL, DLG_TIMER);
                _submitCallback(submittedDeviceName, submittedEmailText);
            }
            else {
                showDialogAfterDelay(dlgReg);
                Toast.show(validationResult.notificationText, TOAST_TIMER);
                return
            }
        }
        dlgReg.removeEventListener(NativeDialogEvent.CLOSED, dialogClosedHandler);
        dlgReg.dispose();
    }

    private function showDialogAfterDelay(dlgReg:NativeTextInputDialog):void {
        var timer:Timer = new Timer(DLG_TIMER, 1);
        timer.addEventListener(TimerEvent.TIMER, function (event:TimerEvent) {
            event.target.removeEventListener(TimerEvent.TIMER, arguments.callee);
            dlgReg.show();
        });
        timer.start();
    }

    private function getSubmittedValuesValidationResults(deviceName:String, email : String) : Object {
        var isDeviceNameValid:Boolean = deviceName != null && deviceName != "";
        var isEmailValid:Boolean = Utils.checkEmailValidation(email);

        var notificationText : String = "";
        if(!isDeviceNameValid || !isEmailValid) {
            notificationText = isEmailValid ? DLG_NAME_NOT_VALID : DLG_EMAIL_NOT_VALID;
            notificationText = !isEmailValid && !isDeviceNameValid ? DLG_BOTH_NOT_VALID : notificationText;
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

