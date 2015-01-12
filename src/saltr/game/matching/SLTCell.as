/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {

import flash.utils.Dictionary;

import saltr.game.SLTAssetInstance;

/**
 * The SLTCell class represents the matching board cell.
 */
public class SLTCell {
    private var _col:int;
    private var _row:int;
    private var _properties:Object;
    private var _isBlocked:Boolean;
    private var _instancesByLayerId:Dictionary;
    private var _instancesByLayerIndex:Dictionary;

    /**
     * Class constructor.
     * @param col The column of the cell.
     * @param row The row of the cell.
     */
    public function SLTCell(col:int, row:int) {
        _col = col;
        _row = row;
        _properties = {};
        _isBlocked = false;
        _instancesByLayerId = new Dictionary();
        _instancesByLayerIndex = new Dictionary();
    }

    /**
     * The column of the cell.
     */
    public function get col():int {
        return _col;
    }

    /**
     * @private
     */
    public function set col(value:int):void {
        _col = value;
    }

    /**
     * The row of the cell.
     */
    public function get row():int {
        return _row;
    }

    /**
     * @private
     */
    public function set row(value:int):void {
        _row = value;
    }

    /**
     * The properties of the cell.
     */
    public function get properties():Object {
        return _properties;
    }

    /**
     * The blocked state of the cell.
     */
    public function get isBlocked():Boolean {
        return _isBlocked;
    }

    /**
     * @private
     */
    public function set isBlocked(value:Boolean):void {
        _isBlocked = value;
    }

    /**
     * @private
     */
    public function set properties(value:Object):void {
        _properties = value;
    }

    /**
     * Gets the asset instance by layer identifier.
     * @param layerId The layer identifier.
     * @return SLTAssetInstance The asset instance that is positioned in the cell in the layer specified by layerId.
     */
    public function getAssetInstanceByLayerId(layerId:String):SLTAssetInstance {
        return _instancesByLayerId[layerId];
    }

    /**
     * Gets the asset instance by layer index.
     * @param layerIndex The layer index.
     * @return SLTAssetInstance The asset instance that is positioned in the cell in the layer specified by layerIndex.
     */
    public function getAssetInstanceByLayerIndex(layerIndex:int):SLTAssetInstance {
        return _instancesByLayerIndex[layerIndex];
    }

    /**
     * Sets the asset instance with provided layer identifier and layer index.
     * @param layerId The layer identifier.
     * @param layerIndex The layer index.
     * @param assetInstance The asset instance.
     */
    public function setAssetInstance(layerId:String, layerIndex:int, assetInstance:SLTAssetInstance):void {
        if (_isBlocked == false) {
            _instancesByLayerId[layerId] = assetInstance;
            _instancesByLayerIndex[layerIndex] = assetInstance;
        }
    }

    /**
     * Removes the asset instance with provided layer identifier and layer index.
     * @param layerId The layer identifier.
     * @param layerIndex The layer index.
     */
    public function removeAssetInstance(layerId:String, layerIndex:int):void {
        delete _instancesByLayerId[layerId];
        delete _instancesByLayerIndex[layerIndex];
    }
}
}
