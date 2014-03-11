/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: sarg
 * Date: 11/9/12
 * Time: 4:51 PM
 */
package saltr.parser.game {
public class SLTCell {
    private var _x:int;
    private var _y:int;
    private var _properties:Object;
    private var _isBlocked:Boolean;
    private var _assetInstance:SLTAssetInstance;

    public function SLTCell(x:int, y:int) {
        _x = x;
        _y = y;
        _properties = {};
        _isBlocked = false;
    }

    public function get assetInstance():SLTAssetInstance {
        return _assetInstance;
    }

    public function set assetInstance(value:SLTAssetInstance):void {
        _assetInstance = value;
    }

    public function set properties(value:Object):void {
        _properties = value;
    }

    public function set isBlocked(value:Boolean):void {
        _isBlocked = value;
    }

    public function get properties():Object {
        return _properties;
    }

    public function get isBlocked():Boolean {
        return _isBlocked;
    }

    public function get x():int {
        return _x;
    }

    public function get y():int {
        return _y;
    }

    public function set y(value:int):void {
        _y = value;
    }

    public function set x(value:int):void {
        _x = value;
    }
}
}
