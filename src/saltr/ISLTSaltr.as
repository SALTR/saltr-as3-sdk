/**
 * Created by daal on 4/7/16.
 */
package saltr {
import saltr.game.SLTLevel;
import saltr.lang.SLTLocale;

public interface ISLTSaltr {
    function start():void;

    function connect(successCallback:Function, failCallback:Function, basicProperties:SLTBasicProperties, customProperties:Object = null):void;

    function ping(successCallback:Function = null, failCallback:Function = null):void;

    function initLevelContent(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function, fromSaltr:Boolean = false):void;

    function initLanguageContent(localizationFeatureToken:String, sltLocale:SLTLocale, callback:Function, fromSaltr:Boolean = false):void;

    function addProperties(basicProperties:Object = null, customProperties:Object = null):void;

    function sendLevelEndEvent(variationId:String, endStatus:String, endReason:String, score:int, customTextProperties:Array, customNumbericProperties:Array):void;

    function getLocalizationProperties(token:String):SLTLocalizationData;

    function getActiveLanguageList(token:String):Array;

    function sendLevelReport(successCallback:Function, failCallback:Function, properties:Object):void;

    function addValidator(featureToken:String, validator:Function):void;

    function get appData():SLTAppData;
}
}
