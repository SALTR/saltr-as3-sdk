/**
 * User: sarg
 * Date: 1/21/14
 * Time: 4:35 PM
 */
package saltr.builder {
import saltr.SLTSaltr;
import saltr.repository.SLTMobileRepository;
import saltr.repository.SLTDummyRepository;

public class SLTMobileSaltrBuilder {
    public function SLTMobileSaltrBuilder() {
    }

    public static function create(instanceKey:String, enableCache:Boolean = true):SLTSaltr {
        var saltrInstance:SLTSaltr = new SLTSaltr(instanceKey);
        saltrInstance.repository = enableCache ? new SLTMobileRepository() : new SLTDummyRepository();
        return saltrInstance;
    }
}
}
