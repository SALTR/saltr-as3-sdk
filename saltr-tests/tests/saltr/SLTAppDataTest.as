/**
* Created by TIGR on 4/17/2015.
*/
package tests.saltr {
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;

import saltr.SLTAppData;
import saltr.SLTConfig;
import saltr.SLTFeatureType;
import saltr.saltr_internal;
import saltr.utils.SLTUtils;

use namespace saltr_internal;

/**
* The AppDataTest class contain the AppData method tests
*/
public class SLTAppDataTest {
    [Embed(source="../../../build/tests/saltr/app_data_cache.json", mimeType="application/octet-stream")]
    private static const AppDataJson:Class;

    private var _appData:SLTAppData;

    public function SLTAppDataTest() {
    }

    [Before]
    public function tearUp():void {
        _appData = new SLTAppData();
    }

    [After]
    public function tearDown():void {
        _appData = null;
    }

    /**
     * initEmptyTest.
     * The intent of this test is to check the initEmpty method.
     */
    [Test]
    public function initEmptyTest():void {
        var token:String = "SETTINGS";
        validateFeatureToken(token);
        _appData.defineFeature(token, {
            general: {
                lifeRefillTime: 30
            }
        }, SLTFeatureType.GENERIC, true);
        _appData.initEmpty();
        var tokens:Vector.<String> = _appData.getActiveFeatureTokens();

        var testPassed:Boolean = false;
        if (1 == tokens.length && "SETTINGS" == tokens[0]) {
            testPassed = true;
        }
        assertEquals(true, testPassed);
    }

    /**
     * initWithDataTest.
     * The intent of this test is to check the initWithData method.
     */
    [Test]
    public function initWithDataTest():void {
        _appData.initWithData(JSON.parse(new AppDataJson()));
        assertEquals(1, _appData.experiments.length);
        assertEquals(6, _appData.getActiveFeatureTokens().length);
    }

    /**
     * defineFeatureTestWithIncorrectToken.
     * The intent of this test is to check the defineFeature method with incorrect token. Error should be thrown.
     */
    [Test(expects="Error")]
    public function defineFeatureTestWithIncorrectToken():void {
        var token:String = "SETTINGS INCORRECT";
        validateFeatureToken(token);
        _appData.defineFeature(token, {
            general: {
                lifeRefillTime: 30
            }
        }, SLTFeatureType.GENERIC, true);
    }

    /**
     * defineFeatureTestWithNullToken.
     * The intent of this test is to check the defineFeature method with null token. Error should be thrown.
     */
    [Test(expects="Error")]
    public function defineFeatureTestWithNullToken():void {
        var token:String = null;
        validateFeatureToken(token);
        _appData.defineFeature(token, {
            general: {
                lifeRefillTime: 30
            }
        }, SLTFeatureType.GENERIC, true);
    }

    /**
     * defineFeatureTestWithEmptyToken.
     * The intent of this test is to check the defineFeature method with empty token. Error should be thrown.
     */
    [Test(expects="Error")]
    public function defineFeatureTestWithEmptyToken():void {
        var token:String = "";
        validateFeatureToken(token);
        _appData.defineFeature(token, {
            general: {
                lifeRefillTime: 30
            }
        }, SLTFeatureType.GENERIC, true);
    }

    /**
     * getActiveFeatureTokensTest.
     * The intent of this test is to check the getActiveFeatureTokens method.
     */
    [Test]
    public function getActiveFeatureTokensTest():void {
        var token:String = "SETTINGS";
        validateFeatureToken(token);
        _appData.defineFeature(token, {
            general: {
                lifeRefillTime: 30
            }
        }, SLTFeatureType.GENERIC, true);

        var token2:String = "VALIDATION";
        validateFeatureToken(token2);
        _appData.defineFeature(token2, {
            general: {
                validationTimeout: 50
            }
        }, SLTFeatureType.GENERIC, true);
        _appData.initEmpty();
        var tokens:Vector.<String> = _appData.getActiveFeatureTokens();

        var testPassed:Boolean = false;
        if (2 == tokens.length && -1 != tokens.indexOf("VALIDATION")) {
            testPassed = true;
        }
        assertEquals(true, testPassed);
    }

    /**
     * getFeaturePropertiesWithActiveFeaturesTest.
     * The intent of this test is to check the getFeatureProperties method. In this test active features will be returned.
     */
    [Test]
    public function getFeaturePropertiesWithActiveFeaturesTest():void {
        var token:String = "SETTINGS";
        validateFeatureToken(token);
        _appData.defineFeature(token, {
            general: {
                lifeRefillTime: 30
            }
        }, SLTFeatureType.GENERIC, true);
        _appData.initWithData(JSON.parse(new AppDataJson()));
        assertEquals(5, _appData.getFeatureBody("SETTINGS").general.lifeRefillTime);
    }

    /**
     * getFeaturePropertiesWithDeveloperFeaturesTest.
     * The intent of this test is to check the getFeatureProperties method. In this test developer features will be returned.
     */
    [Test]
    public function getFeaturePropertiesWithDeveloperFeaturesTest():void {
        var token:String = "SETTINGS_DEVELOPER";
        validateFeatureToken(token);
        _appData.defineFeature(token, {
            general: {
                lifeRefillTime: 30
            }
        }, SLTFeatureType.GENERIC, true);
        _appData.initWithData(JSON.parse(new AppDataJson()));
        assertEquals(30, _appData.getFeatureBody("SETTINGS_DEVELOPER").general.lifeRefillTime);
    }

    /**
     * getFeaturePropertiesWithNullResultTest.
     * The intent of this test is to check the getFeatureProperties method. In this test null be returned.
     */
    [Test]
    public function getFeaturePropertiesWithNullResultTest():void {
        var token:String = "SETTINGS_DEVELOPER";
        validateFeatureToken(token);
        _appData.defineFeature(token, {
            general: {
                lifeRefillTime: 30
            }
        }, SLTFeatureType.GENERIC, false);
        _appData.initWithData(JSON.parse(new AppDataJson()));
        assertEquals(null, _appData.getFeatureBody("SETTINGS_DEVELOPER"));
    }
    
    private function validateFeatureToken(token:String):void {
        if (!SLTUtils.validateFeatureToken(token)) {
            throw new Error("feature's token value is incorrect.");
        }
    }
}
}
