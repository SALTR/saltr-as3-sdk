/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: sarg
 * Date: 10/23/12
 * Time: 4:35 PM
 */
package saltr {
import flash.utils.Dictionary;

import saltr.parser.SLTLevelBoardParser;
import saltr.parser.gameeditor.SLTLevelSettings;

public class SLTLevel {
    private var _id:String;
    private var _contentDataUrl:String;
    private var _index:int;
    private var _properties:Object;
    private var _boards:Dictionary;
    private var _contentReady:Boolean;
    private var _version:String;
    private var _levelContent:Object;
    private var _levelSettings:SLTLevelSettings;
    private var _boardsContent:Object;

    public function SLTLevel(id:String, index:int, contentDataUrl:String, properties:Object, version:String) {
        _id = id;
        _index = index;
        _contentDataUrl = contentDataUrl;
        _contentReady = false;
        _properties = properties;
        _version = version;
    }

    public function get id():String {
        return _id;
    }

    public function get index():int {
        return _index;
    }

    public function get properties():Object {
        return _properties;
    }

    public function get contentDataUrl():String {
        return _contentDataUrl;
    }

    public function get contentReady():Boolean {
        return _contentReady;
    }

    public function get version():String {
        return _version;
    }

    public function getBoard(id:String):SLTLevelBoard {
        return _boards[id];
    }

    public function updateContent(contentData:Object):void {
        _levelContent = contentData;
        _boardsContent = contentData["boards"];
        _properties = contentData["properties"];
        _levelSettings = SLTLevelBoardParser.parseLevelSettings(contentData);
        generateAllBoards();
        _contentReady = true;
    }

    public function generateAllBoards():void {
        if (_boardsContent != null) {
            _boards = SLTLevelBoardParser.parseLevelBoards(_boardsContent, _levelSettings);
        }
    }

    public function generateBoard(boardId:String):void {
        if (_boardsContent != null) {
            _boards[boardId] = SLTLevelBoardParser.parseLevelBoard(boardId, _boardsContent, _levelSettings);
        }
    }

    internal function dispose():void {
        //TODO @GSAR: implement
    }

}
}
