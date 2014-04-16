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

    public function SLTChunk(chunkCells:Vector.<SLTCell>, chunkAssetInfos:Vector.<SLTChunkAssetInfo>, levelSettings:SLTLevelSettings) {
        _chunkCells = chunkCells;
        _chunkAssetInfos = chunkAssetInfos;

        _availableCells = new <SLTCell>[];
        _assetMap = levelSettings.assetMap;
        _stateMap = levelSettings.stateMap;
    }

    public function toString():String {
        return "[Chunk] cells:" + _availableCells.length + ", " + " chunkAssets: " + _chunkAssetInfos.length;
    }

    public function generate():void {
        _availableCells = _chunkCells.concat();
        var countChunkAssetInfos:Vector.<SLTChunkAssetInfo> = new <SLTChunkAssetInfo>[];
        var ratioChunkAssetInfos:Vector.<SLTChunkAssetInfo> = new <SLTChunkAssetInfo>[];
        var randomChunkAssetInfos:Vector.<SLTChunkAssetInfo> = new <SLTChunkAssetInfo>[];

        for (var i:int = 0, len:int = _chunkAssetInfos.length; i < len; ++i) {
            var assetInfo:SLTChunkAssetInfo = _chunkAssetInfos[i];
            switch (assetInfo.distributionType) {
                case "count":
                    countChunkAssetInfos.push(assetInfo);
                    break;
                case "ratio":
                    ratioChunkAssetInfos.push(assetInfo);
                    break;
                case "random":
                    randomChunkAssetInfos.push(assetInfo);
                    break;
            }
        }

        trace(" ");
        trace(_availableCells.length);
        if (countChunkAssetInfos.length > 0) {
            generateAssetInstancesByCount(countChunkAssetInfos);
        }
        if (ratioChunkAssetInfos.length > 0) {
            generateAssetInstancesByRatio(ratioChunkAssetInfos);
        }
        else if (randomChunkAssetInfos.length > 0) {
            generateAssetInstancesRandomly(randomChunkAssetInfos);
        }
    }

    private function generateAssetInstances(count:uint, assetId:String, stateId:String):void {
        var asset:SLTAsset = _assetMap[assetId] as SLTAsset;
        var state:String = _stateMap[stateId] as String;

        trace("assetID:" + assetId + " count:" + count);
        var randCell:SLTCell;
        var randCellIndex:int;

        for (var i:int = 0; i < count; ++i) {
            randCellIndex = int(Math.random() * _availableCells.length);
            randCell = _availableCells[randCellIndex];
            randCell.assetInstance = new SLTAssetInstance(asset.token, state, asset.properties);
            _availableCells.splice(randCellIndex, 1);
            if (_availableCells.length == 0) {
                return;
            }
        }
    }

    private function generateAssetInstancesByCount(countChunkAssetInfos:Vector.<SLTChunkAssetInfo>):void {
        for (var i:int = 0, len:int = countChunkAssetInfos.length; i < len; ++i) {
            var assetInfo:SLTChunkAssetInfo = countChunkAssetInfos[i];
            generateAssetInstances(assetInfo.distributionValue, assetInfo.assetId, assetInfo.stateId);
        }
    }

    private function generateAssetInstancesByRatio(ratioChunkAssetInfos:Vector.<SLTChunkAssetInfo>):void {
        var ratioSum:uint = 0;
        var len:int = ratioChunkAssetInfos.length;
        var assetInfo:SLTChunkAssetInfo;
        for (var i:int = 0; i < len; ++i) {
            assetInfo = ratioChunkAssetInfos[i];
            ratioSum += assetInfo.distributionValue;
        }
        var availableCellsNum:uint = _availableCells.length;
        var proportion:Number;
        var count:uint;

        var fractionAssets:Array = [];
        if (ratioSum != 0) {
            for (var j:int = 0; j < len; ++j) {
                assetInfo = ratioChunkAssetInfos[j];
                proportion = assetInfo.distributionValue / ratioSum * availableCellsNum;
                count = proportion; //assigning number to int to floor the value;
                fractionAssets.push({fraction: proportion - count, assetInfo: assetInfo});
                generateAssetInstances(count, assetInfo.assetId, assetInfo.stateId);
            }

            fractionAssets.sortOn("fraction", Array.DESCENDING);
            availableCellsNum = _availableCells.length;

            for (var k:int = 0; k < availableCellsNum; ++k) {
                generateAssetInstances(1, fractionAssets[k].assetInfo.assetId, fractionAssets[k].assetInfo.stateId);
            }
        }
    }

    private function generateAssetInstancesRandomly(randomChunkAssetInfos:Vector.<SLTChunkAssetInfo>):void {
        var len:int = randomChunkAssetInfos.length;
        var availableCellsNum:uint = _availableCells.length;
        if (len > 0) {
            var assetConcentration:Number = availableCellsNum > len ? availableCellsNum / len : 1;
            var minAssetCount:uint = assetConcentration <= 2 ? 1 : assetConcentration - 2;
            var maxAssetCount:uint = assetConcentration == 1 ? 1 : assetConcentration + 2;
            var lastChunkAssetIndex:int = len - 1;

            var chunkAssetInfo:SLTChunkAssetInfo;
            var count:uint;
            for (var i:int = 0; i < len && _availableCells.length > 0; ++i) {
                chunkAssetInfo = randomChunkAssetInfos[i];
                count = i == lastChunkAssetIndex ? _availableCells.length : randomWithin(minAssetCount, maxAssetCount);
                generateAssetInstances(count, chunkAssetInfo.assetId, chunkAssetInfo.stateId);
            }
        }
    }

    private static function randomWithin(min:Number, max:Number, isFloat:Boolean = false):Number {
        return isFloat ? Math.random() * (1 + max - min) + min : int(Math.random() * (1 + max - min)) + min;
    }
}
}
