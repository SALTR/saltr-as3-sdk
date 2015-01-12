/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {
import saltr.game.SLTAssetInstance;
import saltr.game.SLTAssetState;

/**
 * The SLTCompositeInstance class represents the cells composition to single instance.
 */
public class SLTCompositeInstance extends SLTAssetInstance {
    private var _cells:Array;

    /**
     * Class constructor.
     * @param token The identifier.
     * @param stateIds The state identifiers.
     * @param properties The properties.
     * @param cells The composed cells.
     */
    public function SLTCompositeInstance(token:String, stateIds:Vector.<SLTAssetState>, properties:Object, cells:Array) {
        super(token, stateIds, properties);
        _cells = cells;
    }

    /**
     * The composed cells.
     */
    public function get cells():Array {
        return _cells;
    }

}
}
