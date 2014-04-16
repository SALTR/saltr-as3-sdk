/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: sarg
 * Date: 4/12/12
 * Time: 7:25 PM
 */
package saltr.parser.game {
import flash.utils.Dictionary;

internal class SLTChunk {
    private var _chunkAssetInfos:Vector.<SLTChunkAssetInfo>;
    private var _chunkCells:Vector.<SLTCell>;
    private var _availableCells:Vector.<SLTCell>;
    private var _assetMap:Dictionary;
    private var _stateMap:Dictionary;
    private var _distribution:String;

    public function SLTChunk(chunkCells:Vector.<SLTCell>, distribution:String, chunkAssetInfos:Vector.<SLTChunkAssetInfo>, levelSettings:SLTLevelSettings) {
        _chunkCells = chunkCells;
        _chunkAssetInfos = chunkAssetInfos;
        _distribution = distribution;

        _availableCells = new <SLTCell>[];
        _assetMap = levelSettings.assetMap;
        _stateMap = levelSettings.stateMap;
    }

    public function toString():String {
        return "[Chunk] cells:" + _availableCells.length + ", " + " chunkAssets: " + _chunkAssetInfos.length;
    }

    public function generate():void {
        _availableCells = _chunkCells.concat();
        var weakChunkAssetInfos:Vector.<SLTChunkAssetInfo> = new <SLTChunkAssetInfo>[];
        var len:int = _chunkAssetInfos.length;
        var ratioSum:Number = 0;
        switch (_distribution){
            case "COUNT":
                for (var i:int = 0; i < len; ++i) {
                    var assetInfo:SLTChunkAssetInfo = _chunkAssetInfos[i];
                    if (assetInfo.count != 0) {
                        generateAssetInstancesCount(assetInfo.count, assetInfo.assetId, assetInfo.stateId);
                    }
                    else {
                        weakChunkAssetInfos.push(assetInfo);
                    }
                }
                generateWeakAssetsInstances(weakChunkAssetInfos);
                break;
            case "RATIO":
                for (i = 0; i < len; ++i) {
                    var assetInfo:SLTChunkAssetInfo = _chunkAssetInfos[i];
                    ratioSum += assetInfo.ratio;
                    trace(assetInfo.ratio);
                }
                if(ratioSum == 0){
                    generateWeakAssetsInstances(weakChunkAssetInfos);
                }
                else{
                    for (i = 0; i < len; ++i) {
                        var assetInfo:SLTChunkAssetInfo = _chunkAssetInfos[i];
                        generateAssetInstancesRatio(ratioSum, assetInfo.ratio, assetInfo.assetId, assetInfo.stateId);
                    }
                }
                break;
        }


    }

    private function generateAssetInstancesCount(count:uint, assetId:String, stateId:String):void {
        var asset:SLTAsset = _assetMap[assetId] as SLTAsset;
        var state:String = _stateMap[stateId] as String;
        for (var i:int = 0; i < count; ++i) {
            var randCellIndex:int = int(Math.random() * _availableCells.length);
            var randCell:SLTCell = _availableCells[randCellIndex];
            randCell.assetInstance = new SLTAssetInstance(asset.token, state, asset.properties);
            _availableCells.splice(randCellIndex, 1);
            if (_availableCells.length == 0) {
                return;
            }
        }
    }

    private function generateAssetInstancesRatio(ratioSum:Number, ratio:Number, assetId:String, stateId:String):void {
        var asset:SLTAsset = _assetMap[assetId] as SLTAsset;
        var state:String = _stateMap[stateId] as String;
        var proportion:Number = ratio / ratioSum * _chunkCells.length;
        var count:uint = ((proportion - int(proportion)) > .5) ? proportion + 1 : proportion;
        trace("ratio:" + ratio + " count:" + count + " allCells:" + _chunkCells.length);
        for (var i:int = 0; i < count; ++i) {
            var randCellIndex:int = int(Math.random() * _availableCells.length);
            var randCell:SLTCell = _availableCells[randCellIndex];
            randCell.assetInstance = new SLTAssetInstance(asset.token, state, asset.properties);
            _availableCells.splice(randCellIndex, 1);
            if (_availableCells.length == 0) {
                return;
            }
        }
    }

    private function generateWeakAssetsInstances(weakChunkAssetInfos:Vector.<SLTChunkAssetInfo>):void {
        var len:int = weakChunkAssetInfos.length;
        if (len > 0) {
            var assetConcentration:Number = _availableCells.length > len ? _availableCells.length / len : 1;
            var minAssetCount:uint = assetConcentration <= 2 ? 1 : assetConcentration - 2;
            var maxAssetCount:uint = assetConcentration == 1 ? 1 : assetConcentration + 2;
            var lastChunkAssetIndex:int = len - 1;

            for (var i:int = 0; i < len && _availableCells.length > 0; ++i) {
                var chunkAssetInfo:SLTChunkAssetInfo = weakChunkAssetInfos[i];
                var count:uint = i == lastChunkAssetIndex ? _availableCells.length : randomWithin(minAssetCount, maxAssetCount);
                generateAssetInstancesCount(count, chunkAssetInfo.assetId, chunkAssetInfo.stateId);
            }
        }
    }

    private static function randomWithin(min:Number, max:Number, isFloat:Boolean = false):Number {
        return isFloat ? Math.random() * (1 + max - min) + min : int(Math.random() * (1 + max - min)) + min;
    }
}
}
