/*
 * Copyright Teoken LLC. (c) 2013. All rights reserved.
 * Copying or usage of any piece of this source code without written notice from Teoken LLC is a major crime.
 * Այս կոդը Թեոկեն ՍՊԸ ընկերության սեփականությունն է:
 * Առանց գրավոր թույլտվության այս կոդի պատճենահանումը կամ օգտագործումը քրեական հանցագործություն է:
 */

/**
 * User: daal
 * Date: 12/3/12
 * Time: 5:28 PM
 */
package saltr {


internal class SLTPartner {

    private var _partnerId:String;
    private var _partnerType:String;


    //TODO @GSAR: add strict typing from a static class here for Partner ID and TYPE
    public function SLTPartner(partnerId:String = null, partnerType:String = null) {

    }

    public function get partnerId():String {
        return _partnerId;
    }

    public function get partnerType():String {
        return _partnerType;
    }

}
}
