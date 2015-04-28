/**
 * Created by TIGR on 2/27/2015.
 */
package tests.status {
import flexunit.framework.Assert;

import saltr.repository.SLTMobileRepository;

import saltr.status.SLTStatus;

public class SLTStatusTest {
//    public function SLTStatusTest() {
//    }

    [Test]
    public function testStatus():void {
//        var status:SLTStatus = new SLTStatus(520, "Test Message");
//        Assert.assertEquals("Test Message", status.statusMessage);

        var storage : SLTMobileRepository = new SLTMobileRepository();
        var a:SLTMobileRepository = null;
        Assert.assertNotNull(storage);
    }
}
}
