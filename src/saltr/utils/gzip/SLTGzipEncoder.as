/**
 * Created by @ahak on 5/2/2018.
 */
package saltr.utils.gzip {
import flash.errors.IllegalOperationError;
import flash.system.Capabilities;
import flash.utils.ByteArray;
import flash.utils.CompressionAlgorithm;

import saltr.saltr_internal;

use namespace saltr_internal;

public class SLTGzipEncoder {
    //http://www.zlib.org/rfc-gzip.html
    // +---+---+---+---+---+---+---+---+---+---+
    //|ID1|ID2|CM |FLG|     MTIME     |XFL|OS |
    //  +---+---+---+---+---+---+---+---+---+---+

    // These have the fixed values id1 = 31 (0x1f, \037), id2 = 139 (0x8b, \213), to identify the file as being in gzip format.
    //CM (Compression Method)
    // This identifies the compression method used in the file. CM = 0-7 are reserved. CM = 8 denotes the "deflate" compression method, which is the one customarily used by gzip and which is documented elsewhere
    //   flg (FLaGs)
    // This flag byte is divided into individual bits as follows:
    //bit 0   FTEXT, bit 1   FHCRC, bit 2   FEXTRA, bit 3   FNAME, bit 4   FCOMMENT, bit 5   reserved, bit 6   reserved, bit 7   reserved
    //GZIP_FORMAT=0xflgCmId2Id1,
    private static const GZIP_FORMAT:uint = 0x00088b1f;
    private static const COMPRESSOR_FASTEST_ALGORITHM:uint = 4;

    public static function compress(source:ByteArray, outStream:ISLTGzip, useCopyOfSource:Boolean = true):ISLTGzip {
        if (source == null) {
            throw new ArgumentError("src can't be null.");
        }
        var srcBytes:ByteArray;
        if (useCopyOfSource) {
            srcBytes = new ByteArray();
            srcBytes.writeBytes(source);
        } else {
            srcBytes = source;
        }
        outStream.writeUnsignedInt(GZIP_FORMAT);
        // 4 bytes MTIME
        outStream.writeUnsignedInt(0);
        outStream.writeByte(COMPRESSOR_FASTEST_ALGORITHM);
        var os:uint;
        if (Capabilities.os.indexOf("Windows") >= 0) {
            os = 11; // NTFS -- WinXP, Win2000, WinNT
        } else if (Capabilities.os.indexOf("Mac OS") >= 0 || (Capabilities.os.indexOf("iPhone") >= 0 )) {
            os = 7; // Macintosh
        } else { // Linux is the only other OS supported by Adobe AIR
            os = 3; // Unix
        }
        outStream.writeByte(os);
        var isize:uint = source.length % Math.pow(2, 32);

        source.deflate();

        outStream.writeBytes(source, 0, source.length);

        // 4 bytes CRC32
        outStream.writeUnsignedInt(0);

        // 4 bytes ISIZE (This contains the size of the original (uncompressed) input data modulo 2^32.)
        outStream.writeUnsignedInt(isize);
        return outStream;
    }

    public static function uncompressToObject(src:ISLTGzip):Object {
        var out:ByteArray = parseGZIPData(src);
        out.uncompress(CompressionAlgorithm.DEFLATE);
        return out.readObject();
    }

    public static function uncompressToByteArray(src:ISLTGzip):ByteArray {
        var out:ByteArray = parseGZIPData(src);
        out.uncompress(CompressionAlgorithm.DEFLATE);
        return out;
    }

    private static function parseGZIPData(src:ISLTGzip):ByteArray {
        //result=0xflgCmId2Id1, flg=0xE0 reserved bits flg=11100000=0xE0
        var result:uint = src.readUnsignedInt();

        if ((result & 0xE0FFFFFF) != GZIP_FORMAT) {
            throw new IllegalOperationError("GZIP file structure error.");
        }

        var flg:int = result & 0xFF000000;
        // If FTEXT is set, the file is probably ASCII text
        var fText:Boolean = (flg & 1) == 1;

        // If FHCRC is set, a CRC16 for the gzip header is present, immediately before the compressed data.2 bytes CRC16
        if (((flg >> 1) & 1) == 1) {
            var fhcrc:int = src.readUnsignedShort();
        }

        // If FEXTRA is set, optional extra fields are present
        if (((flg >> 2) & 1) == 1) {
            var extra:String = src.readUTF();
        }

        // If FNAME is set, an original file name is present, terminated by a zero byte.
        var originalFileName:String = null;
        if (((flg >> 3) & 1) == 1) {
            originalFileName = convertBytesToString(src);
        }
        // If FCOMMENT is set, a zero-terminated file comment is present.
        var fcomment:String;
        if (((flg >> 4) & 1) == 1) {
            fcomment = convertBytesToString(src)
        }
        // 4 bytes MTIME (This gives the most recent modification time of the original file being compressed. The time is in Unix format, i.e., seconds since 00:00:00 GMT, Jan. 1, 1970. )
        // 1 byte XFL (flags used by specific compression methods)
        // 1 byte OS. This identifies the type of file system on which compression took place
        src.position += 6;

        // Actual compressed data (up to end - 8 bytes)
        //8 bytes= 4 bytes CRC32+4 bytes ISIZE
        var dataSize:int = src.bytesAvailable - 8;
        var data:ByteArray = new ByteArray();
        src.readBytes(data, 0, dataSize);
        return data;
    }

    private static function convertBytesToString(src:ISLTGzip):String {
        var result:ByteArray = new ByteArray();
        var unsignedByte:uint = src.readUnsignedByte();
        while (unsignedByte != 0) {
            result.writeByte(unsignedByte);
            unsignedByte = src.readUnsignedByte();
        }
        result.position = 0;
        return result.readUTFBytes(result.length);
    }

}
}
