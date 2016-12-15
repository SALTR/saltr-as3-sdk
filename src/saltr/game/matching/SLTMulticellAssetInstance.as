/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {
import flash.geom.Point;

import saltr.game.SLTAssetInstance;
import saltr.game.SLTAssetState;

/**
 * The SLTMultiCellAssetInstance class represents the cells composition to single instance.
 */
public class SLTMultiCellAssetInstance extends SLTAssetInstance {
    private var _cells:Array;
    private var _startPoint:Point;

    /**
     * Class constructor.
     * @param token The identifier.
     * @param stateId The state identifier.
     * @param properties The properties.
     * @param cells The composed cells.
     * @param startPoint MultiCell asset start point.
     * @param positions The alt positions of the asset
     */
    public function SLTMultiCellAssetInstance(token:String, state:SLTAssetState, properties:Object, cells:Array, startPoint:Point, positions:Array = null) {
        super(token, state, properties, positions);
        _cells = cells;
        _startPoint = startPoint;
    }

    /**
     * The composed cells.
     */
    public function get cells():Array {
        return _cells;
    }

    public function get startPoint():Point {
        return _startPoint;
    }
}
}
