/**
 * User: haha
 * Date:  2015-04-10
 * Time: 5:29 PM
 */
package tests.status {

import flexunit.framework.Assert;

import saltr.status.SLTStatus;

public class SLTStatusSucessTest {
    public function SLTStatusSucessTest() {
    }

    [Test]
    public function testStatus():void {
        var status:SLTStatus = new SLTStatus(520, "Test Message");
        Assert.assertEquals("Test Message", status.statusMessage);
    }
}
}
