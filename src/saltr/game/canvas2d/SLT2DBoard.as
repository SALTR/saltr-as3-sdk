/**
 * Created by GSAR on 7/10/14.
 */
package saltr.game.canvas2d {
import flash.utils.Dictionary;

import saltr.game.SLTBoard;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLT2DBoard class represents the 2D game board.
 */
public class SLT2DBoard extends SLTBoard {
    private var _assetInstancesByLayerId:Dictionary;
    private var _assetInstancesByLayerIndex:Dictionary;
    private var _config:SLT2DBoardConfig;

    /**
     * Class constructor.
     * @param config The board configuration.
     * @param propertyObjects The board associated properties.
     * @param checkpoints The board checkpoints.
     */
    public function SLT2DBoard(token:String, config:SLT2DBoardConfig, propertyObjects:Dictionary, checkpoints:Dictionary) {
        super(token, config.layers, propertyObjects, checkpoints);
        _config = config;
    }

    public function getAssetInstancesByLayerId(layerId:String):Vector.<SLT2DAssetInstance> {
        return _assetInstancesByLayerId[layerId];
    }

    public function getAssetInstancesByLayerIndex(index:int):Vector.<SLT2DAssetInstance> {
        return _assetInstancesByLayerIndex[index];
    }

    /**
     * The width of the board in pixels as is in Saltr level editor.
     */
    public function get width():Number {
        return _config.width;
    }

    /**
     * The height of the board in pixels as is in Saltr level editor.
     */
    public function get height():Number {
        return _config.height;
    }

    override public function regenerate():void {
        _assetInstancesByLayerId = new Dictionary();
        _assetInstancesByLayerIndex = new Dictionary();

        for (var layerToken:String in _config.layers) {
            var layer:SLT2DBoardLayer = _config.layers[layerToken] as SLT2DBoardLayer;
            var generator:SLT2DBoardGenerator = new SLT2DBoardGenerator();
            generator.generate(_config, layer, _assetInstancesByLayerId, _assetInstancesByLayerIndex);
        }
    }
}
}
