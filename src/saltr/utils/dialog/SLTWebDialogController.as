/**
 * Created by Tigran Hakobyan on 2/13/2015.
 */
package saltr.utils.dialog {
import flash.display.Stage;

import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTWebDialogController extends SLTDialogController {
    public function SLTWebDialogController(flashStage:Stage, registrationCallback:Function) {
        super(flashStage, registrationCallback);
    }

    override protected function createRegistrationDialog():SLTRegistrationDialog {
        return new SLTWebRegistrationDialog(_flashStage);
    }

    override protected function getRegistrationFailTitle():String {
        return SLTAlertDialog.DLG_USER_REGISTRATION_TITLE;
    }
}
}
