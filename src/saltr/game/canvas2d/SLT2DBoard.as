/**
 * Created by GSAR on 7/10/14.
 */
package saltr.game.canvas2d {
import flash.utils.Dictionary;

import saltr.game.SLTBoard;
import saltr.game.SLTBoardLayer;
import saltr.game.canvas2d.SLTCanvas2DBoardConfig;

/**
 * The SLT2DBoard class represents the 2D game board.
 */
public class SLT2DBoard extends SLTBoard {

    private var _width:Number;
    private var _height:Number;

    private var _assetInstancesByLayerId : Dictionary;
    private var _assetInstancesByLayerIndex : Dictionary;
    private var _config:SLTCanvas2DBoardConfig;


    /**
     * Class constructor.
     * @param width The width of the board in pixels as is in Saltr level editor.
     * @param height The height of the board in pixels as is in Saltr level editor.
     * @param layers The layers of the board.
     * @param properties The board associated properties.
     */
    public function SLT2DBoard(config : SLTCanvas2DBoardConfig, properties:Object) {
        super(layers, properties);
        _config = config;
        _width = _config.width;
        _height = _config.height;
    }

    public function getAssetInstancesByLayerId(layerId : String) : Vector.<SLT2DAssetInstance> {
        return _assetInstancesByLayerId[layerId];
    }

    public function  getAssetInstancesByLayerIndex(index : int) : Vector.<SLT2DAssetInstance> {
        return _assetInstancesByLayerIndex[index];
    }


    /**
     * The width of the board in pixels as is in Saltr level editor.
     */
    public function get width():Number {
        return _width;
    }

    /**
     * The height of the board in pixels as is in Saltr level editor.
     */
    public function get height():Number {
        return _height;
    }

    override public function regenerate():void {
        _assetInstancesByLayerId = new Dictionary();
        _assetInstancesByLayerIndex = new Dictionary();

        for(var i : uint = 0; i < _config.layers.length; ++i) {
            var generator : SLTCanvas2DBoardGenerator = new SLTCanvas2DBoardGenerator();
            generator.generate(_config, _config.layers[i], _assetInstancesByLayerId, _assetInstancesByLayerIndex);
        }
    }
}
}
