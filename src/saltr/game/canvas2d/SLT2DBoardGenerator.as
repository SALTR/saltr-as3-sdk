/**
 * Created by TIGR on 3/25/2015.
 */
package saltr.game.canvas2d {

import flash.utils.Dictionary;

import saltr.game.SLTAsset;
import saltr.saltr_internal;

use namespace saltr_internal;

internal class SLT2DBoardGenerator {

    public function generate(boardConfig:SLT2DBoardConfig, layer:SLT2DBoardLayer, assetInstancesByLayerId:Dictionary, assetInstancesByLayerIndex:Dictionary):void {
        var assetInstances:Vector.<SLT2DAssetInstance> = parseAssetInstances(layer, boardConfig.assetMap);
        assetInstancesByLayerId[layer.token] = assetInstances;
        assetInstancesByLayerIndex[layer.index] = assetInstances;
    }

    private function parseAssetInstances(layer:SLT2DBoardLayer, assetMap:Dictionary):Vector.<SLT2DAssetInstance> {
        var assetInstances:Vector.<SLT2DAssetInstance> = new Vector.<SLT2DAssetInstance>();
        var assetNodes:Array = layer.assets;
        for (var i:int = 0, len:int = assetNodes.length; i < len; ++i) {
            var assetInstanceNode:Object = assetNodes[i];
            var x:Number = assetInstanceNode.x;
            var y:Number = assetInstanceNode.y;
            var scaleX:Number = assetInstanceNode.scaleX;
            var scaleY:Number = assetInstanceNode.scaleY;
            var rotation:Number = assetInstanceNode.rotation;
            var asset:SLTAsset = assetMap[assetInstanceNode.assetId] as SLTAsset;
            var stateIds:Array = assetInstanceNode.states as Array;
            assetInstances.push(new SLT2DAssetInstance(asset.token, asset.getInstanceStates(stateIds), asset.properties, x, y, scaleX, scaleY, rotation));
        }
        return assetInstances;
    }
}
}
