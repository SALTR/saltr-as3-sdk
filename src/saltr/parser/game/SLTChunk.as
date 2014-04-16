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

        var len:int = _chunkAssetInfos.length;

        for (var i:int = 0; i < len; ++i) {
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
        if(countChunkAssetInfos.length > 0)
        {
            generateAssetInstancesCount(countChunkAssetInfos);
        }
        if(ratioChunkAssetInfos.length > 0)
        {
            generateAssetInstancesRatio(ratioChunkAssetInfos);
        }
        else if(randomChunkAssetInfos.length > 0)
        {
            generateAssetInstancesRandom(randomChunkAssetInfos);
        }
    }

    private function generateAssetInstances(count:uint, assetId:String, stateId:String):void {
        var asset:SLTAsset = _assetMap[assetId] as SLTAsset;
        var state:String = _stateMap[stateId] as String;

        trace("assetID:" + assetId + " count:" + count);
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

    private function generateAssetInstancesCount(countChunkAssetInfos:Vector.<SLTChunkAssetInfo>):void {
        for (var i:int = 0; i < countChunkAssetInfos.length; ++i) {
           var assetInfo:SLTChunkAssetInfo = _chunkAssetInfos[i];
           generateAssetInstances(assetInfo.distributionValue, assetInfo.assetId, assetInfo.stateId);
        }
    }

    private function generateAssetInstancesRatio(ratioChunkAssetInfos:Vector.<SLTChunkAssetInfo>):void {
        var ratioSum:Number = 0;
        for (i = 0; i < ratioChunkAssetInfos.length; ++i) {
            var assetInfo:SLTChunkAssetInfo = ratioChunkAssetInfos[i];
            ratioSum += assetInfo.distributionValue;
        }
        var availableCellsNum:uint = _availableCells.length;
        var ratioFloatingAssets:Array = new Array();
        if(ratioSum != 0){
            for (var i:uint = 0; i < ratioChunkAssetInfos.length; ++i) {
                var assetInfo:SLTChunkAssetInfo = ratioChunkAssetInfos[i];

                var proportion:Number = assetInfo.distributionValue / ratioSum * availableCellsNum;
                var count:uint = proportion;

                var object:Object = new Object();
                object.float = proportion - count;
                object.assetId = assetInfo.assetId;
                object.stateId = assetInfo.stateId;

                var isSpliced:Boolean = false;
                for (var j:uint = 0; j < ratioFloatingAssets.length; j++) {
                    if (object.float > ratioFloatingAssets[j].float) {
                        ratioFloatingAssets.splice(j, 0, object);
                        isSpliced = true;
                        break;
                    }
                }
                if (!isSpliced) {
                    ratioFloatingAssets.push(object);
                }

                generateAssetInstances(count, assetInfo.assetId, assetInfo.stateId);
            }

            availableCellsNum = _availableCells.length;

            for (i = 0; i < availableCellsNum; i++) {
                generateAssetInstances(1, ratioFloatingAssets[i].assetId, ratioFloatingAssets[i].stateId);
            }
        }
    }

    private function generateAssetInstancesRandom(randomChunkAssetInfos:Vector.<SLTChunkAssetInfo>):void {
        var len:int = randomChunkAssetInfos.length;
        var availableCellsNum:uint = _availableCells.length;
        if (len > 0) {
            var assetConcentration:Number = _availableCells.length > len ? _availableCells.length / len : 1;
            var minAssetCount:uint = assetConcentration <= 2 ? 1 : assetConcentration - 2;
            var maxAssetCount:uint = assetConcentration == 1 ? 1 : assetConcentration + 2;
            var lastChunkAssetIndex:int = len - 1;

            for (var i:int = 0; i < len && _availableCells.length > 0; ++i) {
                var chunkAssetInfo:SLTChunkAssetInfo = randomChunkAssetInfos[i];
                var count:uint = i == lastChunkAssetIndex ? _availableCells.length : randomWithin(minAssetCount, maxAssetCount);
                generateAssetInstances(count, chunkAssetInfo.assetId, chunkAssetInfo.stateId);
            }
        }
    }

    private static function randomWithin(min:Number, max:Number, isFloat:Boolean = false):Number {
        return isFloat ? Math.random() * (1 + max - min) + min : int(Math.random() * (1 + max - min)) + min;
    }
}
}
