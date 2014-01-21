/**
 * User: sarg
 * Date: 1/21/14
 * Time: 4:35 PM
 */
package saltr.builder {
import saltr.Saltr;
import saltr.repository.DummyRepository;
import saltr.repository.WebRepository;

public class WebSaltrBuilder {
    public function WebSaltrBuilder() {
    }

    public static function create(instanceKey:String, enableCache:Boolean = true):Saltr {
        var saltrInstance:Saltr = new Saltr(instanceKey);
        saltrInstance.repository = enableCache ? new WebRepository() : new DummyRepository();
        return saltrInstance;
    }
}
}
