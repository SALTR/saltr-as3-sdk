/**
 * Created by TIGR on 7/8/2015.
 */
package saltr.game {
import flash.utils.Dictionary;

import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * @private
 */
public class SLTCheckPointParser {
    public function SLTCheckPointParser() {
    }

    saltr_internal static function parseCheckpoints(rootNode:Object):Dictionary {
        var checkpoints:Dictionary = new Dictionary();
        if (rootNode.hasOwnProperty("checkpoints")) {
            var checkpointsNode:Object = rootNode.checkpoints;
            for (var token:String in checkpointsNode) {
                var checkpointObject:Object = checkpointsNode[token];
                checkpoints[token] = new SLTCheckpoint(token, checkpointObject.orientation, checkpointObject.position);
            }
        }
        return checkpoints;
    }
}
}
