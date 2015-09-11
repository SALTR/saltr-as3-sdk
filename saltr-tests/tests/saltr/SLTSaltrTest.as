/**
 * Created by TIGR on 5/12/2015.
 */
package tests.saltr {
import saltr.SLTConfig;
import saltr.SLTSaltrMobile;
import saltr.SLTSaltrWeb;
import saltr.game.SLTLevel;
import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTSaltrTest {
    public static const GAME_LEVELS_FEATURE:String = SLTConfig.DEFAULT_GAME_LEVELS_FEATURE_TOKEN;
    private var _saltrMobile:SLTSaltrMobile;
    private var _saltrWeb:SLTSaltrWeb;
    private var _isSaltrMobile:Boolean;

    public function SLTSaltrTest() {
    }

    protected function setSaltrMobile(saltr:SLTSaltrMobile):void {
        _saltrMobile = saltr;
        _isSaltrMobile = true;
    }

    protected function setSaltrWeb(saltr:SLTSaltrWeb):void {
        _saltrWeb = saltr;
        _isSaltrMobile = false;
    }

    protected function clearSaltr():void {
        _saltrMobile = null;
        _saltrWeb = null;
    }

    protected function allLevelsTestPassed():Boolean {
        var testPassed:Boolean = false;
        if (_isSaltrMobile) {
            testPassed = 75 == _saltrMobile.getGameLevelFeatureProperties("GAME_LEVELS").allLevelsCount;
        } else {
            testPassed = 75 == _saltrWeb.allLevelsCount;
        }
        return testPassed;
    }

    protected function defineFeatureTestPassed():Boolean {
        var testPassed:Boolean = false;
        if (_isSaltrMobile) {
            _saltrMobile.defineGenericFeature("SETTINGS", getDefineFeatureTestObject(), true);
            _saltrMobile.getFeatureProperties("SETTINGS");
            testPassed = 30 == _saltrMobile.getFeatureProperties("SETTINGS").general.lifeRefillTime;
        } else {
            _saltrWeb.defineFeature("SETTINGS", getDefineFeatureTestObject(), true);
            _saltrWeb.getFeatureProperties("SETTINGS");
            testPassed = 30 == _saltrWeb.getFeatureProperties("SETTINGS").general.lifeRefillTime;
        }
        return testPassed;
    }

    protected function getLevelByGlobalIndexWithValidIndexTestPassed():Boolean {
        var level:SLTLevel;
        if (_isSaltrMobile) {
            level = _saltrMobile.getGameLevelFeatureProperties(GAME_LEVELS_FEATURE).getLevelByGlobalIndex(20);
        } else {
            level = _saltrWeb.getLevelByGlobalIndex(20);
        }
        return 5 == level.localIndex;
    }

    protected function getLevelByGlobalIndexWithInvalidIndexPassed():Boolean {
        var level:SLTLevel;
        if (_isSaltrMobile) {
            level = _saltrMobile.getGameLevelFeatureProperties(GAME_LEVELS_FEATURE).getLevelByGlobalIndex(-1);
        } else {
            level = _saltrWeb.getLevelByGlobalIndex(-1);
        }
        return null == level;
    }

    private function getDefineFeatureTestObject():Object {
        return {
            general: {
                lifeRefillTime: 30
            }
        };
    }
}
}
