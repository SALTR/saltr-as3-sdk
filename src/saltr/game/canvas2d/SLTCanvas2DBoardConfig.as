package saltr.game.canvas2d {
import flash.utils.Dictionary;

import saltr.saltr_internal;

use namespace saltr_internal;


public class SLTCanvas2DBoardConfig {

    private var _layers : Vector.<SLT2DBoardLayer>;
    private var _height:Number;
    private var _width:Number;
    private var _assetMap:Dictionary;

    public function SLTCanvas2DBoardConfig(layers:Vector.<SLT2DBoardLayer>, boardNode:Object, assetMap : Dictionary) {
        _layers = layers;
        _width = boardNode.width;
        _height = boardNode.height;
        _assetMap = assetMap;
    }

    public function get layers():Vector.<SLT2DBoardLayer> {
        return _layers;
    }

    public function get height():Number {
        return _height;
    }

    public function get width():Number {
        return _width;
    }

    public function get assetMap():Dictionary {
        return _assetMap;
    }
}


}