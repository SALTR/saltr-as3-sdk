/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr {
import saltr.parser.game.SLTLevel;
import saltr.parser.game.SLTLevelPack;
import saltr.repository.ISLTRepository;

public interface IMobileSaltr {

    function set appVersion(value:String):void

    function set useNoLevels(value:Boolean):void

    function set useNoFeatures(value:Boolean):void

    function set requestIdleTimeout(value:int):void

    function get levelPacks():Vector.<SLTLevelPack>

    function get experiments():Vector.<SLTExperiment>

    function set repository(value:ISLTRepository):void

    function setSocial(socialId:String, socialNetwork:String):void

    function getActiveFeatureTokens():Vector.<String>

    function getFeatureProperties(token:String):Object

    function connect(successCallback:Function, failCallback:Function):void

    function defineFeature(token:String, properties:Object, required:Boolean = false):void

    function loadLevelContent(sltLevel:SLTLevel, sltLevelPack:SLTLevelPack, successCallback:Function, failCallback:Function, useCache:Boolean = true):void

}
}
