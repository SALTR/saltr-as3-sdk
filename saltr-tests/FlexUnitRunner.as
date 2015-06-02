/**
 * Created by TIGR on 2/27/2015.
 */
package {
import flash.display.Sprite;
import flash.display.Stage;

import org.flexunit.internals.TraceListener;
import org.flexunit.listeners.AirCIListener;
import org.flexunit.runner.FlexUnitCore;

import tests.saltr.SLTAppDataTest;
import tests.saltr.SLTLevelDataTest;
import tests.saltr.SLTImportLevelsMobileTest;
import tests.saltr.SLTLoadLevelContentMobileTest;
import tests.saltr.SLTSaltrMobileTest;
import tests.saltr.SLTSaltrMobileTestWithConnection;
import tests.saltr.SLTSaltrWebTest;
import tests.saltr.SLTStartTest;
import tests.saltr.api.SLTAddPropertiesApiCallTest;
import tests.saltr.api.SLTAppDataApiCallTest;
import tests.saltr.api.SLTHeartbeatApiCallTest;
import tests.saltr.api.SLTLevelContentApiCallTest;
import tests.saltr.api.SLTRegisterDeviceApiCallTest;
import tests.saltr.api.SLTRegisterUserApiCallTest;
import tests.saltr.api.SLTSendLevelEndApiCallTest;
import tests.saltr.api.SLTSyncApiCallTest;
import tests.saltr.game.SLTLevelTest;
import tests.saltr.game.canvas2d.SLT2DAssetInstanceTest;
import tests.saltr.game.matching.SLTCellTest;
import tests.saltr.game.matching.SLTCellsTest;

public class FlexUnitRunner extends Sprite {

    public static var STAGE:Stage;

    public function FlexUnitRunner() {
        onCreationComplete();
    }

    private function onCreationComplete():void {
        STAGE = stage;
        var core:FlexUnitCore = new FlexUnitCore();
        core.addListener(new TraceListener());
        core.addListener(new AirCIListener());
        core.visualDisplayRoot = STAGE;
        core.run(currentRunTestSuite());
    }

    public function currentRunTestSuite():Array {
        var testsToRun:Array = new Array();
        testsToRun.push(SLTSaltrMobileTest);
        testsToRun.push(SLTImportLevelsMobileTest);
        testsToRun.push(SLTStartTest);
        testsToRun.push(SLTAppDataTest);
        testsToRun.push(SLTLevelDataTest);
        testsToRun.push(SLTCellTest);
        testsToRun.push(SLTCellsTest);
        testsToRun.push(SLTSaltrMobileTestWithConnection);
        testsToRun.push(SLTLoadLevelContentMobileTest);
        testsToRun.push(SLTLevelTest);
        testsToRun.push(SLT2DAssetInstanceTest);
        testsToRun.push(SLTAddPropertiesApiCallTest);
        testsToRun.push(SLTAppDataApiCallTest);
        testsToRun.push(SLTHeartbeatApiCallTest);
        testsToRun.push(SLTLevelContentApiCallTest);
        testsToRun.push(SLTRegisterDeviceApiCallTest);
        testsToRun.push(SLTRegisterUserApiCallTest);
        testsToRun.push(SLTSendLevelEndApiCallTest);
        testsToRun.push(SLTSyncApiCallTest);
        testsToRun.push(SLTSaltrWebTest);
        return testsToRun;
    }
}
}
