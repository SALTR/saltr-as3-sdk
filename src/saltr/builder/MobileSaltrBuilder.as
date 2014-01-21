/**
 * User: sarg
 * Date: 1/21/14
 * Time: 4:35 PM
 */
package saltr.builder {
import saltr.Saltr;
import saltr.repository.MobileRepository;
import saltr.repository.DummyRepository;

public class MobileSaltrBuilder {
    public function MobileSaltrBuilder() {
    }

    public static function create(instanceKey:String, enableCache:Boolean = true):Saltr {
        var saltrInstance:Saltr = new Saltr(instanceKey);
        saltrInstance.repository = enableCache ? new MobileRepository() : new DummyRepository();
        return saltrInstance;
    }
}
}
