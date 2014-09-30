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
    private var _onSubmit:Function;

    public function NativeDialogs() {
        if (_instance) {
            throw new Error("Singleton... use getInstance()");
        }
        _instance = this;
    }

    public static function getInstance():NativeDialogs {
        if (!_instance) {
            new NativeDialogs();
        }
        return _instance;
    }

    // Add new user device management functions
    public function openRegisterDialog(deviceId:String, onSubmit:Function):void {
        _onSubmit = onSubmit;

        var dlgButtons:Vector.<String> = new Vector.<String>();
        dlgButtons.push(DLG_BUTTON_CANCEL);
        dlgButtons.push(DLG_BUTTON_SUBMIT);

        _dlgReg = new NativeTextInputDialog();
        _dlgReg.addEventListener(NativeDialogEvent.CLOSED, onCloseDialog);
        _dlgReg.buttons = dlgButtons;
        _dlgReg.title = DLG_TITLE;

        var dlgTextFields:Vector.<NativeTextField> = new Vector.<NativeTextField>();

        //creates a description for the dialog [text-field]
        var dlgTextFieldDescription:NativeTextField = new NativeTextField(null);
        dlgTextFieldDescription.text = DLG_DESCRIPTION;
        dlgTextFieldDescription.editable = false;

        //creates a text-input for email dialog [text-field]
        var dlgTextFieldEmail:NativeTextField = new NativeTextField("dlgTextFieldEmail");
        dlgTextFieldEmail.prompText = DLG_PROMPT_EMAIL;
        dlgTextFieldEmail.softKeyboardType = SoftKeyboardType.EMAIL;


        //creates a text-input for device name on dialog [text-field]
        var dlgTextFieldDeviceName:NativeTextField = new NativeTextField("dlgTextFieldDeviceName");
        dlgTextFieldDeviceName.prompText = DLG_PROMPT_DEVICE_NAME;
        dlgTextFieldDeviceName.softKeyboardType = SoftKeyboardType.DEFAULT;


        dlgTextFields.push(dlgTextFieldDescription);
        dlgTextFields.push(dlgTextFieldDeviceName);
        dlgTextFields.push(dlgTextFieldEmail);

        _dlgReg.textInputs = dlgTextFields;
        _dlgReg.show();
    }


    private function onCloseDialog(event:NativeDialogEvent):void {
        var dlgReg:NativeTextInputDialog = NativeTextInputDialog(event.target);
        var btnPressedIndex:String = event.index;


        if (dlgReg.buttons[btnPressedIndex] == DLG_BUTTON_SUBMIT) {
            var dlgDeviceNameText:String = dlgReg.getTextInputByName("dlgTextFieldDeviceName").text;
            var dlgEmailText:String = dlgReg.getTextInputByName("dlgTextFieldEmail").text;
            var isValidName:Boolean = (dlgDeviceNameText != null && dlgDeviceNameText != "") ? true : false;
            var isValidEmail:Boolean = checkEmailValidation(dlgEmailText);

            if (isValidName && isValidEmail) {
                Toast.show(DLG_SUBMIT_SUCCESSFUL, DLG_TIMER);
                if (_onSubmit != null && _onSubmit.length == 2) {
                    _onSubmit(dlgDeviceNameText, dlgEmailText);
                } else {
                    throw new Error(DLG_ERROR_SUBMIT_FUNC);
                }
            } else {
                var notificationText:String = (isValidEmail) ? DLG_NAME_NOT_VALID : DLG_EMAIL_NOT_VALID;
                notificationText = (!isValidEmail && !isValidName) ? DLG_BOTH_NOT_VALID : notificationText;

                var timer:Timer = new Timer(DLG_TIMER, 1);
                timer.addEventListener(TimerEvent.TIMER, function (event:TimerEvent) {
                    event.currentTarget.removeEventListener(TimerEvent.TIMER, arguments.callee);
                    dlgReg.show();
                });
                timer.start();
                Toast.show(notificationText, TOAST_TIMER);
                return;
            }
        }
        dlgReg.removeEventListener(NativeDialogEvent.CLOSED, onCloseDialog);
        dlgReg.dispose();
    }

    private function checkEmailValidation(email:String):Boolean {
        var emailExpression:RegExp = /([a-z0-9._-]+?)@([a-z0-9.-]+)\.([a-z]{2,4})/;
        return emailExpression.test(email);
    }
}
}

