/**
 * Created by TIGR on 5/7/2015.
 */
package tests.saltr.api {
import saltr.resource.SLTResource;
import saltr.resource.SLTResourceURLTicket;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTResourceMock extends SLTResource {
    public function SLTResourceMock() {
        var ticket:SLTResourceURLTicket = new SLTResourceURLTicket("url");
        super("apiCall", ticket, null, null);
    }

    override saltr_internal function get jsonData():Object {
        return getResponseJsonData();
    }

    public function getResponseJsonData():Object {
        return {};
    }

}
}
