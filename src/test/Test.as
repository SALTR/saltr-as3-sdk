/**
 * User: daal
 * Date: 3/5/14
 * Time: 6:18 PM
 */
package test {
import flash.display.Sprite;

import saltr.SLTError;
import saltr.SLTSaltrMobile;
import saltr.parser.game.SLTCellMatrix;
import saltr.parser.game.SLTCellMatrixIterator;
import saltr.parser.game.SLTLevel;

public class Test extends Sprite {


    private static var sampleLevelJson2:Object = {
        "boards": {
            layers: {
                "default": {
                    "main": {
                        "composites": [],
                        "chunks": [
                            {"chunkId": 1, "assets": [
                                {"assetId": 2663, "count": 1}
                            ], "cells": [
                                [1, 8],
                                [2, 8],
                                [9, 8],
                                [10, 8]
                            ]},
                            {"chunkId": 2, "assets": [
                                {"assetId": 2658, "count": 4, "stateId": 470},
                                {"assetId": 2659, "count": 4, "stateId": 470},
                                {"assetId": 2660, "count": 4, "stateId": 470},
                                {"assetId": 2662, "count": 4, "stateId": 470}
                            ], "cells": [
                                [1, 7],
                                [10, 7],
                                [0, 6],
                                [1, 6],
                                [2, 6],
                                [9, 6],
                                [10, 6],
                                [11, 6],
                                [1, 5],
                                [2, 5],
                                [3, 5],
                                [8, 5],
                                [9, 5],
                                [10, 5],
                                [2, 4],
                                [9, 4]
                            ]},
                            {"chunkId": 3, "assets": [
                                {"assetId": 2658, "count": 4},
                                {"assetId": 2659, "count": 5},
                                {"assetId": 2660, "count": 4},
                                {"assetId": 2662, "count": 5}
                            ], "cells": [
                                [0, 2],
                                [1, 2],
                                [2, 2],
                                [3, 2],
                                [4, 2],
                                [5, 2],
                                [0, 1],
                                [1, 1],
                                [2, 1],
                                [3, 1],
                                [4, 1],
                                [5, 1],
                                [0, 0],
                                [1, 0],
                                [2, 0],
                                [3, 0],
                                [4, 0],
                                [5, 0]
                            ]},
                            {"chunkId": 4, "assets": [
                                {"assetId": 2659, "count": 1, "stateId": 471},
                                {"assetId": 2659, "count": 4},
                                {"assetId": 2658, "count": 5},
                                {"assetId": 2660, "count": 4},
                                {"assetId": 2662, "count": 4}
                            ], "cells": [
                                [6, 2],
                                [7, 2],
                                [8, 2],
                                [9, 2],
                                [10, 2],
                                [11, 2],
                                [6, 1],
                                [7, 1],
                                [8, 1],
                                [9, 1],
                                [10, 1],
                                [11, 1],
                                [6, 0],
                                [7, 0],
                                [8, 0],
                                [9, 0],
                                [10, 0],
                                [11, 0]
                            ]},
                            {"chunkId": 5, "assets": [
                                {"assetId": 2662, "count": 1, "stateId": 472},
                                {"assetId": 2660, "count": 1, "stateId": 472},
                                {"assetId": 2659, "count": 1, "stateId": 469},
                                {"assetId": 2658, "count": 1, "stateId": 469}
                            ], "cells": [
                                [5, 4],
                                [6, 4],
                                [5, 3],
                                [6, 3]
                            ]},
                            {"chunkId": 6, "assets": [
                                {"assetId": 2658, "count": 9},
                                {"assetId": 2659, "count": 9},
                                {"assetId": 2660, "count": 9},
                                {"assetId": 2662, "count": 1, "stateId": 471},
                                {"assetId": 2662, "count": 8}
                            ], "cells": [
                                [0, 7],
                                [2, 7],
                                [3, 7],
                                [8, 7],
                                [9, 7],
                                [11, 7],
                                [3, 6],
                                [4, 6],
                                [5, 6],
                                [6, 6],
                                [7, 6],
                                [8, 6],
                                [0, 5],
                                [4, 5],
                                [5, 5],
                                [6, 5],
                                [7, 5],
                                [11, 5],
                                [0, 4],
                                [1, 4],
                                [3, 4],
                                [4, 4],
                                [7, 4],
                                [8, 4],
                                [10, 4],
                                [11, 4],
                                [0, 3],
                                [1, 3],
                                [2, 3],
                                [3, 3],
                                [4, 3],
                                [7, 3],
                                [8, 3],
                                [9, 3],
                                [10, 3],
                                [11, 3]
                            ]}
                        ], "rows": 10, "cols": 12, "blockedCells": []}, "appended": {"composites": [], "chunks": [
                        {"chunkId": 1, "assets": [
                            {"assetId": 2658, "count": 9},
                            {"assetId": 2660, "count": 9},
                            {"assetId": 2662, "count": 9},
                            {"assetId": 2659, "count": 9}
                        ], "cells": [
                            [0, 10],
                            [1, 10],
                            [2, 10],
                            [3, 10],
                            [4, 10],
                            [5, 10],
                            [6, 10],
                            [7, 10],
                            [8, 10],
                            [9, 10],
                            [10, 10],
                            [11, 10],
                            [0, 9],
                            [1, 9],
                            [2, 9],
                            [3, 9],
                            [4, 9],
                            [5, 9],
                            [6, 9],
                            [7, 9],
                            [8, 9],
                            [9, 9],
                            [10, 9],
                            [11, 9],
                            [0, 8],
                            [1, 8],
                            [2, 8],
                            [3, 8],
                            [4, 8],
                            [5, 8],
                            [6, 8],
                            [7, 8],
                            [8, 8],
                            [9, 8],
                            [10, 8],
                            [11, 8]
                        ]},
                        {"chunkId": 2, "assets": [
                            {"assetId": 2660, "count": 9},
                            {"assetId": 2662, "count": 8},
                            {"assetId": 2659, "count": 8},
                            {"assetId": 2658, "count": 1, "stateId": 471},
                            {"assetId": 2658, "count": 8}
                        ], "cells": [
                            [0, 7],
                            [1, 7],
                            [2, 7],
                            [3, 7],
                            [4, 7],
                            [5, 7],
                            [6, 7],
                            [7, 7],
                            [8, 7],
                            [9, 7],
                            [10, 7],
                            [11, 7],
                            [0, 6],
                            [1, 6],
                            [2, 6],
                            [3, 6],
                            [4, 6],
                            [5, 6],
                            [6, 6],
                            [7, 6],
                            [8, 6],
                            [9, 6],
                            [10, 6],
                            [11, 6],
                            [1, 5],
                            [2, 5],
                            [3, 5],
                            [4, 5],
                            [5, 5],
                            [6, 5],
                            [7, 5],
                            [8, 5],
                            [9, 5],
                            [10, 5]
                        ]},
                        {"chunkId": 3, "assets": [
                            {"assetId": 2658, "count": 12},
                            {"assetId": 2659, "count": 12},
                            {"assetId": 2662, "count": 12},
                            {"assetId": 2660, "count": 1, "stateId": 471},
                            {"assetId": 2660, "count": 11}
                        ], "cells": [
                            [0, 3],
                            [1, 3],
                            [2, 3],
                            [3, 3],
                            [4, 3],
                            [5, 3],
                            [6, 3],
                            [7, 3],
                            [8, 3],
                            [9, 3],
                            [10, 3],
                            [11, 3],
                            [0, 2],
                            [1, 2],
                            [2, 2],
                            [3, 2],
                            [4, 2],
                            [5, 2],
                            [6, 2],
                            [7, 2],
                            [8, 2],
                            [9, 2],
                            [10, 2],
                            [11, 2],
                            [0, 1],
                            [1, 1],
                            [2, 1],
                            [3, 1],
                            [4, 1],
                            [5, 1],
                            [6, 1],
                            [7, 1],
                            [8, 1],
                            [9, 1],
                            [10, 1],
                            [11, 1],
                            [0, 0],
                            [1, 0],
                            [2, 0],
                            [3, 0],
                            [4, 0],
                            [5, 0],
                            [6, 0],
                            [7, 0],
                            [8, 0],
                            [9, 0],
                            [10, 0],
                            [11, 0]
                        ]},
                        {"chunkId": 4, "assets": [
                            {"assetId": 2658, "count": 3, "stateId": 470},
                            {"assetId": 2659, "count": 3, "stateId": 470},
                            {"assetId": 2660, "count": 3, "stateId": 470},
                            {"assetId": 2662, "count": 3, "stateId": 470}
                        ], "cells": [
                            [0, 4],
                            [1, 4],
                            [2, 4],
                            [3, 4],
                            [4, 4],
                            [5, 4],
                            [6, 4],
                            [7, 4],
                            [8, 4],
                            [9, 4],
                            [10, 4],
                            [11, 4]
                        ]},
                        {"chunkId": 5, "assets": [
                            {"assetId": 2659, "count": 1, "stateId": 469},
                            {"assetId": 2659, "count": 1, "stateId": 472}
                        ], "cells": [
                            [0, 5],
                            [11, 5]
                        ]}
                    ],
                        "rows": 11,
                        "cols": 12,
                        "blockedCells": []
                    }
                }
            }

        },

        "assetStates": {
            "470": "ice",
            "468": "1111",
            "471": "strawberry",
            "469": "question",
            "472": "skull",
            "474": "111",
            "473": "1112"
        },

        "assets": {
            "2660": {
                "properties": {"COLOR": 13},
                "states": [470, 471, 472, 469],
                "token": "normal"
            },
            "2658": {
                "properties": {"COLOR": 5},
                "states": [470, 471, 472, 469],
                "token": "normal"
            },
            "2661": {
                "properties": {"COLOR": 6},
                "states": [470, 471, 472, 469],
                "token": "normal"
            },
            "2662": {
                "properties": {"COLOR": 4},
                "states": [470, 471, 472, 469],
                "token": "normal"
            },
            "2663": {
                "properties": {"COLOR": 1},
                "states": [],
                "token": "panda"
            },
            "2659": {
                "properties": {"COLOR": 12},
                "states": [470, 471, 472, 469],
                "token": "normal"
            }
        },

        "properties": {
            "appendingRowsCount": "1",
            "cellHeight": "40",
            "cellWidth": "40",
            "playTime": "60",
            "starsRange": "250,400,600",
            "rowAddingSpeed": "4000",
            "type": "match",
            "clickCount": "35",
            "maxStrawberriesCount": "20",
            "tornadoAppearing": "25"
        }
    };

    private static var sampleLevelJson:Object = {
        "boards": {
            "main": {
                "composites": [],
                "chunks": [
                    {
                        "chunkId": 1,
                        "assets": [
                            {
                                "assetId": "2211",
                                "count": 0
                            },
                            {
                                "assetId": "2210",
                                "count": 0
                            },
                            {
                                "assetId": "2208",
                                "count": 0
                            },
                            {
                                "assetId": "2207",
                                "count": 0
                            },
                            {
                                "assetId": "2209",
                                "count": 0
                            }
                        ],
                        "cells": [
                            [0, 7],
                            [1, 7],
                            [2, 7],
                            [3, 7],
                            [4, 7],
                            [5, 7],
                            [6, 7],
                            [7, 7],
                            [0, 6],
                            [1, 6],
                            [2, 6],
                            [3, 6],
                            [4, 6],
                            [5, 6],
                            [6, 6],
                            [7, 6],
                            [0, 5],
                            [1, 5],
                            [2, 5],
                            [3, 5],
                            [4, 5],
                            [5, 5],
                            [6, 5],
                            [7, 5],
                            [0, 4],
                            [1, 4],
                            [2, 4],
                            [3, 4],
                            [4, 4],
                            [5, 4],
                            [6, 4],
                            [7, 4],
                            [0, 3],
                            [1, 3],
                            [2, 3],
                            [3, 3],
                            [4, 3],
                            [5, 3],
                            [6, 3],
                            [7, 3],
                            [0, 2],
                            [1, 2],
                            [2, 2],
                            [3, 2],
                            [4, 2],
                            [5, 2],
                            [6, 2],
                            [7, 2],
                            [0, 1],
                            [1, 1],
                            [2, 1],
                            [3, 1],
                            [4, 1],
                            [5, 1],
                            [6, 1],
                            [7, 1],
                            [0, 0],
                            [1, 0],
                            [2, 0],
                            [3, 0],
                            [4, 0],
                            [5, 0],
                            [6, 0],
                            [7, 0]
                        ]
                    }
                ],
                "blockedCells": [],
                "rows": 8,
                "cols": 8
            },
            "appended": {
                "chunks": [
                    {
                        "chunkId": 1,
                        "assets": [
                            {
                                "assetId": "2207",
                                "count": 0
                            },
                            {
                                "assetId": "2208",
                                "count": 0
                            },
                            {
                                "assetId": "2209",
                                "count": 0
                            },
                            {
                                "assetId": "2210",
                                "count": 0
                            },
                            {
                                "assetId": "2211",
                                "count": 0
                            }
                        ],
                        "cells": [
                            [0, 0],
                            [1, 0],
                            [2, 0],
                            [3, 0],
                            [4, 0],
                            [5, 0],
                            [6, 0],
                            [7, 0]
                        ]
                    }
                ],
                "cols": 8,
                "rows": 1
            }
        }, "keySets": {
            "COLOR": {
                "1": "white",
                "2": "black",
                "3": "red",
                "4": "green",
                "5": "blue",
                "6": "yellow",
                "7": "purple",
                "8": "magenta",
                "9": "cyan",
                "10": "aqua",
                "11": "pink",
                "12": "orange",
                "13": "brown"
            },
            "CARD_SUIT": {
                "1": "spade",
                "2": "club",
                "3": "heart",
                "4": "diamond"
            },
            "CARD_VALUE": {
                "1": "2",
                "2": "3",
                "3": "4",
                "4": "5",
                "5": "6",
                "6": "7",
                "7": "8",
                "8": "9",
                "9": "10",
                "10": "ace",
                "11": "jack",
                "12": "queen",
                "13": "king"
            }
        }, "assetStates": {}, "assets": {
            "2207": {
                "keys": {
                    "COLOR": 4
                },
                "states": [],
                "type_key": "normal"
            },
            "2210": {
                "keys": {
                    "COLOR": 12
                },
                "states": [],
                "type_key": "normal"
            },
            "2211": {
                "keys": {
                    "COLOR": 6
                },
                "states": [],
                "type_key": "normal"
            },
            "2209": {
                "keys": {
                    "COLOR": 7
                },
                "states": [],
                "type_key": "normal"
            },
            "2208": {
                "keys": {
                    "COLOR": 3
                },
                "states": [],
                "type_key": "normal"
            }
        }, "properties": {
            "stars": "10,20,30"
        }};
    private static var sampleLevelWithComposites:Object = {
        "boards": {
            "main": {
                "composites": [
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

    //private static var http://api.saltr.com/httpjson.action?command=APPDATA&insatnceKey=08626247-f03d-0d83-b69f-4f03f80ef555&arguments={%22instanceKey%22:%2208626247-f03d-0d83-b69f-4f03f80ef555%22,%22partner%22:{%22partnerId%22:%22100000024783448%22,%22partnerType%22:%22facebook%22,%22gender%22:%22male%22,%22age%22:36,%22firstName%22:%22Artem%22,%22lastName%22:%22Sukiasyan%22},%22device%22:{%22deviceId%22:%22asdas123kasd%22,%22deviceType%22:%22iphone%22}}
    private static var instanceKey:String = "08626247-f03d-0d83-b69f-4f03f80ef555";


    private var deviceId:String = "deviceId2";
    private var deviceType:String = "iphone";

    public function Test() {
        testLevelBoardParsing();
//        testLevelBoardParsingComposite();

//        flowTest();
    }

    private function testLevelBoardParsing():void {
        var levels:SLTLevel = new SLTLevel("some_id", 1, "", {}, "1");
        levels.updateContent(sampleLevelJson2);

        trace("done");
    }


    private function traceCellMatrix(cells:SLTCellMatrix):void {
        var iterator:SLTCellMatrixIterator = cells.iterator;
        var result:String = "";
        while (iterator.hasNext()) {
            result += iterator.next().assetInstance.properties.COLOR + "  ";
        }
        trace(result);
    }

    private function testLevelBoardParsingComposite():void {
        var levels:SLTLevel = new SLTLevel("some_id", 1, "", {}, "1");
        levels.updateContent(sampleLevelWithComposites);
        trace("done");
    }


    private function flowTest():void {
        var saltrClient:SLTSaltrMobile = new SLTSaltrMobile(instanceKey + "XX");
        saltrClient.initDevice(deviceId, deviceType);

        //saltrClient.importLevels();
        //var pack:SLTLevelPack = saltrClient.levelPacks[0];
        //var level0:SLTLevel = pack.levels[0];
        //saltrClient.loadLevelContentData(pack, level0, levelLoadCompleteHandler, levelLoadFailedHandler);
        saltrClient.start(loadCompleteHandler, loadFailedHandler);
    }

    private function loadCompleteHandler():void {
        trace("load complete ");
    }

    private function loadFailedHandler(error:SLTError):void {
        trace("load failed " + error.errorCode + ":::" + error.errorMessage);
    }

    private function levelLoadCompleteHandler():void {
        trace("level load complete ");
    }

    private function levelLoadFailedHandler():void {
        trace("level load failed");
    }


}
}
