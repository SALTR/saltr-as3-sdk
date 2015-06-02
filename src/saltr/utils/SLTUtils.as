/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.utils {
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;

import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The SLTUtils class provides utility functions.
 * @private
 */
public class SLTUtils {

    /**
     * Class constructor.
     */
    public function SLTUtils() {
    }

    /**
     * Formats a String in .Net-style, with curly braces ("{0}").
     * Does not support any number formatting options yet.
     * @param format The string to format.
     * @return Formatted string.
     */
    saltr_internal static function formatString(format:String, ...args):String {
        for (var i:int = 0; i < args.length; ++i)
            format = format.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);

        return format;
    }

    /**
     * Provides the size of dictionary.
     * @param dictionary The dictionary which size needs to calculate.
     * @return The size of dictionary.
     */
    saltr_internal static function getDictionarySize(dictionary:Dictionary):int {
        var count:int = 0;
        for (var i:String in dictionary) {
            ++count;
        }

        return count;
    }

    /**
     * Checks the email validity.
     * @param email The email to check.
     * @return <code>true</code> if valid.
     */
    saltr_internal static function checkEmailValidation(email:String):Boolean {
        var emailExpression:RegExp = /([a-z0-9._-]+?)@([a-z0-9.-]+)\.([a-z]{2,4})/;
        return emailExpression.test(email);
    }

    /**
     * Shuffle vector.
     * @param vect The vector to shuffle.
     */
    saltr_internal static function shuffleVector(vect:Object):void {
        var totalItems:uint = vect.length;
        for (var i:uint = 0; i < totalItems; ++i) {
            swapVectorItems(vect, i, i + uint(Math.random() * (totalItems - i)));
        }
    }

    /**
     * Swap vector items.
     * @param vect The vector.
     * @param a The item one index
     * @param b The item two index
     */
    saltr_internal static function swapVectorItems(vect:Object, a:uint, b:uint):void {
        var temp:Object = vect[a];
        vect[a] = vect[b];
        vect[b] = temp;
    }

    /**
     * Clone object.
     * @param object The object.
     */
    saltr_internal static function cloneObject(object:Object):Object {
        if (object is Number || object is String || object is Boolean || object == null) {
            return object;
        } else if (object is Array) {
            var array:Array = object as Array;
            var arrayClone:Array = [];
            var length:int = array.length;
            for (var i:int = 0; i < length; ++i) arrayClone[i] = cloneObject(array[i]);
            return arrayClone;
        } else {
            var objectClone:Object = {};
            var typeDescription:XML = null;

            if (getQualifiedClassName(object) == "Object") {
                for (var key:String in object)
                    objectClone[key] = cloneObject(object[key]);
            } else {
                typeDescription = describeType(object);
                var properties:XMLList = typeDescription.variable + typeDescription.accessor;

                for each (var property:XML in properties) {
                    var propertyName:String = property.@name.toString();
                    var access:String = property.@access.toString();
                    var nonSerializedMetaData:XMLList = property.metadata.(@name == "NonSerialized");

                    if (access != "writeonly" && nonSerializedMetaData.length() == 0) {
                        objectClone[propertyName] = cloneObject(object[propertyName]);
                    }
                }
            }
            return objectClone;
        }
    }
}
}
