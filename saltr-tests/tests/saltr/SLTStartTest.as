/**
* Created by TIGR on 4/16/2015.
*/
package tests.saltr {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.SLTSaltrMobileOld;
import saltr.repository.SLTMobileRepository;
import saltr.repository.SLTRepositoryStorageManager;

/**
* The SLTStartTest class contain the saltr.start() method tests
*/
public class SLTStartTest {
    [Embed(source="../../../build/tests/saltr/app_data_cache.json", mimeType="application/octet-stream")]
    private static const AppDataCacheJson:Class;

    private var clientKey:String = "";
    private var deviceId:String = "";
    private var _saltr:SLTSaltrMobileOld;

    [Rule]
    public var mocks:MockolateRule = new MockolateRule();
    [Mock(type="nice")]
    public var mobileRepository:SLTMobileRepository;

    public function SLTStartTest() {
    }

    [After]
    public function tearDown():void {
        _saltr = null;
    }

    /**
     * startWithDeviceIdNullCheck.
     * The intent of this test is to check the start() with deviceId = null. An error should be thrown.
     */
    [Test(expects="Error")]
    public function startWithDeviceIdNullCheck():void {
        _saltr = new SLTSaltrMobileOld(FlexUnitRunner.STAGE, clientKey, null);
        _saltr.start();
    }

    /**
     * startWithAppDataInitEmptyCheck.
     * The intent of this test is to check the start() which will call appdata.initEmpty().
     */
    [Test]
    public function startWithAppDataInitEmptyCheck():void {
        stub(mobileRepository).method("getObjectFromCache").returns(null);
        _saltr = new SLTSaltrMobileOld(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.repository = mobileRepository;
        _saltr.start();
        var testPassed:Boolean = true;
        if (0 != _saltr.experiments.length || 0 != _saltr.getActiveFeatureTokens().length || null != _saltr.getFeatureProperties("token")) {
            testPassed = false;
        }
        assertEquals(true, testPassed);
    }

    /**
     * startWithAppDataInitWithDataCheck.
     * The intent of this test is to check the start() which will call appdata.initWithData().
     */
    [Test]
    public function startWithAppDataInitWithDataCheck():void {
        stub(mobileRepository).method("getObjectFromCache").returns(JSON.parse(new AppDataCacheJson()));
        _saltr = new SLTSaltrMobileOld(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.repository = mobileRepository;
        _saltr.start();
        assertEquals(1, _saltr.experiments.length);
    }
}
}
