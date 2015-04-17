/**
 * Created by TIGR on 4/16/2015.
 */
package tests.saltr {
import mockolate.runner.MockolateRule;
import mockolate.stub;

import org.flexunit.asserts.assertEquals;

import saltr.SLTSaltrMobile;
import saltr.repository.SLTMobileRepository;

/**
 * The SLTStartTest class contain the saltr.start() method tests
 */
public class SLTStartTest {
    [Embed(source="../../../build/tests/saltr/app_data.json", mimeType="application/octet-stream")]
    private static const AppDataJson:Class;

    private var clientKey:String = "";
    private var deviceId:String = "";
    private var _saltr:SLTSaltrMobile;

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
        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, null);
        _saltr.start();
    }

    /**
     * startWithNoDeveloperFeaturesCheck.
     * The intent of this test is to check the start() without defined developer features. An error should be thrown.
     */
    [Test(expects="Error")]
    public function startWithNoDeveloperFeaturesCheck():void {
        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.start();
    }

    /**
     * startWithMissingLevelsCheck.
     * The intent of this test is to check the start() without imported levels. An error should be thrown.
     */
    [Test(expects="Error")]
    public function startWithMissingLevelsCheck():void {
        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.useNoFeatures = true;
        _saltr.start();
    }

    /**
     * startWithAppDataInitEmptyCheck.
     * The intent of this test is to check the start() which will call appdata.initEmpty().
     */
    [Test]
    public function startWithAppDataInitEmptyCheck():void {
        stub(mobileRepository).method("getObjectFromCache").returns(null);
        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.repository = mobileRepository;
        _saltr.useNoFeatures = true;
        _saltr.useNoLevels = true;
        _saltr.start();
        assertEquals(0, _saltr.experiments.length);
        assertEquals(0, _saltr.getActiveFeatureTokens().length);
        assertEquals(null, _saltr.getFeatureProperties("token"));
    }

    /**
     * startWithAppDataInitWithDataCheck.
     * The intent of this test is to check the start() which will call appdata.initWithData().
     */
    [Test]
    public function startWithAppDataInitWithDataCheck():void {
        stub(mobileRepository).method("getObjectFromCache").returns(JSON.parse(new AppDataJson()));
        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.repository = mobileRepository;
        _saltr.useNoFeatures = true;
        _saltr.useNoLevels = true;
        _saltr.start();
        assertEquals(1, _saltr.experiments.length);
    }
}
}
