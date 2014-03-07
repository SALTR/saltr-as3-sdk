/**
 * User: sarg
 * Date: 1/21/14
 * Time: 4:35 PM
 */
package saltr.builder {
import saltr.SLTSaltr;
import saltr.repository.SLTDummyRepository;
import saltr.repository.SLTWebRepository;

public class SLTWebSaltrBuilder {
    public function SLTWebSaltrBuilder() {
    }

    public static function create(instanceKey:String, enableCache:Boolean = true):SLTSaltr {
        var saltrInstance:SLTSaltr = new SLTSaltr(instanceKey);
        saltrInstance.repository = enableCache ? new SLTWebRepository() : new SLTDummyRepository();
        return saltrInstance;
    }
}
}
