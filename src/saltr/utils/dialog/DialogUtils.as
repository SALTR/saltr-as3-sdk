/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.utils.dialog {
import flash.events.TimerEvent;
import flash.utils.Timer;

public class DialogUtils {
    public static const DLG_TIMER:int = 2000;

    public function DialogUtils() {
    }

    public static function showDialogAfterDelay(dlgReg:IDialog):void {
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
