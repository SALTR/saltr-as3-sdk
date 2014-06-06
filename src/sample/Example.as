/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package sample {
import flash.display.Sprite;

import saltr.status.SLTStatus;

import saltr.SLTSaltrMobile;

public class Example extends Sprite {

    private static var clientKey:String = "08626247-f03d-0d83-b69f-4f03f80ef555";
    private var _saltrMobile:SLTSaltrMobile;

    public function Example() {


        connectToSalt();
    }

    private function connectToSalt():void {
        _saltrMobile = new SLTSaltrMobile(clientKey);
        _saltrMobile.deviceId = "kshdkashdkashdkashdkashd";
        _saltrMobile.connect(saltrLoadSuccessCallback, saltrLoadFailCallback);
    }


    private function saltrLoadSuccessCallback():void {
        trace("[saltrLoadSuccessCallback]");
    }

    private function saltrLoadFailCallback(status:SLTStatus):void {
        trace("[saltrLoadFailCallback]");
    }


}
}
