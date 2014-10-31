/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.utils {
import flash.events.TimerEvent;
import flash.text.SoftKeyboardType;
import flash.utils.Timer;

import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextInputDialog;
import pl.mateuszmackowiak.nativeANE.dialogs.support.NativeTextField;

public class NativeDialogUtils {
    // Set default vales for dialog management
    public static const DLG_BUTTON_SUBMIT:String = "Submit";
    public static const DLG_BUTTON_CANCEL:String = "Cancel";
    public static const DLG_DEVICE_REGISTRATION_DESCRIPTION:String = "Please insert your E-mail and device name";
    public static const DLG_TITLE:String = "Add Device";
    public static const DLG_EMAIL_NOT_VALID:String = "Please insert valid Email.";
    public static const DLG_SUBMIT_SUCCESSFUL:String = "Your data has been successfully submitted.";
    public static const DLG_NAME_NOT_VALID:String = "Please insert device name.";
    public static const DLG_BOTH_NOT_VALID:String = "Please insert device name and valid Email.";
    public static const DLG_ERROR_SUBMIT_FUNC:String = "Submit function should have two parameters - device name and email.";
    public static const TOAST_TIMER:int = 3;
    public static const DLG_TIMER:int = 2000;

    private static const DLG_PROMPT_EMAIL:String = "Valid E-mail";
    private static const DLG_PROMPT_DEVICE_NAME:String = "Device name";

    public function NativeDialogUtils() {
    }

    public static function buildDeviceNameTextField() : NativeTextField {
        var textField:NativeTextField = new NativeTextField("dlgTextFieldDeviceName");
        textField.prompText = DLG_PROMPT_DEVICE_NAME;
        textField.softKeyboardType = SoftKeyboardType.DEFAULT;
        return textField;
    }

    public static function buildEmailTextField() : NativeTextField {
        var textField:NativeTextField = new NativeTextField("dlgTextFieldEmail");
        textField.prompText = DLG_PROMPT_EMAIL;
        textField.softKeyboardType = SoftKeyboardType.EMAIL;
        return textField;
    }

    public static function buildDescriptionTextField(descriptionText:String) : NativeTextField {
        var textField : NativeTextField = new NativeTextField(null);
        textField.text = descriptionText;
        textField.editable = false;
        return textField;
    }

    public static function showDialogAfterDelay(dlgReg:NativeTextInputDialog):void {
        var timer:Timer = new Timer(DLG_TIMER, 1);
        timer.addEventListener(TimerEvent.TIMER, function (event:TimerEvent) {
            event.target.removeEventListener(TimerEvent.TIMER, arguments.callee);
            dlgReg.show();
        });
        timer.start();
    }

    public static function checkEmailValidation(email:String):Boolean {
        var emailExpression:RegExp = /([a-z0-9._-]+?)@([a-z0-9.-]+)\.([a-z]{2,4})/;
        return emailExpression.test(email);
    }
}
}
