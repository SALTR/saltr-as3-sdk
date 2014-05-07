/*
 * Copyright (c) 2014 Plexonic Ltd
 */

/**
 * User: sarg
 * Date: 11/9/12
 * Time: 4:51 PM
 */
package saltr.parser.game {
import flash.utils.Dictionary;

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

    public function get properties():Object {
        return _properties;
    }

    public function get isBlocked():Boolean {
        return _isBlocked;
    }

    public function get col():int {
        return _col;
    }

    public function get row():int {
        return _row;
    }

    public function set properties(value:Object):void {
        _properties = value;
    }

    public function set isBlocked(value:Boolean):void {
        _isBlocked = value;
    }

    public function set row(value:int):void {
        _row = value;
    }

    public function set col(value:int):void {
        _col = value;
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
            _instancesByLayerId[layerIndex] = assetInstance;
        }
    }
}
}
