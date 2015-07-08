/**
 * Created by TIGR on 7/8/2015.
 */
package saltr.game {
import flash.utils.Dictionary;

import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTCheckPointParser {
    public function SLTCheckPointParser() {
    }

    saltr_internal static function parseCheckpoints(rootNode:Object):Dictionary {
        var checkpoints:Dictionary = new Dictionary();
        if (rootNode.hasOwnProperty("checkpoints")) {
            var checkpointsNode:Array = rootNode.checkpoints;
            for each(var checkpoint:Object in checkpointsNode) {
                checkpoints[checkpoint.token] = new SLTCheckpoint(checkpoint.token, checkpoint.orientation, checkpoint.position);
            }
        }
        return checkpoints;
    }
}
}
