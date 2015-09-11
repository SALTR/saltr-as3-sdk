/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {
import saltr.game.SLTAssetInstance;
import saltr.game.SLTAssetState;

/**
 * The SLTCompositeInstance class represents the cells composition to single instance.
 * @private
 */
public class SLTCompositeInstance extends SLTAssetInstance {
    private var _cells:Array;

    /**
     * Class constructor.
     * @param token The identifier.
     * @param stateId The state identifier.
     * @param properties The properties.
     * @param cells The composed cells.
     */
    public function SLTCompositeInstance(token:String, state:SLTAssetState, properties:Object, cells:Array) {
        super(token, state, properties);
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
