/**
 * Created by Tigran Hakobyan on 2/13/2015.
 */
package saltr.utils.dialog {
import flash.display.Stage;

import saltr.saltr_internal;

use namespace saltr_internal;

public class MobileDialogController extends DialogController {
    public function MobileDialogController(flashStage:Stage, registrationCallback:Function) {
        super(flashStage, registrationCallback);
    }

    override protected function createRegistrationDialog():RegistrationDialog {
        return new MobileRegistrationDialog(_flashStage);
    }

    override protected function getRegistrationFailTitle():String {
        return AlertDialog.DLG_DEVICE_REGISTRATION_TITLE;
    }
}
}