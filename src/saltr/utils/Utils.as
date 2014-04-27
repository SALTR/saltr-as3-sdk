/**
 * User: gsar
 * Date: 4/27/14
 * Time: 8:37 PM
 */
package saltr.utils {
import flash.utils.Dictionary;

public class Utils {
    public function Utils() {
    }

    /** Formats a String in .Net-style, with curly braces ("{0}"). Does not support any
     *  number formatting options yet. */
    public static function formatString(format:String, ...args):String {
        for (var i:int = 0; i < args.length; ++i)
            format = format.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);

        return format;
    }

    public static function getDictionarySize(dictionary:Dictionary):int {
        var count:int = 0;
        for (var i:String in dictionary) {
            ++count;
        }

        return count;
    }

}
}
