/**
 * Created by TIGR on 4/10/2015.
 */
package tests.saltr {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNull;

import saltr.SLTSaltrMobile;
import saltr.game.SLTLevel;
import saltr.game.SLTLevelPack;
import saltr.repository.SLTMobileRepository;

/**
 * The SLTSaltrMobileTest class contain the tests which can be performed without saltr.connect()
 */
public class SLTImportLevelsTest {
    [Embed(source="../../../build/tests/saltr/level_packs.json", mimeType="application/octet-stream")]
    private static const AppDataJson:Class;


    private static const localData:Class;
    private static const customPathData:Class;
    private static const appData:Class;


    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var mobileRepository:SLTMobileRepository;

    private var clientKey:String = "";
    private var deviceId:String = "";
    private var _saltr:SLTSaltrMobile;

    public function SLTImportLevelsTest() {
    }

    [Before]
    public function tearUp():void {
        stub(mobileRepository).method("getObjectFromApplication").returns(JSON.parse(new AppDataJson()));
        stub(mobileRepository).method("getObjectFromCache").returns(JSON.parse(new customPathData()));
        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.repository = mobileRepository;
    }

    [After]
    public function tearDown():void {
        _saltr = null;
    }

    /**
     * allLevelsTest.
     * The intent of this test is to check the levels importing.
     * Mobile repository's getObjectFromApplication() mocked in order to provide levels data
     */
    [Test]
    public function importLevelsTest():void {
        //_saltr.importLevels(path);
    }
}
}
