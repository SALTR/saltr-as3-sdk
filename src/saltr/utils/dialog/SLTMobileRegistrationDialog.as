/**
 * Created by TIGR on 11/13/14.
 */

package saltr.utils.dialog {
import flash.display.Stage;
import flash.events.FocusEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.ReturnKeyLabel;
import flash.text.SoftKeyboardType;
import flash.text.StageText;
import flash.text.StageTextInitOptions;

import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTMobileRegistrationDialog class represents the mobile registration dialog.
 * @private
 */
public class SLTMobileRegistrationDialog extends SLTRegistrationDialog {

    /**
     * Specifies the device registration dialog description text.
     */
    saltr_internal static const DLG_DEVICE_REGISTRATION_DESCRIPTION:String = "Register Device with SALTR";

    private var _emailTextField:StageText;

    /**
     * Class constructor.
     * @param flashStage The flash stage.
     */
    public function SLTMobileRegistrationDialog(flashStage:Stage) {
        super(flashStage);
    }

    override protected function addToStage():void {
        super.addToStage();
        _emailTextField.stage = _flashStage;
    }

    /**
     * Disposes the dialog.
     */
    override saltr_internal function dispose():void {
        super.dispose();
        _emailTextField.removeEventListener(FocusEvent.FOCUS_IN, emailFocusInHandler);
        _emailTextField.dispose();
        _emailTextField = null;
    }

    override protected function setStatus(text:String):void {
        if (_isShown) {
            _statusTextField.text = text;
        }
    }

    override protected function getScreenWidth():Number {
        return  _flashStage.fullScreenWidth;
    }

    override protected function getScreenHeight():Number {
        return _flashStage.fullScreenHeight;
    }

    override protected function getScaleFactor():Number {
        return Math.min(_flashStage.fullScreenWidth / DESIGNED_SCREEN_WIDTH, 1.0);
    }

    private function emailFocusInHandler(event:FocusEvent):void {
        _emailTextField.text = "";
    }

    private function getDialogPosition():Point {
        var screenWidth:uint = _flashStage.fullScreenWidth;
        var screenHeight:uint = _flashStage.fullScreenHeight;
        var dialogWidth:Number = DIALOG_WIDTH;
        var dialogHeight:Number = DIALOG_HEIGHT;
        var scaleFactor:Number = getScaleFactor();
        var dialogX:Number = (screenWidth - dialogWidth * scaleFactor) / 2;
        var dialogY:Number = (screenHeight - dialogHeight * scaleFactor) / 2;
        return new Point(dialogX, dialogY);
    }

    override protected function buildEmailInputTextField():void {
        var stageTextInitOptions:StageTextInitOptions = new StageTextInitOptions(false);
        var stageText:StageText = new StageText(stageTextInitOptions);
        stageText.softKeyboardType = SoftKeyboardType.DEFAULT;
        stageText.returnKeyLabel = ReturnKeyLabel.DONE;
        stageText.autoCorrect = true;
        stageText.fontFamily = DIALOG_TEXT_FONT_NAME;
        stageText.fontSize = 35;
        stageText.color = DIALOG_COLOR_INPUT_TEXT;

        var dialogPosition:Point = getDialogPosition();
        var scaleFactor:Number = getScaleFactor();
        var xValue:Number = dialogPosition.x + (42.0 + 19.0) * scaleFactor;
        var yValue:Number = dialogPosition.y + 117.0 * scaleFactor;
        var widthValue:Number = (567.0 - 19.0) * scaleFactor;
        var heightValue:Number = 73.0 * scaleFactor;
        stageText.viewPort = new Rectangle(xValue, yValue, widthValue, heightValue);
        stageText.text = DLG_PROMPT_EMAIL;

        _emailTextField = stageText;
        _emailTextField.addEventListener(FocusEvent.FOCUS_IN, emailFocusInHandler);
    }

    override protected function getDescriptionDefaultText():String {
        return DLG_DEVICE_REGISTRATION_DESCRIPTION;
    }

    override protected function getEmailText():String {
        return _emailTextField.text;
    }
}
}
