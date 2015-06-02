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
public class SLTMobileDialogController extends SLTDialogController {
    public function SLTMobileDialogController(flashStage:Stage, registrationCallback:Function) {
        super(flashStage, registrationCallback);
    }

    override protected function createRegistrationDialog():SLTRegistrationDialog {
        return new SLTMobileRegistrationDialog(_flashStage);
    }

    override protected function getRegistrationFailTitle():String {
        return SLTAlertDialog.DLG_DEVICE_REGISTRATION_TITLE;
    }
}
}