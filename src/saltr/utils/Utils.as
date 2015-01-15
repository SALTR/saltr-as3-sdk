/*
 * Copyright (c) 2014 Plexonic Ltd
 */

package saltr.utils {
import flash.utils.Dictionary;
import saltr.saltr_internal;

use namespace saltr_internal;

/**
 * The Utils class provides utility functions.
 */
public class Utils {

    /**
     * Class constructor.
     */
    public function Utils() {
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
}
}
