/**
 * Created by TIGR on 11/13/14.
 */

package saltr.utils {
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.ReturnKeyLabel;
import flash.text.SoftKeyboardType;
import flash.text.StageText;
import flash.text.StageTextInitOptions;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The DeviceRegistrationDialog class represents the device registration dialog.
 */
public class DeviceRegistrationDialog extends Sprite {

    /**
     * Specifies the submit button's text.
     */
    saltr_internal static const DLG_BUTTON_SUBMIT:String = "Submit";

    /**
     * Specifies the cancel button's text.
     */
    saltr_internal static const DLG_BUTTON_CANCEL:String = "Cancel";

    /**
     * Specifies the device registration dialog description text.
     */
    saltr_internal static const DLG_DEVICE_REGISTRATION_DESCRIPTION:String = "Register Device with SALTR";

    /**
     * Specifies the wrong email text.
     */
    saltr_internal static const DLG_EMAIL_NOT_VALID:String = "Please insert valid Email.";

    /**
     * Specifies the successful transmission text.
     */
    saltr_internal static const DLG_SUBMIT_SUCCESSFUL:String = "Your data has been successfully submitted.";

    /**
     * Specifies the failed transmission text.
     */
    saltr_internal static const DLG_SUBMIT_FAILED:String = "Your data has not been submitted.";

    /**
     * Specifies the wrong submit callback function text.
     */
    saltr_internal static const DLG_ERROR_SUBMIT_FUNC:String = "Submit function should have email parameter.";

    /**
     * Specifies the email prompting text.
     */
    saltr_internal static const DLG_PROMPT_EMAIL:String = "example@mail.com";

    private static const DESIGNED_SCREEN_WIDTH:Number = 750;
    private static const DIALOG_WIDTH:Number = 649.0;
    private static const DIALOG_HEIGHT:Number = 355.0;

    private static const DIALOG_COLOR_BACKGROUND:uint = 0xe7e7e7;
    private static const DIALOG_TEXT_FONT_NAME:String = "Helvetica Neue";
    private static const DIALOG_COLOR_INPUT_TEXT:uint = 0x999999;
    private static const DIALOG_COLOR_BUTTON:Object = 0x549ef4;

    private var _flashStage:Stage;
    private var _submitSuccessCallback:Function;
    private var _emailTextField:StageText;
    private var _statusTextField:TextField;
    private var _isShown:Boolean;

    /**
     * Class constructor.
     */
    public function DeviceRegistrationDialog() {
    }

    /**
     * Initialization function.
     * @param flashStage The flash stage.
     */
    saltr_internal function init(flashStage:Stage) {
        _flashStage = flashStage;
    }

    /**
     * Show the dialog.
     * @param submitSuccessCallback The submitting callback function.
     */
    saltr_internal function show(submitSuccessCallback:Function):void {
        if (!_isShown) {
            if (!validateDeviceRegistrationSubmitCallback(submitSuccessCallback)) {
                throw new Error(DLG_ERROR_SUBMIT_FUNC);
            }
            _submitSuccessCallback = submitSuccessCallback;
            buildView();
            _flashStage.addChild(this);
            _emailTextField.stage = _flashStage;
            _isShown = true;
        }
    }

    /**
     * Disposes the dialog.
     */
    saltr_internal function dispose():void {
        _flashStage.removeChild(this);
        this.removeChildren();
        _emailTextField.removeEventListener(flash.events.FocusEvent.FOCUS_IN, emailFocusInHandler);
        _emailTextField.dispose();
        _emailTextField = null;
        _statusTextField = null;
        _isShown = false;
    }

    private function setStatus(text:String):void {
        if (_isShown) {
            _statusTextField.text = text;
        }
    }

    private function validateDeviceRegistrationSubmitCallback(callback:Function):Boolean {
        return callback != null && callback.length == 1;
    }

    private function buildView():void {
        var screenWidth:uint = _flashStage.fullScreenWidth;
        var screenHeight:uint = _flashStage.fullScreenHeight;
        var dialogWidth:Number = DIALOG_WIDTH;
        var dialogHeight:Number = DIALOG_HEIGHT;
        var scaleFactor:Number = getScaleFactor();

        var dialogX:Number = (screenWidth - dialogWidth * scaleFactor) / 2;
        var dialogY:Number = (screenHeight - dialogHeight * scaleFactor) / 2;

        var descriptionLabel:TextField = buildDescriptionLabel(DLG_DEVICE_REGISTRATION_DESCRIPTION);
        descriptionLabel.x = 36.0;
        descriptionLabel.y = 38.0;

        var emailBackground:Sprite = buildEmailBackground();
        emailBackground.x = 42.0;
        emailBackground.y = 107.0;

        _emailTextField = buildEmailInputTextField(DLG_PROMPT_EMAIL);
        _emailTextField.addEventListener(flash.events.FocusEvent.FOCUS_IN, emailFocusInHandler);

        _statusTextField = buildStatusTextField();
        _statusTextField.x = 42.0;
        _statusTextField.y = 197;

        var buttonsBackground:Sprite = buildButtonsBackground();
        buttonsBackground.x = 0.0;
        buttonsBackground.y = 267.0;

        var btnCancel:SimpleButton = buildButton(DLG_BUTTON_CANCEL, false);
        var btnSubmit:SimpleButton = buildButton(DLG_BUTTON_SUBMIT, true);

        btnCancel.addEventListener(MouseEvent.CLICK, btnCancelHandler);
        btnCancel.x = 47;
        btnCancel.y = 268;

        btnSubmit.addEventListener(MouseEvent.CLICK, btnSubmitHandler);
        btnSubmit.x = 375;
        btnSubmit.y = 268;

        this.graphics.beginFill(DIALOG_COLOR_BACKGROUND, 1);
        this.graphics.drawRect(0, 0, dialogWidth, dialogHeight);
        this.addChild(descriptionLabel);
        this.addChild(emailBackground);
        this.addChild(_statusTextField);
        this.addChild(buttonsBackground);
        this.addChild(btnCancel);
        this.addChild(btnSubmit);
        this.graphics.endFill();

        this.x = dialogX;
        this.y = dialogY;

        this.scaleX = this.scaleY = scaleFactor;
    }

    private function emailFocusInHandler(event:FocusEvent):void {
        _emailTextField.text = "";
    }

    private function btnSubmitHandler(event:MouseEvent):void {
        var submittedEmailText:String = _emailTextField.text;

        var validationResult:Object = getDeviceRegistrationSubmittedValuesValidationResults(submittedEmailText);
        if (validationResult.isValid) {
            event.target.removeEventListener(MouseEvent.CLICK, btnSubmitHandler);
            dispose();
            _submitSuccessCallback(submittedEmailText);
        }
        else {
            setStatus(validationResult.notificationText);
        }
    }

    private function btnCancelHandler(event:MouseEvent):void {
        event.target.removeEventListener(MouseEvent.CLICK, btnCancelHandler);
        dispose();
    }

    private function getDeviceRegistrationSubmittedValuesValidationResults(email:String):Object {
        var isEmailValid:Boolean = (email.indexOf(DLG_PROMPT_EMAIL) == -1) && Utils.checkEmailValidation(email);

        var notificationText:String = "";
        if (!isEmailValid) {
            notificationText = DLG_EMAIL_NOT_VALID;
        }

        return {
            isValid: isEmailValid,
            notificationText: notificationText
        }
    }

    private function getScaleFactor():Number {
        return Math.min(_flashStage.fullScreenWidth / DESIGNED_SCREEN_WIDTH, 1.0);
    }

    private function buildEmailBackground():Sprite {
        var sprite:Sprite = new Sprite();
        sprite.graphics.lineStyle(1, DIALOG_COLOR_INPUT_TEXT);
        sprite.graphics.beginFill(0xFFFFFF, 1);
        sprite.graphics.drawRect(0, 0, 567.0, 73.0);
        sprite.graphics.endFill();
        return sprite;
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

    private function buildEmailInputTextField(defaultText:String):StageText {
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
        stageText.text = defaultText;
        return stageText;
    }

    private function buildStatusTextField():TextField {
        var textField:TextField = new TextField();
        textField.border = false;
        var format:TextFormat = new TextFormat();
        format.size = 35;
        format.leftMargin = 19;
        format.font = DIALOG_TEXT_FONT_NAME;
        format.color = DIALOG_COLOR_INPUT_TEXT;
        format.align = TextFormatAlign.LEFT;
        textField.defaultTextFormat = format;
        textField.width = 567.0;
        textField.height = 50.0;
        return textField;
    }

    private function buildDescriptionLabel(defaultText:String):TextField {
        var textField:TextField = new TextField();
        textField.border = false;
        var format:TextFormat = new TextFormat();
        format.size = 40;
        format.font = DIALOG_TEXT_FONT_NAME;
        format.align = TextFormatAlign.LEFT;
        textField.defaultTextFormat = format;
        textField.text = defaultText;
        textField.width = 510.0;
        textField.height = 50.0;
        return textField;
    }

    private function buildButtonsBackground():Sprite {
        var sprite:Sprite = new Sprite();
        sprite.graphics.lineStyle(1, DIALOG_COLOR_INPUT_TEXT);
        sprite.graphics.lineTo(DIALOG_WIDTH, 0.0);
        sprite.graphics.moveTo(DIALOG_WIDTH / 2, 0.0);
        sprite.graphics.lineTo(DIALOG_WIDTH / 2, 89.0);
        return sprite;
    }

    private function buildButtonLabel(defaultText:String, isBold:Boolean):TextField {
        var textField:TextField = new TextField();
        textField.border = false;
        var format:TextFormat = new TextFormat();
        format.size = 35;
        format.font = DIALOG_TEXT_FONT_NAME;
        format.bold = isBold;
        format.color = DIALOG_COLOR_BUTTON;
        format.align = TextFormatAlign.CENTER;
        textField.defaultTextFormat = format;
        textField.text = defaultText;
        textField.width = 230.0;
        textField.height = 50.0;
        return textField;
    }

    private function buildButton(text:String, isBold:Boolean):SimpleButton {
        var width:Number = 230;
        var height:Number = 87;
        var button:SimpleButton = new SimpleButton();

        var stateUpSprite:Sprite = new Sprite();
        stateUpSprite.graphics.lineStyle(1, DIALOG_COLOR_INPUT_TEXT, 0.0);
        stateUpSprite.graphics.beginFill(DIALOG_COLOR_BACKGROUND, 1);
        stateUpSprite.graphics.drawRect(0, 0, width, height);
        var upLabel:TextField = buildButtonLabel(text, isBold);
        stateUpSprite.addChild(upLabel);
        upLabel.y = 20;
        stateUpSprite.graphics.endFill();

        var stateDownSprite:Sprite = new Sprite();
        stateDownSprite.graphics.lineStyle(1, DIALOG_COLOR_INPUT_TEXT, 0.0);
        stateDownSprite.graphics.beginFill(DIALOG_COLOR_BACKGROUND, 1);
        stateDownSprite.graphics.drawRect(0, 0, width, height);
        var downLabel:TextField = buildButtonLabel(text, isBold);
        stateDownSprite.addChild(downLabel);
        downLabel.y = 20;
        stateDownSprite.graphics.endFill();

        var hitArea:Sprite = new Sprite();
        hitArea.graphics.lineStyle(1, 0x555555);
        hitArea.graphics.beginFill(0xff000, 1);
        hitArea.graphics.drawRect(0, 0, width, height);
        hitArea.graphics.endFill();

        button.overState = button.upState = stateUpSprite;
        button.downState = stateDownSprite;
        button.hitTestState = hitArea;

        return button;
    }
}
}
