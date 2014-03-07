/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: sarg
 * Date: 4/12/12
 * Time: 7:27 PM
 */
package saltr.parser.gameeditor.chunk {
public class SLTAssetInChunk {
    private var _id:String;
    private var _count:uint;
    private var _stateId:String;

    public function SLTAssetInChunk(id:String, count:uint, stateId:String) {
        _id = id;
        _count = count;
        _stateId = stateId;
    }

    public function get id():String {
        return _id;
    }

    public function get count():uint {
        return _count;
    }

    public function get stateId():String {
        return _stateId;
    }
}
}
