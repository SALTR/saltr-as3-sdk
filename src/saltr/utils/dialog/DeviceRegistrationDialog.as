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
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import saltr.SLTSaltrMobile;

public class DeviceRegistrationDialog extends Sprite implements IDialog {
    public static const INPUT_FIELD_EMAIL:String = "InputFieldEmail";
    public static const INPUT_FIELD_DEVICE_NAME:String = "InputFieldDeviceName";

    private static const DESIGNED_SCREEN_WIDTH:Number = 1536;
    private static const DIALOG_WIDTH:Number = 600.0;
    private static const DIALOG_HEIGHT:Number = 400.0;

    private var _inputFields:HashMap;
    private var _isCancelled:Boolean;

    public function DeviceRegistrationDialog() {
        _inputFields = new HashMap();
    }

    public function get isCancelled():Boolean {
        return _isCancelled;
    }

    public function show():void {
        init();
        buildView();
    }

    public function dispose():void {
        //TODO @tigr: implement
    }

    public function getTextInputByName(inputName:String):String {
        return TextField(_inputFields.get(inputName)).text;
    }

    private function init():void {
        _inputFields.clear(true);
        _isCancelled = false;
    }

    private function buildView():void {
        var screenWidth:uint = SLTSaltrMobile.flStage.fullScreenWidth;
        var screenHeight:uint = SLTSaltrMobile.flStage.fullScreenHeight;
        var dialogWidth:Number = DIALOG_WIDTH;
        var dialogHeight:Number = DIALOG_HEIGHT;
        var scaleCoef:Number = getScaleCoef();

        var dialogX:Number = (screenWidth - dialogWidth * scaleCoef) / 2;
        var dialogY:Number = (screenHeight - dialogHeight * scaleCoef) / 2;

        var emailTextField:TextField = buildInputTextField(DialogUtils.DLG_PROMPT_EMAIL);
        emailTextField.x = 20.0;
        emailTextField.y = 40.0;
        var deviceNameTextField:TextField = buildInputTextField(DialogUtils.DLG_PROMPT_DEVICE_NAME);
        deviceNameTextField.x = 20.0;
        deviceNameTextField.y = 120.0;

        _inputFields.set(INPUT_FIELD_EMAIL, emailTextField);
        _inputFields.set(INPUT_FIELD_DEVICE_NAME, deviceNameTextField);

        var btnSubmit:SimpleButton = buildButton(DialogUtils.DLG_BUTTON_SUBMIT);
        var btnCancel:SimpleButton = buildButton(DialogUtils.DLG_BUTTON_CANCEL);

        btnSubmit.addEventListener(MouseEvent.CLICK, btnSubmitHandler);
        btnSubmit.x = 40;
        btnSubmit.y = 240;

        btnCancel.addEventListener(MouseEvent.CLICK, btnCancelHandler);
        btnCancel.x = 350;
        btnCancel.y = 240;

        this.graphics.beginFill(0xFF6600, 1);
        this.graphics.drawRect(0, 0, dialogWidth, dialogHeight);
        this.addChild(emailTextField);
        this.addChild(deviceNameTextField);
        this.addChild(btnSubmit);
        this.addChild(btnCancel);
        this.graphics.endFill();

        this.x = dialogX;
        this.y = dialogY;

        this.scaleX = this.scaleY = scaleCoef;
        SLTSaltrMobile.flStage.addChild(this);
    }

    private function btnSubmitHandler(event:MouseEvent):void {
        removeContent();
        dispatchEvent(new Event(DialogUtils.DIALOG_EVENT_CLOSED));
    }

    private function btnCancelHandler(event:MouseEvent):void {
        removeContent();
        _isCancelled = true;
        dispatchEvent(new Event(DialogUtils.DIALOG_EVENT_CLOSED));
    }

    private function removeContent():void {
        SLTSaltrMobile.flStage.removeChild(this);
        this.removeChildren();
    }

    private function getScaleCoef():Number {
        return SLTSaltrMobile.flStage.fullScreenWidth / DESIGNED_SCREEN_WIDTH;
    }

    private function buildInputTextField(defaultText:String):TextField {
        var textField:TextField = new TextField();
        textField.border = true;
        textField.type = TextFieldType.INPUT;
        var format:TextFormat = new TextFormat();
        format.size = 40;
        format.align = TextFormatAlign.LEFT;
        textField.defaultTextFormat = format;
        textField.text = defaultText;
        textField.width = 560.0;
        textField.height = 50.0;
        return textField;
    }

    private function buildButtonLabel(defaultText:String):TextField {
        var textField:TextField = new TextField();
        textField.border = false;
        textField.type = TextFieldType.INPUT;
        var format:TextFormat = new TextFormat();
        format.size = 40;
        format.align = TextFormatAlign.CENTER;
        textField.defaultTextFormat = format;
        textField.text = defaultText;
        textField.width = 200.0;
        textField.height = 50.0;
        return textField;
    }

    private function buildButton(text:String):SimpleButton {
        var width:Number = 200;
        var height:Number = 80;
        var button:SimpleButton = new SimpleButton();

        var stateSprite:Sprite = new Sprite();
        stateSprite.graphics.lineStyle(1, 0x555555);
        stateSprite.graphics.beginFill(0xff000, 1);
        stateSprite.graphics.drawRect(0, 0, width, height);
        var label:TextField = buildButtonLabel(text);
        stateSprite.addChild(label);
        label.y = 15;
        stateSprite.graphics.endFill();

        var hitArea:Sprite = new Sprite();
        hitArea.graphics.lineStyle(1, 0x555555);
        hitArea.graphics.beginFill(0xff000, 1);
        hitArea.graphics.drawRect(0, 0, width, height);
        hitArea.graphics.endFill();

        button.overState = button.downState = button.upState = stateSprite;
        button.hitTestState = hitArea;

        return button;
    }
}
}
