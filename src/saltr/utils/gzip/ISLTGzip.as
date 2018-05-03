/**
 * Created by @ahak on 5/3/2018.
 */
package saltr.utils.gzip {
import flash.utils.ByteArray;

public interface ISLTGzip {
    function readUnsignedShort():uint;

    function readUTF():String;

    function readUnsignedInt():uint;

    function get position():Number;

    function set position(value:Number):void;

    function get bytesAvailable():uint;

    function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void;

    function readUnsignedByte():uint;

    function writeBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void;

    function writeUnsignedInt(value:uint):void;

    function writeByte(value:int):void;
}
}
