package saltr.game.canvas2d {
import flash.utils.Dictionary;

import saltr.saltr_internal;

use namespace saltr_internal;


internal class SLT2DBoardConfig {
    private var _layers:Dictionary;
    private var _height:Number;
    private var _width:Number;
    private var _assetMap:Dictionary;

    public function SLT2DBoardConfig(layers:Dictionary, boardNode:Object, assetMap:Dictionary) {
        _layers = layers;
        _width = boardNode.hasOwnProperty("width") ? boardNode.width : 0;
        _height = boardNode.hasOwnProperty("height") ? boardNode.height : 0;
        _assetMap = assetMap;
    }

    saltr_internal function get layers():Dictionary {
        return _layers;
    }

    saltr_internal function get height():Number {
        return _height;
    }

    saltr_internal function get width():Number {
        return _width;
    }

    saltr_internal function get assetMap():Dictionary {
        return _assetMap;
    }
}
}