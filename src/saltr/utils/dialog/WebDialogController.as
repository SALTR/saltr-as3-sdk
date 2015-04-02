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
public class WebDialogController extends DialogController {
    public function WebDialogController(flashStage:Stage, registrationCallback:Function) {
        super(flashStage, registrationCallback);
    }

    override protected function createRegistrationDialog():RegistrationDialog {
        return new WebRegistrationDialog(_flashStage);
    }

    override protected function getRegistrationFailTitle():String {
        return AlertDialog.DLG_USER_REGISTRATION_TITLE;
    }
}
}
