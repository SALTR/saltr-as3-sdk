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
     * @param properties The board associated properties.
     */
    public function SLT2DBoard(config:SLT2DBoardConfig, properties:Object, checkpoints:Dictionary) {
        super(layers, properties, checkpoints);
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

        for (var i:uint = 0; i < _config.layers.length; ++i) {
            var generator:SLT2DBoardGenerator = new SLT2DBoardGenerator();
            generator.generate(_config, _config.layers[i], _assetInstancesByLayerId, _assetInstancesByLayerIndex);
        }
    }
}
}
