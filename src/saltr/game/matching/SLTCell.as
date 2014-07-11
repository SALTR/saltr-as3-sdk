/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {

import flash.utils.Dictionary;

import saltr.game.SLTAssetInstance;

public class SLTCell {
    private var _col:int;
    private var _row:int;
    private var _properties:Object;
    private var _isBlocked:Boolean;
    private var _instancesByLayerId:Dictionary;
    private var _instancesByLayerIndex:Dictionary;

    public function SLTCell(col:int, row:int) {
        _col = col;
        _row = row;
        _properties = {};
        _isBlocked = false;
        _instancesByLayerId = new Dictionary();
        _instancesByLayerIndex = new Dictionary();
    }

    public function get col():int {
        return _col;
    }

    public function set col(value:int):void {
        _col = value;
    }

    public function get row():int {
        return _row;
    }

    public function set row(value:int):void {
        _row = value;
    }

    public function get properties():Object {
        return _properties;
    }

    public function get isBlocked():Boolean {
        return _isBlocked;
    }

    public function set isBlocked(value:Boolean):void {
        _isBlocked = value;
    }

    public function set properties(value:Object):void {
        _properties = value;
    }

    public function getAssetInstanceByLayerId(layerId:String):SLTAssetInstance {
        return _instancesByLayerId[layerId];
    }

    public function getAssetInstanceByLayerIndex(layerIndex:int):SLTAssetInstance {
        return _instancesByLayerIndex[layerIndex];
    }

    public function setAssetInstance(layerId:String, layerIndex:int, assetInstance:SLTAssetInstance):void {
        if (_isBlocked == false) {
            _instancesByLayerId[layerId] = assetInstance;
            _instancesByLayerIndex[layerIndex] = assetInstance;
        }
    }

    public function removeAssetInstance(layerId:String, layerIndex:int):void {
        delete _instancesByLayerId[layerId];
        delete _instancesByLayerIndex[layerIndex];
    }
}
}
