/**
 * Created by Tigran Hakobyan on 2/13/2015.
 */
package saltr.utils.dialog {
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.Stage;
import flash.errors.IllegalOperationError;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import saltr.saltr_internal;
import saltr.utils.SLTUtils;

use namespace saltr_internal;


/**
 * The SLTRegistrationDialog class represents the registration dialog.
 * @private
 */
public class SLTRegistrationDialog extends Sprite {
    /**
     * Specifies the submit button's text.
     */
    internal static const DLG_BUTTON_SUBMIT:String = "Submit";

    /**
     * Specifies the cancel button's text.
     */
    internal static const DLG_BUTTON_CANCEL:String = "Cancel";

    /**
     * Specifies the wrong email text.
     */
    internal static const DLG_EMAIL_NOT_VALID:String = "Please insert valid Email.";

    /**
     * Specifies the successful transmission text.
     */
    internal static const DLG_SUBMIT_SUCCESSFUL:String = "Your data has been successfully submitted.";

    /**
     * Specifies the failed transmission text.
     */
    internal static const DLG_SUBMIT_FAILED:String = "Your data has not been submitted.";

    /**
     * Specifies the wrong submit callback function text.
     */
    internal static const DLG_ERROR_SUBMIT_FUNC:String = "Submit function should have email parameter.";

    /**
     * Specifies the email prompting text.
     */
    internal static const DLG_PROMPT_EMAIL:String = "example@mail.com";

    protected static const DESIGNED_SCREEN_WIDTH:Number = 750;
    protected static const DIALOG_WIDTH:Number = 649.0;
    protected static const DIALOG_HEIGHT:Number = 355.0;

    protected static const DIALOG_COLOR_BACKGROUND:uint = 0xe7e7e7;
    protected static const DIALOG_TEXT_FONT_NAME:String = "Helvetica Neue";
    protected static const DIALOG_COLOR_INPUT_TEXT:uint = 0x999999;
    protected static const DIALOG_COLOR_BUTTON:Object = 0x549ef4;

    protected var _flashStage:Stage;
    protected var _submitSuccessCallback:Function;
    protected var _statusTextField:TextField;
    protected var _isShown:Boolean;

    /**
     * Class constructor.
     * @param flashStage The flash stage.
     */
    public function SLTRegistrationDialog(flashStage:Stage) {
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
            addToStage();
            _isShown = true;
        }
    }

    protected function buildView():void {
        var screenWidth:uint = getScreenWidth();
        var screenHeight:uint = getScreenHeight();
        var dialogWidth:Number = DIALOG_WIDTH;
        var dialogHeight:Number = DIALOG_HEIGHT;
        var scaleFactor:Number = getScaleFactor();

        var dialogX:Number = (screenWidth - dialogWidth * scaleFactor) / 2;
        var dialogY:Number = (screenHeight - dialogHeight * scaleFactor) / 2;

        var descriptionLabel:TextField = buildDescriptionLabel();
        descriptionLabel.x = 36.0;
        descriptionLabel.y = 38.0;

        var emailBackground:Sprite = buildEmailBackground();
        emailBackground.x = 42.0;
        emailBackground.y = 107.0;

        buildEmailInputTextField();

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

    protected function addToStage():void {
        _flashStage.addChild(this);
    }

    /**
     * Disposes the dialog.
     */
    saltr_internal function dispose():void {
        _flashStage.removeChild(this);
        this.removeChildren();
        _statusTextField = null;
        _isShown = false;
    }

    protected function getScreenWidth():Number {
        throw new IllegalOperationError("getScreenWidth is Pure Virtual");
    }

    protected function getScreenHeight():Number {
        throw new IllegalOperationError("getScreenHeight is Pure Virtual");
    }
    protected function getScaleFactor():Number {
        throw new IllegalOperationError("getScaleFactor is Pure Virtual");
    }

    private function validateDeviceRegistrationSubmitCallback(callback:Function):Boolean {
        return callback != null && callback.length == 1;
    }

    private function buildDescriptionLabel():TextField {

        var textField:TextField = new TextField();
        textField.border = false;
        var format:TextFormat = new TextFormat();
        format.size = 40;
        format.font = DIALOG_TEXT_FONT_NAME;
        format.align = TextFormatAlign.LEFT;
        textField.defaultTextFormat = format;
        textField.text = getDescriptionDefaultText();
        textField.width = 510.0;
        textField.height = 50.0;
        return textField;
    }

    protected function getDescriptionDefaultText():String {
        throw new IllegalOperationError("getDescriptionDefaultText is Pure Virtual");
    }

    protected function getEmailText():String {
        throw new IllegalOperationError("getEmailText is Pure Virtual");
    }

    private function buildEmailBackground():Sprite {
        var sprite:Sprite = new Sprite();
        sprite.graphics.lineStyle(1, DIALOG_COLOR_INPUT_TEXT);
        sprite.graphics.beginFill(0xFFFFFF, 1);
        sprite.graphics.drawRect(0, 0, 567.0, 73.0);
        sprite.graphics.endFill();
        return sprite;
    }

    protected function buildEmailInputTextField():void {
        new IllegalOperationError("buildEmailInputTextField is Pure Virtual");
    }

    protected function setStatus(text:String):void {
        new IllegalOperationError("setStatus is Pure Virtual");
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

    private function btnCancelHandler(event:MouseEvent):void {
        event.target.removeEventListener(MouseEvent.CLICK, btnCancelHandler);
        dispose();
    }

    private function btnSubmitHandler(event:MouseEvent):void {
        var submittedEmailText:String = getEmailText();

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

    private function getDeviceRegistrationSubmittedValuesValidationResults(email:String):Object {
        var isEmailValid:Boolean = (email.indexOf(DLG_PROMPT_EMAIL) == -1) && SLTUtils.checkEmailValidation(email);

        var notificationText:String = "";
        if (!isEmailValid) {
            notificationText = DLG_EMAIL_NOT_VALID;
        }

        return {
            isValid: isEmailValid,
            notificationText: notificationText
        }
    }
}
}
