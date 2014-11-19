/**
 * User: kron
 * Date: 29/09/2014
 * Time: 05:34
 */

package saltr.utils.dialog {

import flash.events.Event;

//TODO: @Tigr remove later
public class Dialogs {

    private static var _instance:Dialogs;
    private var _dlgDeviceReg:DeviceRegistrationDialog;


    public function Dialogs() {
    }

    public static function getInstance():Dialogs {
        if (!_instance) {
            _instance = new Dialogs();
        }
        return _instance;
    }






}
}

