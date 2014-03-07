/**
 * User: daal
 * Date: 3/5/14
 * Time: 6:18 PM
 */
package test {
import flash.display.Sprite;

import saltr.SLTLevelPack;

import saltr.SLTLevel;
import saltr.SLTSaltr;
import saltr.builder.SLTMobileSaltrBuilder;

public class Test extends Sprite {

    private static var sampleLevelJson:Object = {"boards": {"main": {"composites": [], "chunks": [
        {"chunkId": 1, "assets": [
            {"assetId": "995", "count": 2},
            {"assetId": "996", "count": 2},
            {"assetId": "997", "count": 1},
            {"assetId": "998", "count": 1},
            {"assetId": "999", "count": 1}
        ], "cells": [
            [0, 0],
            [1, 0],
            [2, 0],
            [3, 0],
            [4, 0],
            [5, 0],
            [6, 0]
        ]},
        {"chunkId": 2, "assets": [
            {"assetId": "995", "count": 10},
            {"assetId": "996", "count": 10},
            {"assetId": "997", "count": 10},
            {"assetId": "999", "count": 8},
            {"assetId": "998", "count": 9}
        ], "cells": [
            [0, 8],
            [1, 8],
            [2, 8],
            [3, 8],
            [4, 8],
            [5, 8],
            [6, 8],
            [0, 7],
            [1, 7],
            [2, 7],
            [3, 7],
            [4, 7],
            [5, 7],
            [6, 7],
            [1, 5],
            [2, 5],
            [3, 5],
            [4, 5],
            [5, 5],
            [0, 4],
            [1, 4],
            [2, 4],
            [3, 4],
            [4, 4],
            [5, 4],
            [6, 4],
            [0, 3],
            [1, 3],
            [2, 3],
            [3, 3],
            [4, 3],
            [5, 3],
            [6, 3],
            [0, 2],
            [1, 2],
            [2, 2],
            [3, 2],
            [4, 2],
            [5, 2],
            [6, 2],
            [0, 1],
            [1, 1],
            [2, 1],
            [3, 1],
            [4, 1],
            [5, 1],
            [6, 1]
        ]},
        {"chunkId": 3, "assets": [
            {"assetId": "995", "count": 2},
            {"assetId": "996", "count": 2},
            {"assetId": "997", "count": 1},
            {"assetId": "998", "count": 1},
            {"assetId": "999", "count": 1}
        ], "cells": [
            [0, 6],
            [1, 6],
            [2, 6],
            [3, 6],
            [4, 6],
            [5, 6],
            [6, 6]
        ]}
    ], "blockedCells": [
        [0, 5],
        [6, 5]
    ], "rows": 9, "cols": 7, "cellSize": [30, 30], "orientation": "TOP_LEFT", "position": [30, 180], "properties": {"cell": [
        {"coords": [0, 6], "value": {"jelly": 2}},
        {"coords": [1, 6], "value": {"jelly": 1}},
        {"coords": [2, 6], "value": {"jelly": "2"}},
        {"coords": [3, 6], "value": {"jelly": 2}},
        {"coords": [4, 6], "value": {"jelly": "1"}},
        {"coords": [5, 6], "value": {"jelly": "2"}},
        {"coords": [6, 6], "value": {"jelly": "2"}},
        {"coords": [3, 4], "value": {"walls": {"bottom": "true"}}},
        {"coords": [0, 2], "value": {"walls": {"right": "true"}}},
        {"coords": [1, 2], "value": {"walls": {"bottom": true}}},
        {"coords": [2, 2], "value": {"walls": {"bottom": "value"}}},
        {"coords": [4, 2], "value": {"walls": {"bottom": "true"}}},
        {"coords": [5, 2], "value": {"walls": {"bottom": true, "right": "true"}}}
    ], "board": {}}}, "appended": {"composites": [], "chunks": [
        {"chunkId": 1, "assets": [
            {"assetId": "995", "count": 2},
            {"assetId": "996", "count": 2},
            {"assetId": "997", "count": 2},
            {"assetId": "999", "count": 2},
            {"assetId": "998", "count": 2}
        ], "cells": [
            [0, 0],
            [1, 0],
            [2, 0],
            [3, 0],
            [4, 0],
            [5, 0],
            [6, 0],
            [7, 0],
            [8, 0],
            [9, 0]
        ]}
    ], "blockedCells": [], "rows": 1, "cols": 10, "cellSize": [30, 30], "orientation": "TOP_LEFT", "position": [30, 90], "properties": {"board": {}}}}, "keySets": {"COLOR": {"3": "red", "4": "green", "5": "blue", "7": "purple", "12": "orange"}}, "assetStates": {"491": "radialbomb", "492": "linebomb", "493": "colorbomb", "467": "cobweb", "367": "jumping"}, "assets": {"1859": {"keys": {}, "states": [], "type_key": "dragoninbox"}, "1858": {"keys": {}, "states": [], "type_key": "dragon"}, "1857": {"keys": {}, "states": [], "type_key": "blocked"}, "1860": {"keys": {}, "states": [], "type_key": "jelly"}, "1918": {"keys": {}, "states": [], "type_key": "doublejelly"}, "996": {"keys": {"COLOR": 4}, "states": [367, 491, 493, 467, 492], "type_key": "normal"}, "997": {"keys": {"COLOR": 5}, "states": [367, 491, 493, 467, 492], "type_key": "normal"}, "995": {"keys": {"COLOR": 3}, "states": [367, 491, 493, 467, 492], "type_key": "normal"}, "1724": {"keys": {}, "states": [], "type_key": "virus"}, "1919": {"keys": {}, "states": [], "type_key": "doublewax"}, "1977": {"keys": {}, "states": [], "type_key": "explosiveink"}, "1723": {"keys": {}, "states": [], "type_key": "wax"}, "1978": {"cells": [
        [0, 0],
        [1, 0]
    ], "keys": {}, "states": [], "type_key": "bigitem"}, "998": {"keys": {"COLOR": 12}, "states": [367, 491, 493, 467, 492], "type_key": "normal"}, "999": {"keys": {"COLOR": 7}, "states": [367, 491, 493, 467, 492], "type_key": "normal"}}, "properties": {"movesCount": "70", "levelType": "jellyCleaning", "boost_extra_moves": "true", "boost_hammer": "true", "boost_chameleon_bomb": "true", "PRE_GAME_LINE_BOMB_BOOST": "true", "PRE_GAME_RADIAL_BOMB_BOOST": "true", "IN_GAME_EYEDROPPER_BOOST": "true", "IN_GAME_EXTRA_MOVES_BOOST": "true"}};
    private static var sampleLevelWithComposites:Object = {"boards": {"main": {"composites": [
        {"assetId": 1978, "position": [2, 0]}
    ], "chunks": [
        {"chunkId": 1, "assets": [
            {"assetId": "995", "count": 2},
            {"assetId": "996", "count": 2},
            {"assetId": "997", "count": 2},
            {"assetId": "998", "count": 3},
            {"assetId": "999", "count": 3}
        ], "cells": [
            [0, 8],
            [1, 8],
            [5, 8],
            [6, 8],
            [0, 7],
            [6, 7],
            [0, 1],
            [6, 1],
            [0, 0],
            [1, 0],
            [5, 0],
            [6, 0]
        ]},
        {"chunkId": 2, "assets": [
            {"assetId": "995", "count": 10},
            {"assetId": "996", "count": 10},
            {"assetId": "997", "count": 10},
            {"assetId": "998", "count": 10},
            {"assetId": "999", "count": 9}
        ], "cells": [
            [2, 8],
            [3, 8],
            [4, 8],
            [1, 7],
            [2, 7],
            [3, 7],
            [4, 7],
            [5, 7],
            [0, 6],
            [1, 6],
            [2, 6],
            [3, 6],
            [4, 6],
            [5, 6],
            [6, 6],
            [0, 5],
            [1, 5],
            [2, 5],
            [3, 5],
            [4, 5],
            [5, 5],
            [6, 5],
            [0, 4],
            [1, 4],
            [2, 4],
            [3, 4],
            [4, 4],
            [5, 4],
            [6, 4],
            [0, 3],
            [1, 3],
            [2, 3],
            [3, 3],
            [4, 3],
            [5, 3],
            [6, 3],
            [0, 2],
            [1, 2],
            [2, 2],
            [3, 2],
            [4, 2],
            [5, 2],
            [6, 2],
            [1, 1],
            [2, 1],
            [3, 1],
            [4, 1],
            [5, 1],
            [4, 0]
        ]}
    ], "blockedCells": [], "rows": 9, "cols": 7, "cellSize": [30, 30], "orientation": "TOP_LEFT", "position": [60, 180], "properties": {"board": {}}}, "appended": {"composites": [], "chunks": [
        {"chunkId": 1, "assets": [
            {"assetId": "995", "count": 2},
            {"assetId": "996", "count": 2},
            {"assetId": "997", "count": 2},
            {"assetId": "998", "count": 2},
            {"assetId": "999", "count": 2}
        ], "cells": [
            [0, 0],
            [1, 0],
            [2, 0],
            [3, 0],
            [4, 0],
            [5, 0],
            [6, 0],
            [7, 0],
            [8, 0],
            [9, 0]
        ]}
    ], "blockedCells": [], "rows": 1, "cols": 10, "cellSize": [30, 30], "orientation": "TOP_LEFT", "position": [0, 0], "properties": {"board": {}}}}, "keySets": {"COLOR": {"3": "red", "4": "green", "5": "blue", "7": "purple", "12": "orange"}}, "assetStates": {"491": "radialbomb", "492": "linebomb", "493": "colorbomb", "467": "cobweb", "367": "jumping"}, "assets": {"1859": {"keys": {}, "states": [], "type_key": "dragoninbox"}, "1858": {"keys": {}, "states": [], "type_key": "dragon"}, "1857": {"keys": {}, "states": [], "type_key": "blocked"}, "1860": {"keys": {}, "states": [], "type_key": "jelly"}, "1918": {"keys": {}, "states": [], "type_key": "doublejelly"}, "996": {"keys": {"COLOR": 4}, "states": [367, 491, 493, 467, 492], "type_key": "normal"}, "997": {"keys": {"COLOR": 5}, "states": [367, 491, 493, 467, 492], "type_key": "normal"}, "995": {"keys": {"COLOR": 3}, "states": [367, 491, 493, 467, 492], "type_key": "normal"}, "1724": {"keys": {}, "states": [], "type_key": "virus"}, "1919": {"keys": {}, "states": [], "type_key": "doublewax"}, "1977": {"keys": {}, "states": [], "type_key": "explosiveink"}, "1723": {"keys": {}, "states": [], "type_key": "wax"}, "1978": {"cells": [
        [0, 0],
        [1, 0]
    ], "keys": {}, "states": [], "type_key": "bigitem"}, "998": {"keys": {"COLOR": 12}, "states": [367, 491, 493, 467, 492], "type_key": "normal"}, "999": {"keys": {"COLOR": 7}, "states": [367, 491, 493, 467, 492], "type_key": "normal"}}, "properties": {"levelType": "dragonDropping", "movesCount": "32", "boost_hammer": "true", "boost_extra_moves": "true"}};

    //http://api.saltr.com/httpjson.action?command=APPDATA&insatnceKey=08626247-f03d-0d83-b69f-4f03f80ef555&arguments={%22instanceKey%22:%2208626247-f03d-0d83-b69f-4f03f80ef555%22,%22partner%22:{%22partnerId%22:%22100000024783448%22,%22partnerType%22:%22facebook%22,%22gender%22:%22male%22,%22age%22:36,%22firstName%22:%22Artem%22,%22lastName%22:%22Sukiasyan%22},%22device%22:{%22deviceId%22:%22asdas123kasd%22,%22deviceType%22:%22iphone%22}}
    private static var instanceKey:String = "08626247-f03d-0d83-b69f-4f03f80ef555";


    private var deviceId:String = "deviceId2";
    private var deviceType:String = "iphone";

    public function Test() {
        testLevelBoardParsing();
//        testLevelBoardParsingComposite();

       // flowTest();
    }

    private function testLevelBoardParsing():void {
        var levels:SLTLevel = new SLTLevel("some_id", 1, "", {}, "1");
        levels.parseData(sampleLevelJson);
        trace("done");
    }

    private function testLevelBoardParsingComposite():void {
        var levels:SLTLevel = new SLTLevel("some_id", 1, "", {}, "1");
        levels.parseData(sampleLevelWithComposites);
        trace("done");
    }


    private function flowTest():void {
        var saltrClient:SLTSaltr = SLTMobileSaltrBuilder.create(instanceKey, true);
        saltrClient.initDevice(deviceId, deviceType);

        saltrClient.importLevels();
        var pack:SLTLevelPack = saltrClient.levelPacks[0];
        var level0:SLTLevel = pack.levels[0];
        saltrClient.getLevelDataBody(pack, level0, levelLoadCompleteHandler, levelLoadFailedHandler);
//        saltrClient.start(loadCompleteHandler, loadFailedHandler);
    }

    private function loadCompleteHandler():void {
        trace("load complete ");
    }

    private function loadFailedHandler():void {
        trace("load failed");
    }

    private function levelLoadCompleteHandler():void {
        trace("level load complete ");
    }

    private function levelLoadFailedHandler():void {
        trace("level load failed");
    }


}
}
