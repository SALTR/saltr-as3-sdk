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
        var assetNodes:Array = layer.assetRules;
        for (var i:int = 0, len:int = assetNodes.length; i < len; ++i) {
            var assetInstanceNode:Object = assetNodes[i];
            var x:Number = assetInstanceNode.x;
            var y:Number = assetInstanceNode.y;
            var scaleX:Number = assetInstanceNode.hasOwnProperty("scaleX") ? assetInstanceNode.scaleX : 1;
            var scaleY:Number = assetInstanceNode.hasOwnProperty("scaleY") ? assetInstanceNode.scaleY : 1;
            var rotation:Number = assetInstanceNode.rotation;
            var asset:SLTAsset = assetMap[assetInstanceNode.assetId] as SLTAsset;
            var stateId:String = assetInstanceNode.stateId;
            var positions:Array = getAssetInstancePositions(assetInstanceNode);
            assetInstances.push(new SLT2DAssetInstance(asset.token, asset.getInstanceState(stateId), asset.properties, x, y, scaleX, scaleY, rotation, positions));
        }
        return assetInstances;
    }

    private function getAssetInstancePositions(assetInstanceNode:Object):Array {
        var positions:Array = [];
        var positionsArray:Array = assetInstanceNode.hasOwnProperty("altPositions") ? assetInstanceNode.positions as Array : [];
        var positionsCount:int = positionsArray.length;
        for (var i:int = 0; i < positionsCount; ++i) {
            var positionObject:Object = positionsArray[i];
            var placeHolder:SLTCanvasPlaceHolder = new SLTCanvasPlaceHolder(positionObject.x, positionObject.y, positionObject.tags);
            positions.push(placeHolder);
        }
        return positions;
    }
}
}
