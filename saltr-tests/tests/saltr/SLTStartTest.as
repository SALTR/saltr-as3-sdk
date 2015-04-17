/**
 * Created by TIGR on 4/16/2015.
 */
package tests.saltr {
import saltr.SLTSaltrMobile;

/**
 * The SLTStartTest class contain the saltr.start() method tests
 */
public class SLTStartTest {
    private var clientKey:String = "";
    private var deviceId:String = "";
    private var _saltr:SLTSaltrMobile;

    public function SLTStartTest() {
    }

    [Before]
    public function tearUp():void {
        //_saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
    }

    [After]
    public function tearDown():void {
        //_saltr = null;
    }

    /**
     * startWithDeviceIdNullCheck.
     * The intent of this test is to check the start() with deviceId = null. An error should be thrown.
     */
    [Test(expects="Error")]
    public function startWithDeviceIdNullCheck():void {
        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, null);
        _saltr.start();
        _saltr = null;
    }

    /**
     * startWithDeviceIdNullCheck.
     * The intent of this test is to check the start() with deviceId = null. An error should be thrown.
     */
    [Test(expects="Error")]
    public function startWithDeveloperFeaturesCheck():void {
        //@TIGR todo continue here
        _saltr = new SLTSaltrMobile(FlexUnitRunner.STAGE, clientKey, deviceId);
        _saltr.start();
        _saltr = null;
    }
}
}
