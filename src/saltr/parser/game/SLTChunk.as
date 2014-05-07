/*
 * Copyright (c) 2014 Plexonic Ltd
 */

/**
 * User: sarg
 * Date: 4/12/12
 * Time: 7:25 PM
 */
package saltr.parser.game {
import flash.utils.Dictionary;

internal class SLTChunk {
    private var _layer:SLTLevelBoardLayer;
    private var _chunkAssetRules:Vector.<SLTChunkAssetRule>;
    private var _chunkCells:Vector.<SLTCell>;
    private var _availableCells:Vector.<SLTCell>;
    private var _assetMap:Dictionary;
    private var _stateMap:Dictionary;

    public function SLTChunk(layer:SLTLevelBoardLayer, chunkCells:Vector.<SLTCell>, chunkAssetRules:Vector.<SLTChunkAssetRule>, levelSettings:SLTLevelSettings) {
        _layer = layer;
        _chunkCells = chunkCells;
        _chunkAssetRules = chunkAssetRules;

        _availableCells = new <SLTCell>[];
        _assetMap = levelSettings.assetMap;
        _stateMap = levelSettings.stateMap;
        generateCellContent();
    }

    public function toString():String {
        return "[Chunk] cells:" + _availableCells.length + ", " + " chunkAssets: " + _chunkAssetRules.length;
    }

    private function generateCellContent():void {
        _availableCells = _chunkCells.concat();
        var countChunkAssetRules:Vector.<SLTChunkAssetRule> = new <SLTChunkAssetRule>[];
        var ratioChunkAssetRules:Vector.<SLTChunkAssetRule> = new <SLTChunkAssetRule>[];
        var randomChunkAssetRules:Vector.<SLTChunkAssetRule> = new <SLTChunkAssetRule>[];

        for (var i:int = 0, len:int = _chunkAssetRules.length; i < len; ++i) {
            var assetRule:SLTChunkAssetRule = _chunkAssetRules[i];
            switch (assetRule.distributionType) {
                case "count":
                    countChunkAssetRules.push(assetRule);
                    break;
                case "ratio":
                    ratioChunkAssetRules.push(assetRule);
                    break;
                case "random":
                    randomChunkAssetRules.push(assetRule);
                    break;
            }
        }

        trace(" ");
        trace(_availableCells.length);
        if (countChunkAssetRules.length > 0) {
            generateAssetInstancesByCount(countChunkAssetRules);
        }
        if (ratioChunkAssetRules.length > 0) {
            generateAssetInstancesByRatio(ratioChunkAssetRules);
        }
        else if (randomChunkAssetRules.length > 0) {
            generateAssetInstancesRandomly(randomChunkAssetRules);
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
            randCell.setAssetInstance(_layer.layerId, _layer.layerIndex, new SLTAssetInstance(asset.token, state, asset.properties));
            _availableCells.splice(randCellIndex, 1);
            if (_availableCells.length == 0) {
                return;
            }
        }
    }

    private function generateAssetInstancesByCount(countChunkAssetRules:Vector.<SLTChunkAssetRule>):void {
        for (var i:int = 0, len:int = countChunkAssetRules.length; i < len; ++i) {
            var assetRule:SLTChunkAssetRule = countChunkAssetRules[i];
            generateAssetInstances(assetRule.distributionValue, assetRule.assetId, assetRule.stateId);
        }
    }

    private function generateAssetInstancesByRatio(ratioChunkAssetRules:Vector.<SLTChunkAssetRule>):void {
        var ratioSum:uint = 0;
        var len:int = ratioChunkAssetRules.length;
        var assetRule:SLTChunkAssetRule;
        for (var i:int = 0; i < len; ++i) {
            assetRule = ratioChunkAssetRules[i];
            ratioSum += assetRule.distributionValue;
        }
        var availableCellsNum:uint = _availableCells.length;
        var proportion:Number;
        var count:uint;

        var fractionAssets:Array = [];
        if (ratioSum != 0) {
            for (var j:int = 0; j < len; ++j) {
                assetRule = ratioChunkAssetRules[j];
                proportion = assetRule.distributionValue / ratioSum * availableCellsNum;
                count = proportion; //assigning number to int to floor the value;
                fractionAssets.push({fraction: proportion - count, assetRule: assetRule});
                generateAssetInstances(count, assetRule.assetId, assetRule.stateId);
            }

            fractionAssets.sortOn("fraction", Array.DESCENDING);
            availableCellsNum = _availableCells.length;

            for (var k:int = 0; k < availableCellsNum; ++k) {
                generateAssetInstances(1, fractionAssets[k].assetRule.assetId, fractionAssets[k].assetRule.stateId);
            }
        }
    }

    private function generateAssetInstancesRandomly(randomChunkAssetRules:Vector.<SLTChunkAssetRule>):void {
        var len:int = randomChunkAssetRules.length;
        var availableCellsNum:uint = _availableCells.length;
        if (len > 0) {
            var assetConcentration:Number = availableCellsNum > len ? availableCellsNum / len : 1;
            var minAssetCount:uint = assetConcentration <= 2 ? 1 : assetConcentration - 2;
            var maxAssetCount:uint = assetConcentration == 1 ? 1 : assetConcentration + 2;
            var lastChunkAssetIndex:int = len - 1;

            var chunkAssetRule:SLTChunkAssetRule;
            var count:uint;
            for (var i:int = 0; i < len && _availableCells.length > 0; ++i) {
                chunkAssetRule = randomChunkAssetRules[i];
                count = i == lastChunkAssetIndex ? _availableCells.length : randomWithin(minAssetCount, maxAssetCount);
                generateAssetInstances(count, chunkAssetRule.assetId, chunkAssetRule.stateId);
            }
        }
    }

    private static function randomWithin(min:Number, max:Number, isFloat:Boolean = false):Number {
        return isFloat ? Math.random() * (1 + max - min) + min : int(Math.random() * (1 + max - min)) + min;
    }
}
}
