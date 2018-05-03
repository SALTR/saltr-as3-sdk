/**
 * Created by @ahak on 5/3/2018.
 */
package saltr.utils.gzip {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;
import flash.utils.Endian;

public class SLTGzipFile implements ISLTGzip {
    public static function getObjectFromFile(fileStream:FileStream, file:File):Object {
        var data:ByteArray = getUncompressedByteArrayFromFile(fileStream, file);
        return data.readObject();
    }

    public static function getUncompressedByteArrayFromFile(fileStream:FileStream, file:File):ByteArray {
        fileStream.open(file, FileMode.READ);
        var data:ByteArray = SLTGzipEncoder.uncompressToByteArray(new SLTGzipFile(fileStream));
        fileStream.close();
        return data;
    }

    public static function compressByteArrayToFile(source:ByteArray, fileStream:FileStream, file:File, useCopyOfSource:Boolean = true):void {
        fileStream.open(file, FileMode.WRITE);
        SLTGzipEncoder.compress(source, new SLTGzipFile(fileStream), null, useCopyOfSource);
        fileStream.close();
    }

    public static function compressObjectToFile(src:Object, fileStream:FileStream, file:File):void {
        var byteArray:ByteArray = new ByteArray();
        byteArray.writeObject(src);
        compressByteArrayToFile(byteArray, fileStream, file, false);
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private var _fileStream:FileStream;

    public function SLTGzipFile(fileStream:FileStream) {
        _fileStream = fileStream;
        fileStream.endian = Endian.LITTLE_ENDIAN;
    }

    public function readUnsignedShort():uint {
        return _fileStream.readUnsignedShort();
    }

    public function readUTF():String {
        return _fileStream.readUTF();
    }

    public function readUnsignedInt():uint {
        return _fileStream.readUnsignedInt();
    }

    public function get position():Number {
        return _fileStream.position;
    }

    public function set position(value:Number):void {
        _fileStream.position = value;
    }

    public function get bytesAvailable():uint {
        return _fileStream.bytesAvailable;
    }

    public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {
        _fileStream.readBytes(bytes, offset, length);
    }

    public function readUnsignedByte():uint {
        return _fileStream.readUnsignedByte();
    }

    public function writeBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {
        _fileStream.writeBytes(bytes, offset, length);
    }

    public function writeUnsignedInt(value:uint):void {
        _fileStream.writeUnsignedInt(value);
    }

    public function writeByte(value:int):void {
        _fileStream.writeByte(value);
    }
}
}
