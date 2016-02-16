/**
 * Created by daal on 2/12/16.
 */
package saltr {
import flash.utils.Dictionary;

use namespace saltr_internal;

public class SLTFeatureValidator {

    private var _validators:Dictionary;

    public function SLTFeatureValidator() {
        _validators = new Dictionary()
    }

    public function addValidator(featureToken:String, validator:Function):void {
        _validators[featureToken] = validator;
    }

    public function validate(feature:SLTFeature):Boolean {
        var validateFunction:Function = _validators[feature.token];
        if (validateFunction) {
            return validateFunction(feature.properties);
        } else {
            return true;
        }
    }
}
}