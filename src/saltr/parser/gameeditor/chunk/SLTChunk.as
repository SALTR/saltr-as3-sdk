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
package saltr.parser.gameeditor.chunk {
import flash.utils.Dictionary;

import saltr.parser.gameeditor.SLTAssetInstance;
import saltr.parser.gameeditor.SLTLevelSettings;
import saltr.parser.gameeditor.SLTCell;
import saltr.parser.gameeditor.SLTAsset;

public class SLTChunk {
    private var _id:String;
    private var _chunkAssets:Vector.<SLTAssetInChunk>;
    private var _cells:Vector.<SLTCell>;
    private var _boardAssetMap:Dictionary;
    private var _boardStateMap:Dictionary;

    public function SLTChunk(id:String,levelSettings:SLTLevelSettings) {
        _id = id;
        _chunkAssets = new Vector.<SLTAssetInChunk>();
        _cells = new Vector.<SLTCell>();
        _boardAssetMap = levelSettings.assetMap;
        _boardStateMap = levelSettings.stateMap;
    }

    public function generate():void {
        var weakChunkAsset:Vector.<SLTAssetInChunk> = new Vector.<SLTAssetInChunk>();
        for each(var chunkAsset:SLTAssetInChunk in _chunkAssets) {
            if (chunkAsset.count != 0) {
                generateAsset(chunkAsset.count, chunkAsset.id, chunkAsset.stateId);
            }
            else {
                weakChunkAsset.push(chunkAsset);
            }
        }
        generateWeakAssets(weakChunkAsset);
    }

    private function generateAsset(count:uint, id:String, stateId:String):void {
        var assetTemplate:SLTAsset = _boardAssetMap[id] as SLTAsset;
        var state:String = _boardStateMap[stateId] as String;
        for (var i:uint = 0; i < count; ++i) {
            var randCellIndex:int = int(Math.random() * _cells.length);
            var randCell:SLTCell = _cells[randCellIndex];
            var asset:SLTAssetInstance = new SLTAssetInstance();
            asset.keys = assetTemplate.keys;
            asset.state = state;
            asset.type = assetTemplate.type;
            randCell.assetInstance = asset;
            _cells.splice(randCellIndex, 1);
            if (_cells.length == 0) {
                return;
            }
        }
    }

    private function generateWeakAssets(weakChunkAsset:Vector.<SLTAssetInChunk>):void {
        if (weakChunkAsset.length != 0) {
            var assetConcentration:Number = _cells.length > weakChunkAsset.length ? _cells.length / weakChunkAsset.length : 1;
            var minAssetCount:uint = assetConcentration <= 2 ? 1 : assetConcentration - 2;
            var maxAssetCount:uint = assetConcentration == 1 ? 1 : assetConcentration + 2;
            var lastChunkAssetIndex:int = weakChunkAsset.length - 1;

            for (var i:uint = 0; i < weakChunkAsset.length && _cells.length != 0; ++i) {
                var chunkAsset : SLTAssetInChunk = weakChunkAsset[i];
                var count : uint = i == lastChunkAssetIndex ? _cells.length : randomWithin(minAssetCount, maxAssetCount);
                generateAsset(count, chunkAsset.id, chunkAsset.stateId);
            }
        }
    }

    public function addChunkAsset(chunkAsset:SLTAssetInChunk):void {
        _chunkAssets.push(chunkAsset);
    }

    public function toString():String {
        return "Chunk : [cells :" + _cells + " ]" + "[chunkAssets : " + _chunkAssets + " ]";
    }

    public function addCell(cell:SLTCell):void {
        _cells.push(cell);
    }

    public function get id():String {
        return _id;
    }

    public function set id(value:String):void {
        _id = value;
    }

    private static function randomWithin(min:Number, max:Number, isFloat:Boolean = false):Number {
        return isFloat ? Math.random() * (1 + max - min) + min : int(Math.random() * (1 + max - min)) + min;
    }
}
}
