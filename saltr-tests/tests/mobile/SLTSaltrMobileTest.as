/**
 * Created by TIGR on 4/10/2015.
 */
package tests.mobile {
import mockolate.runner.MockolateRule;

import org.flexunit.asserts.assertNull;

import saltr.SLTSaltrMobile;
import saltr.game.SLTLevel;
import saltr.repository.SLTMobileRepository;

public class SLTSaltrMobileTest {
    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]//[Mock(type="strict")]
    public var mobileRepository:SLTMobileRepository;

    private var clientKey:String = "";
    private var deviceId:String = "";
    private var _saltr:SLTSaltrMobile;

    public function SLTSaltrMobileTest() {
    }

    [Before]
    public function tearUp():void {
        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.repository = mobileRepository;
    }

    [After]
    public function tearDown():void {
        _saltr = null;
    }

    [Test]
    public function saltrImportLevelsTest():void {
        //_saltr.start();
        //_saltr.useNoFeatures = true;
        //_saltr.importLevels("D:\Projects\dev\as\plexonic\libs\saltr-as3-sdk\build\tests");

//        var level:SLTLevel = _saltr.getLevelByGlobalIndex(-1);
//        assertNull(level);
    }
}
}
