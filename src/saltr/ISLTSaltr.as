/**
 * Created by daal on 4/7/16.
 */
package saltr {
import saltr.game.SLTLevel;

public interface ISLTSaltr {

    function start():void;
    function connect(successCallback:Function, failCallback:Function, basicProperties:SLTBasicProperties, customProperties:Object = null):void;
    function ping(successCallback:Function = null, failCallback:Function = null):void;
    function initLevelContentLocally(gameLevelsFeatureToken:String, sltLevel:SLTLevel):Boolean;
    function initLevelContentFromSaltr(gameLevelsFeatureToken:String, sltLevel:SLTLevel, callback:Function):void;
    function addProperties(basicProperties:Object = null, customProperties:Object = null):void;
    function sendLevelEndEvent(variationId:String, endStatus:String, endReason:String, score:int, customTextProperties:Array, customNumbericProperties:Array):void;
}
}
