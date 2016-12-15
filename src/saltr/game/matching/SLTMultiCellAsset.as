/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {

import flash.geom.Point;
import flash.utils.Dictionary;

import saltr.game.SLTAsset;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTMultiCellAsset extends SLTAsset {

    private var _cells:Array;
    private var _startPoint:Point;

    public function SLTMultiCellAsset(token:String, cells:Array, startPoint:Array,  stateNodesMap:Dictionary, properties:Object) {
        super(token, stateNodesMap, properties);
        _cells = cells;
        _startPoint = new Point(startPoint[0], startPoint[1]);
    }

    public function get cells():Array {
        return _cells;
    }

    internal function get startPoint():Point {
        return _startPoint;
    }
}
}
