/**
 * Created by TIGR on 11/13/14.
 */

package saltr.utils.dialog {
import de.polygonal.ds.HashMap;

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

import saltr.SLTSaltrMobile;

public class DeviceRegistrationDialog extends Sprite implements IDialog {
    public static const INPUT_FIELD_EMAIL:String = "InputFieldEmail";
    public static const INPUT_FIELD_DEVICE_NAME:String = "InputFieldDeviceName";

    private static const DESIGNED_DIALOG_WIDTH:Number = 1536;
    private static const DIALOG_WIDTH:Number = 600.0;
    private static const DIALOG_HEIGHT:Number = 400.0;

    private var _inputFields:HashMap;

    public function DeviceRegistrationDialog() {
        _inputFields = new HashMap();
    }

    public function show():void {
        buildView();
    }

    public function dispose():void {
        //TODO: implement
    }

    public function getTextInputByName(inputName:String):String {
        return TextField(_inputFields.get(inputName)).text;
    }

    private function buildView():void {
        var screenWidth:uint = SLTSaltrMobile.flStage.fullScreenWidth;
        var screenHeight:uint = SLTSaltrMobile.flStage.fullScreenHeight;
        var dialogWidth:Number = DIALOG_WIDTH;
        var dialogHeight:Number = DIALOG_HEIGHT;
        var scaleCoef:Number = getScaleCoef();

        var dialogX:Number = (screenWidth - dialogWidth * scaleCoef) / 2;
        var dialogY:Number = (screenHeight - dialogHeight * scaleCoef) / 2;

        var emailTextField:TextField = DialogUtils.buildInputTextField(DialogUtils.DLG_PROMPT_EMAIL);
        var deviceNameTextField:TextField = DialogUtils.buildInputTextField(DialogUtils.DLG_PROMPT_DEVICE_NAME);
        _inputFields.set(INPUT_FIELD_EMAIL, emailTextField);
        _inputFields.set(INPUT_FIELD_DEVICE_NAME, deviceNameTextField);

        var btnWidth:Number = dialogWidth / 3;
        var btnHeight:Number = dialogHeight / 8;
        var btnSubmit:SimpleButton = DialogUtils.buildButton(DialogUtils.DLG_BUTTON_SUBMIT, btnWidth, btnHeight);
        var btnCancel:SimpleButton = DialogUtils.buildButton(DialogUtils.DLG_BUTTON_CANCEL, btnWidth, btnHeight);

        btnSubmit.addEventListener(MouseEvent.CLICK, btnSubmitHandler);
        btnSubmit.y = 80;

        deviceNameTextField.y = emailTextField.height + 20;

        this.graphics.beginFill(0xFF6600, 1);
        this.graphics.drawRect(0, 0, dialogWidth, dialogHeight);
        this.addChild(emailTextField);
        this.addChild(deviceNameTextField);
        this.addChild(btnSubmit);
        //this.addChild(btnCancel);
        this.graphics.endFill();

        this.x = dialogX;
        this.y = dialogY;

        this.scaleX = this.scaleY = scaleCoef;
        SLTSaltrMobile.flStage.addChild(this);
    }

    private function btnSubmitHandler(event:MouseEvent):void {
        SLTSaltrMobile.flStage.removeChild(this);
        dispatchEvent(new Event(DialogUtils.DIALOG_EVENT_CLOSED));
    }

    private function getScaleCoef():Number {
        return SLTSaltrMobile.flStage.fullScreenWidth / DESIGNED_DIALOG_WIDTH;
    }
}
}
