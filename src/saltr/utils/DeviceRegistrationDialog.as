/**
 * Created by TIGR on 11/13/14.
 */

package saltr.utils {
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import saltr.SLTSaltrMobile;
import saltr.utils.Utils;

public class DeviceRegistrationDialog extends Sprite {
    public static const DLG_BUTTON_SUBMIT:String = "Submit";
    public static const DLG_BUTTON_CLOSE:String = "Close";
    public static const DLG_DEVICE_REGISTRATION_DESCRIPTION:String = "Please insert your E-mail and device name";
    public static const DLG_EMAIL_NOT_VALID:String = "Please insert valid Email.";
    public static const DLG_SUBMIT_SUCCESSFUL:String = "Your data has been successfully submitted.";
    public static const DLG_SUBMIT_FAILED:String = "Your data has not been submitted.";
    public static const DLG_SUBMIT_IN_PROCESS:String = "Your data submitting in progress.";
    public static const DLG_NAME_NOT_VALID:String = "Please insert device name.";
    public static const DLG_BOTH_NOT_VALID:String = "Please insert device name and valid Email.";
    public static const DLG_ERROR_SUBMIT_FUNC:String = "Submit function should have two parameters - device name and email.";

    public static const DLG_PROMPT_EMAIL:String = "Valid E-mail";
    public static const DLG_PROMPT_DEVICE_NAME:String = "Device name";

    private static const DESIGNED_SCREEN_WIDTH:Number = 1536;
    private static const DIALOG_WIDTH:Number = 600.0;
    private static const DIALOG_HEIGHT:Number = 400.0;

    private var _flashStage:Stage;
    private var _submitDeviceRegCallback:Function;
    private var _emailTextField:TextField;
    private var _deviceNameTextField:TextField;
    private var _statusTextField:TextField;
    private var _isShown:Boolean;

    public function DeviceRegistrationDialog(flashStage:Stage, submitCallback:Function) {
        if (!validateDeviceRegistrationSubmitCallback(submitCallback)) {
            throw new Error(DLG_ERROR_SUBMIT_FUNC);
        }
        _flashStage = flashStage;
        _submitDeviceRegCallback = submitCallback;
    }

    public function show():void {
        if(!_isShown) {
            buildView();
            _flashStage.addChild(this);
            _isShown = true;
        }
    }

    public function dispose():void {
        _flashStage.removeChild(this);
        this.removeChildren();
        _emailTextField = null;
        _deviceNameTextField = null;
        _statusTextField = null;
        _isShown = false;
    }

    public function setStatus(text:String):void {
        if(_isShown) {
            _statusTextField.text = text;
        }
    }

    private function validateDeviceRegistrationSubmitCallback(callback:Function):Boolean {
        return callback != null && callback.length == 2;
    }

    private function buildView():void {
        var screenWidth:uint = _flashStage.fullScreenWidth;
        var screenHeight:uint = _flashStage.fullScreenHeight;
        var dialogWidth:Number = DIALOG_WIDTH;
        var dialogHeight:Number = DIALOG_HEIGHT;
        var scaleCoef:Number = getScaleFactor();

        var dialogX:Number = (screenWidth - dialogWidth * scaleCoef) / 2;
        var dialogY:Number = (screenHeight - dialogHeight * scaleCoef) / 2;

        var descriptionLabel:TextField = buildDescriptionLabel(DLG_DEVICE_REGISTRATION_DESCRIPTION);
        descriptionLabel.x = 25.0;
        descriptionLabel.y = 20;

        _emailTextField = buildInputTextField(DLG_PROMPT_EMAIL);
        _emailTextField.x = 20.0;
        _emailTextField.y = 80.0;
        _deviceNameTextField = buildInputTextField(DLG_PROMPT_DEVICE_NAME);
        _deviceNameTextField.x = 20.0;
        _deviceNameTextField.y = 160.0;

        _statusTextField = buildStatusTextField();
        _statusTextField.x = 25.0;
        _statusTextField.y = 230;

        var btnSubmit:SimpleButton = buildButton(DLG_BUTTON_SUBMIT);
        var btnClose:SimpleButton = buildButton(DLG_BUTTON_CLOSE);

        btnSubmit.addEventListener(MouseEvent.CLICK, btnSubmitHandler);
        btnSubmit.x = 40;
        btnSubmit.y = 300;

        btnClose.addEventListener(MouseEvent.CLICK, btnCloseHandler);
        btnClose.x = 350;
        btnClose.y = 300;

        this.graphics.beginFill(0xFF6600, 1);
        this.graphics.drawRect(0, 0, dialogWidth, dialogHeight);
        this.addChild(descriptionLabel);
        this.addChild(_emailTextField);
        this.addChild(_deviceNameTextField);
        this.addChild(_statusTextField);
        this.addChild(btnSubmit);
        this.addChild(btnClose);
        this.graphics.endFill();

        this.x = dialogX;
        this.y = dialogY;

        this.scaleX = this.scaleY = scaleCoef;
    }

    private function btnSubmitHandler(event:MouseEvent):void {
        var submittedDeviceName:String = _deviceNameTextField.text;
        var submittedEmailText:String = _emailTextField.text;

        var validationResult:Object = getDeviceRegistrationSubmittedValuesValidationResults(submittedDeviceName, submittedEmailText);
        if (validationResult.isValid) {
            setStatus(DLG_SUBMIT_IN_PROCESS);
            _submitDeviceRegCallback(submittedDeviceName, submittedEmailText);
        }
        else {
            setStatus(validationResult.notificationText);
        }
    }

    private function btnCloseHandler(event:MouseEvent):void {
        dispose();
    }

    private function getDeviceRegistrationSubmittedValuesValidationResults(deviceName:String, email:String):Object {
        var isDeviceNameValid:Boolean = deviceName != null && deviceName != "" && deviceName != DLG_PROMPT_DEVICE_NAME;
        var isEmailValid:Boolean = Utils.checkEmailValidation(email);

        var notificationText:String = "";
        if (!isDeviceNameValid || !isEmailValid) {
            notificationText = isEmailValid ? DLG_NAME_NOT_VALID : DLG_EMAIL_NOT_VALID;
            notificationText = !isEmailValid && !isDeviceNameValid ? DLG_BOTH_NOT_VALID : notificationText;
        }

        return {
            isValid: isDeviceNameValid && isEmailValid,
            isDeviceNameValid: isDeviceNameValid,
            isEmailValid: isEmailValid,
            notificationText: notificationText
        }
    }

    private function getScaleFactor():Number {
        return _flashStage.fullScreenWidth / DESIGNED_SCREEN_WIDTH;
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

    private function buildStatusTextField():TextField {
        var textField:TextField = new TextField();
        textField.border = false;
        var format:TextFormat = new TextFormat();
        format.size = 32;
        format.align = TextFormatAlign.CENTER;
        textField.defaultTextFormat = format;
        textField.width = 550.0;
        textField.height = 40.0;
        return textField;
    }

    private function buildDescriptionLabel(defaultText:String):TextField {
        var textField:TextField = new TextField();
        textField.border = false;
        var format:TextFormat = new TextFormat();
        format.size = 32;
        format.align = TextFormatAlign.CENTER;
        textField.defaultTextFormat = format;
        textField.text = defaultText;
        textField.width = 550.0;
        textField.height = 40.0;
        return textField;
    }

    private function buildButtonLabel(defaultText:String):TextField {
        var textField:TextField = new TextField();
        textField.border = false;
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
