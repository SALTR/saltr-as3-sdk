/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game {
public class SLTCompositeInstance extends SLTAssetInstance {
    private var _cells:Array;

    public function SLTCompositeInstance(token:String, stateIds:Vector.<SLTAssetState>, properties:Object, cells:Array) {
        super(token, stateIds, properties);
        _cells = cells;
    }

    public function get cells():Array {
        return _cells;
    }

}
}
