/**
 * Created by @ahak on 5/3/2018.
 */
package saltr.utils.gzip {
import flash.utils.ByteArray;
import flash.utils.Endian;

public class SLTGzipByteArray implements ISLTGzip {
    private var _byteArray:ByteArray;
    public function SLTGzipByteArray(byteArray:ByteArray) {
        _byteArray = byteArray;
        _byteArray.endian = Endian.LITTLE_ENDIAN;
    }

    public function readUnsignedShort():uint {
        return _byteArray.readUnsignedShort();
    }

    public function readUTF():String {
        return _byteArray.readUTF();
    }

    public function readUnsignedInt():uint {
        return _byteArray.readUnsignedInt();
    }

    public function get position():Number {
        return _byteArray.position;
    }

    public function set position(value:Number):void {
        _byteArray.position = value;
    }

    public function get bytesAvailable():uint {
        return _byteArray.bytesAvailable;
    }

    public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {
        _byteArray.readBytes(bytes, offset, length);
    }

    public function readUnsignedByte():uint {
        return _byteArray.readUnsignedByte();
    }

    public function writeBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {
        _byteArray.writeBytes(bytes, offset, length);
    }

    public function writeUnsignedInt(value:uint):void {
        _byteArray.writeUnsignedInt(value);
    }

    public function writeByte(value:int):void {
        _byteArray.writeByte(value);
    }
}
}
