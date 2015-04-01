/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.game.matching {
import flash.utils.Dictionary;

import saltr.game.SLTAsset;
import saltr.game.SLTAssetInstance;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTChunk class represents a collection of cells on matching board that is populated with assets according to certain rules.
 * @private
 */
internal class SLTChunk {
    private var _layerToken:String;
    private var _layerIndex:int;
    private var _chunkAssetRules:Vector.<SLTChunkAssetRule>;
    private var _chunkCells:Vector.<SLTCell>;
    private var _availableCells:Vector.<SLTCell>;
    private var _assetMap:Dictionary;
    private var _availableAssetData:Vector.<SLTChunkAssetDatum>;
    private var _uniqueAssetData:Vector.<SLTChunkAssetDatum>;

    private static function randomWithin(min:Number, max:Number, isFloat:Boolean = false):Number {
        return isFloat ? Math.random() * (1 + max - min) + min : int(Math.random() * (1 + max - min)) + min;
    }

    /**
     * Class constructor.
     * @param layerToken The layer identifier.
     * @param layerIndex The layer index.
     * @param chunkCells The cells of chunk.
     * @param chunkAssetRules The asset rules.
     * @param assetMap The assets.
     */
    public function SLTChunk(layerToken:String, layerIndex:int, chunkCells:Vector.<SLTCell>, chunkAssetRules:Vector.<SLTChunkAssetRule>, assetMap:Dictionary) {
        _layerToken = layerToken;
        _layerIndex = layerIndex;
        _chunkCells = chunkCells;
        _chunkAssetRules = chunkAssetRules;
        _assetMap = assetMap;
        _availableAssetData = new Vector.<SLTChunkAssetDatum>();
        _uniqueAssetData = new Vector.<SLTChunkAssetDatum>();
    }

    /**
     * Returns the available cells count plus chunk asset rules count as string.
     */
    public function toString():String {
        return "[Chunk] cells:" + _availableCells.length + ", " + " chunkAssets: " + _chunkAssetRules.length;
    }

    saltr_internal function get availableAssetData():Vector.<SLTChunkAssetDatum> {
        return _availableAssetData;
    }

    saltr_internal function get uniqueAssetData():Vector.<SLTChunkAssetDatum> {
        return _uniqueAssetData;
    }

    saltr_internal function get cells():Vector.<SLTCell> {
        return _chunkCells;
    }

    saltr_internal function hasCellWithPosition(col:uint, row:uint):Boolean {
        var cellFound:Boolean = false;
        for each(var cell:SLTCell in _chunkCells) {
            if (col == cell.col && row == cell.row) {
                cellFound = true;
                break;
            }
        }
        return cellFound;
    }

    saltr_internal function addAssetInstanceWithPosition(assetDatum:SLTChunkAssetDatum, col:uint, row:uint):void {
        addAssetInstanceWithCellIndex(assetDatum, getCellIndexWithPosition(col, row));
    }

    saltr_internal function addAssetInstanceWithCellIndex(assetDatum:SLTChunkAssetDatum, cellIndex:uint):void {
        var asset:SLTAsset = _assetMap[assetDatum.assetId] as SLTAsset;
        var cell:SLTCell = _chunkCells[cellIndex];
        var stateIds:Array = assetDatum.stateIds;
        cell.setAssetInstance(_layerToken, _layerIndex, new SLTAssetInstance(asset.token, asset.getInstanceStates(stateIds), asset.properties));
    }

    saltr_internal function generateAssetData():void {
        //resetting chunk cells, as when chunk can contain empty cells, previous generation can leave assigned values to cells
        resetChunkCells();
        _availableAssetData.length = 0;
        _uniqueAssetData.length = 0;

        //availableCells are being always overwritten here, so no need to initialize
        _availableCells = _chunkCells.concat();

        var countChunkAssetRules:Vector.<SLTChunkAssetRule> = new <SLTChunkAssetRule>[];
        var ratioChunkAssetRules:Vector.<SLTChunkAssetRule> = new <SLTChunkAssetRule>[];
        var randomChunkAssetRules:Vector.<SLTChunkAssetRule> = new <SLTChunkAssetRule>[];

        for (var i:int = 0, len:int = _chunkAssetRules.length; i < len; ++i) {
            var assetRule:SLTChunkAssetRule = _chunkAssetRules[i];
            switch (assetRule.distributionType) {
                case SLTChunkAssetRule.ASSET_DISTRIBUTION_TYPE_COUNT:
                    countChunkAssetRules.push(assetRule);
                    break;
                case SLTChunkAssetRule.ASSET_DISTRIBUTION_TYPE_RATIO:
                    ratioChunkAssetRules.push(assetRule);
                    break;
                case SLTChunkAssetRule.ASSET_DISTRIBUTION_TYPE_RANDOM:
                    randomChunkAssetRules.push(assetRule);
                    break;
            }
        }

        if (countChunkAssetRules.length > 0) {
            generateAssetDataByCount(countChunkAssetRules);
        }
        if (ratioChunkAssetRules.length > 0) {
            generateAssetDataByRatio(ratioChunkAssetRules);
        }
        else if (randomChunkAssetRules.length > 0) {
            generateAssetInstancesRandomly(randomChunkAssetRules);
        }
        _availableCells.length = 0;
    }

    private function resetChunkCells():void {
        for (var i:int = 0, len:int = _chunkCells.length; i < len; ++i) {
            _chunkCells[i].removeAssetInstance(_layerToken, _layerIndex);
        }
    }

    private function addToAvailableAssetData(assetData:Vector.<SLTChunkAssetDatum>):void {
        for (var i:int = 0; i < assetData.length; ++i) {
            _availableAssetData.push(assetData[i]);
        }
    }

    private function addToUniqueAssetData(assetDatum:SLTChunkAssetDatum):void {
        _uniqueAssetData.push(assetDatum);
    }

    private function generateAssetDataByCount(countChunkAssetRules:Vector.<SLTChunkAssetRule>):void {
        for (var i:int = 0, len:int = countChunkAssetRules.length; i < len; ++i) {
            var assetRule:SLTChunkAssetRule = countChunkAssetRules[i];
            addToAvailableAssetData(getAssetData(assetRule.distributionValue, assetRule.assetId, assetRule.stateIds));
        }
    }

    private function generateAssetDataByRatio(ratioChunkAssetRules:Vector.<SLTChunkAssetRule>):void {
        var ratioSum:Number = 0;
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
                addToAvailableAssetData(getAssetData(count, assetRule.assetId, assetRule.stateIds));
                addToUniqueAssetData(new SLTChunkAssetDatum(assetRule.assetId, assetRule.stateIds, _assetMap));
            }

            fractionAssets.sortOn("fraction", Array.DESCENDING);
            availableCellsNum = _availableCells.length;

            for (var k:int = 0; k < availableCellsNum; ++k) {
                addToAvailableAssetData(getAssetData(1, fractionAssets[k].assetRule.assetId, fractionAssets[k].assetRule.stateIds));
                addToUniqueAssetData(new SLTChunkAssetDatum(fractionAssets[k].assetRule.assetId, fractionAssets[k].assetRule.stateIds, _assetMap));
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
                addToAvailableAssetData(getAssetData(count, chunkAssetRule.assetId, chunkAssetRule.stateIds));
                addToUniqueAssetData(new SLTChunkAssetDatum(chunkAssetRule.assetId, chunkAssetRule.stateIds, _assetMap));
            }
        }
    }

    private function getAssetData(count:uint, assetId:String, stateIds:Array):Vector.<SLTChunkAssetDatum> {
        var assetData:Vector.<SLTChunkAssetDatum> = new Vector.<SLTChunkAssetDatum>();
        for (var i:int = 0; i < count; ++i) {
            assetData.push(new SLTChunkAssetDatum(assetId, stateIds, _assetMap));
            _availableCells.splice(0, 1);
            if (0 == _availableCells.length) {
                break;
            }
        }
        return assetData;
    }

    private function getCellWithPosition(col:uint, row:uint):SLTCell {
        var cellToReturn:SLTCell = null;
        for each(var cell:SLTCell in _chunkCells) {
            if (col == cell.col && row == cell.row) {
                cellToReturn = cell;
                break;
            }
        }
        return cellToReturn;
    }

    private function getCellIndexWithPosition(col:uint, row:uint):int {
        var indexToReturn:int = -1;
        for (var i:int = 0; i < _chunkCells.length; ++i) {
            var cell:SLTCell = _chunkCells[i];
            if (col == cell.col && row == cell.row) {
                indexToReturn = i;
                break;
            }
        }
        return indexToReturn;
    }
}
}