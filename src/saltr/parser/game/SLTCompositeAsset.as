/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.parser.game {
internal class SLTCompositeAsset extends SLTAsset {

    private var _cellInfos:Array;

    public function SLTCompositeAsset(token:String, cellInfos:Array, properties:Object) {
        super(token, properties);
        _cellInfos = cellInfos;
    }

    public function get cellInfos():Array {
        return _cellInfos;
    }
}
}
