/**
 * Created by daal on 2/12/16.
 */
package saltr {
import flash.utils.Dictionary;

public class FeatureValidator {

    private var _validators:Dictionary;

    public function FeatureValidator() {
        _validators = new Dictionary()
    }

    public function addValidator(featureToken:String, validator:Function):void {
        _validators[featureToken] = validator;
    }
}
}
