/**
 * Created by TIGR on 4/10/2015.
 */
package tests.mobile {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertNotNull;

import org.flexunit.asserts.assertNull;

import saltr.SLTSaltrMobile;
import saltr.game.SLTLevel;
import saltr.repository.SLTMobileRepository;

public class SLTSaltrMobileTest {
    [Embed(source = "D:/Projects/dev/as/plexonic/libs/saltr-as3-sdk/build/tests/saltr/level_packs.json", mimeType="application/octet-stream")]
    private static const AppDataJson:Class;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var mobileRepository:SLTMobileRepository;

    private var clientKey:String = "";
    private var deviceId:String = "";
    private var _saltr:SLTSaltrMobile;
    private var _fileStream:FileStream;

    public function SLTSaltrMobileTest() {
    }

    [Before]
    public function tearUp():void {
        _fileStream = new FileStream();
        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.repository = mobileRepository;
        stub(mobileRepository).method("getObjectFromApplication").returns(getJson(new AppDataJson()));
    }

    [After]
    public function tearDown():void {
        _saltr = null;
    }

    [Test]
    public function saltrImportLevelsTest():void {
        _saltr.importLevels("Levels Path");

        var level:SLTLevel = _saltr.getLevelByGlobalIndex(1);
        assertNotNull(level);
    }

    private function getJson(stringData:String):Object {
        return JSON.parse(stringData);
    }
}
}
