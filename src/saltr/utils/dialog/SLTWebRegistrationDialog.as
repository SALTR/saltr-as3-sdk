/**
 * Created by Tigran Hakobyan on 2/13/2015.
 */
package saltr.utils.dialog {
import flash.display.Stage;
import flash.events.FocusEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTWebRegistrationDialog class represents the web registration dialog.
 * @private
 */
public class SLTWebRegistrationDialog extends SLTRegistrationDialog {
    /**
     * Specifies the device registration dialog description text.
     */
    saltr_internal static const DLG_USER_REGISTRATION_DESCRIPTION:String = "Register User with SALTR";

    private var _emailTextField:TextField;

    /**
     * Class constructor.
     * @param flashStage The flash stage.
     */
    public function SLTWebRegistrationDialog(flashStage:Stage) {
        super(flashStage);
    }

    override protected function addToStage():void {
        super.addToStage();
        this.addChild(_emailTextField);
    }

    /**
     * Disposes the dialog.
     */
    override saltr_internal function dispose():void {
        super.dispose();
        _emailTextField.removeEventListener(FocusEvent.FOCUS_IN, emailFocusInHandler);
        _emailTextField = null;
    }

    override protected function setStatus(text:String):void {
        if (_isShown) {
            _statusTextField.text = text;
        }
    }

    override protected function getScreenWidth():Number {
        return  _flashStage.stageWidth;
    }

    override protected function getScreenHeight():Number {
        return _flashStage.stageHeight;
    }

    override protected function getScaleFactor():Number {
        return Math.min(_flashStage.stageWidth / DESIGNED_SCREEN_WIDTH, 1.0);
    }

    private function emailFocusInHandler(event:FocusEvent):void {
        _emailTextField.text = "";
    }

    private function getDialogPosition():Point {
        var screenWidth:uint = _flashStage.stageWidth;
        var screenHeight:uint = _flashStage.stageHeight;
        var dialogWidth:Number = DIALOG_WIDTH;
        var dialogHeight:Number = DIALOG_HEIGHT;
        var scaleFactor:Number = getScaleFactor();
        var dialogX:Number = (screenWidth - dialogWidth * scaleFactor) / 2;
        var dialogY:Number = (screenHeight - dialogHeight * scaleFactor) / 2;
        return new Point(dialogX, dialogY);
    }

    override protected function buildEmailInputTextField():void {
        var scaleFactor:Number = getScaleFactor();
        var textField:TextField = new TextField();
        textField.border = false;
        textField.type = TextFieldType.INPUT;
        var format:TextFormat = new TextFormat();
        format.size = 35;
        format.font = DIALOG_TEXT_FONT_NAME;
        format.color = DIALOG_COLOR_INPUT_TEXT;
        format.align = TextFormatAlign.LEFT;
        textField.defaultTextFormat = format;
        textField.multiline = true;
        textField.wordWrap = true;
        textField.width = (567.0 - 19.0);
        textField.height = 73.0;
        var xValue:Number = 42.0 + 19.0;
        var yValue:Number = 117.0;
        textField.x = xValue;
        textField.y = yValue;
        textField.text = DLG_PROMPT_EMAIL;

        _emailTextField = textField;
        _emailTextField.addEventListener(FocusEvent.FOCUS_IN, emailFocusInHandler);
    }

    override protected function getDescriptionDefaultText():String {
        return DLG_USER_REGISTRATION_DESCRIPTION;
    }

    override protected function getEmailText():String {
        return _emailTextField.text;
    }
}
}
