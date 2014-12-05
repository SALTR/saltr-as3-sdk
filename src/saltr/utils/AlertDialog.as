/**
 * Created by TIGR on 12/4/14.
 */
package saltr.utils {
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class AlertDialog extends Sprite {
    public static const DLG_DEVICE_REGISTRATION_TITLE:String = "Device Registration";

    private static const DLG_BUTTON_CLOSE:String = "OK";

    private static const DIALOG_TEXT_FONT_NAME:String = "Helvetica Neue";
    private static const DIALOG_COLOR_BACKGROUND:uint = 0xe7e7e7;
    private static const DIALOG_COLOR_INPUT_TEXT:uint = 0x999999;

    private static const DESIGNED_SCREEN_WIDTH:Number = 750;
    private static const DIALOG_WIDTH:Number = 649.0;
    private static const DIALOG_HEIGHT:Number = 355.0;
    private static const DIALOG_COLOR_BUTTON:Object = 0x549ef4;

    private var _flashStage:Stage;
    private var _isShown:Boolean;
    private var _buttonOkCallback:Function;
    private var _alertTextField:TextField;

    public function AlertDialog(flashStage:Stage) {
        _flashStage = flashStage;
    }

    public function show(title:String, message:String, buttonOkCallback:Function = null):void {
        if (!_isShown) {
            _buttonOkCallback = buttonOkCallback;
            buildView(title, message);
            _flashStage.addChild(this);
            _isShown = true;
        }
    }

    public function dispose():void {
        _flashStage.removeChild(this);
        this.removeChildren();
        _alertTextField = null;
        _isShown = false;
    }

    private function buildView(title:String, message:String):void {
        var screenWidth:uint = _flashStage.fullScreenWidth;
        var screenHeight:uint = _flashStage.fullScreenHeight;
        var dialogWidth:Number = DIALOG_WIDTH;
        var dialogHeight:Number = DIALOG_HEIGHT;
        var scaleFactor:Number = getScaleFactor();

        var dialogX:Number = (screenWidth - dialogWidth * scaleFactor) / 2;
        var dialogY:Number = (screenHeight - dialogHeight * scaleFactor) / 2;

        var descriptionLabel:TextField = buildDescriptionLabel(title);
        descriptionLabel.x = 36.0;
        descriptionLabel.y = 38.0;

        _alertTextField = buildAlertTextField(message);
        _alertTextField.x = 42.0;
        _alertTextField.y = 107.0;

        var buttonBackground:Sprite = buildButtonBackground();
        buttonBackground.x = 0.0;
        buttonBackground.y = 267.0;

        var btnClose:SimpleButton = buildButton(DLG_BUTTON_CLOSE, true);

        btnClose.addEventListener(MouseEvent.CLICK, btnCloseHandler);
        btnClose.x = (DIALOG_WIDTH / 2) - (230 / 2);
        btnClose.y = 268;

        this.graphics.beginFill(DIALOG_COLOR_BACKGROUND, 1);
        this.graphics.drawRect(0, 0, dialogWidth, dialogHeight);
        this.addChild(descriptionLabel);
        this.addChild(_alertTextField);
        this.addChild(buttonBackground);
        this.addChild(btnClose);
        this.graphics.endFill();

        this.x = dialogX;
        this.y = dialogY;

        this.scaleX = this.scaleY = scaleFactor;
    }

    private function getScaleFactor():Number {
        return Math.min(_flashStage.fullScreenWidth / DESIGNED_SCREEN_WIDTH, 1.0);
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

    private function buildAlertTextField(text:String):TextField {
        var textField:TextField = new TextField();
        textField.border = false;
        var format:TextFormat = new TextFormat();
        format.size = 35;
        format.leftMargin = 19;
        format.font = DIALOG_TEXT_FONT_NAME;
        format.color = DIALOG_COLOR_INPUT_TEXT;
        format.align = TextFormatAlign.LEFT;
        textField.defaultTextFormat = format;
        textField.multiline = true;
        textField.wordWrap = true;
        textField.width = 567.0;
        textField.height = 140.0;
        textField.text = text;
        return textField;
    }

    private function buildButtonBackground():Sprite {
        var sprite:Sprite = new Sprite();
        sprite.graphics.lineStyle(1, DIALOG_COLOR_INPUT_TEXT);
        sprite.graphics.lineTo(DIALOG_WIDTH, 0.0);
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

    private function btnCloseHandler(event:MouseEvent):void {
        dispose();
        if(null != _buttonOkCallback) {
            _buttonOkCallback();
        }
    }
}
}
