/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: dale
 * Date: 12/3/12
 * Time: 5:28 PM
 */
package saltr {


//TODO @GSAR: Rename to handle USER properties separately, and Partner data separately may be?
internal class Partner {

    private var _partnerId:String;
    private var _partnerType:String;
//    private var _firstName:String;
//    private var _lastName:String;
//    private var _gender:String;
//    private var _age:uint;

    public function Partner(partnerId:String = null, partnerType:String = null) {

    }

    public function get partnerId():String {
        return _partnerId;
    }

    public function get partnerType():String {
        return _partnerType;
    }


//    public function get gender():String {
//        return _gender;
//    }
//
//    public function set gender(value:String):void {
//        _gender = value;
//    }
//
//    public function get age():uint {
//        return _age;
//    }
//
//    public function set age(value:uint):void {
//        _age = value;
//    }
//
//    public function get firstName():String {
//        return _firstName;
//    }
//
//    public function set firstName(value:String):void {
//        _firstName = value;
//    }
//
//    public function get lastName():String {
//        return _lastName;
//    }
//
//    public function set lastName(value:String):void {
//        _lastName = value;
//    }
}
}
