import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:typed_data';

class EncHelper {
// Convert BigInt to Uint8List (byte array)
  static Uint8List _bigIntToBytes(BigInt number) {
    // Convert BigInt to byte array
    var byteArray = number.toRadixString(16).padLeft(64, '0');
    return Uint8List.fromList(
        List.generate(byteArray.length ~/ 2, (i) => int.parse(byteArray.substring(i * 2, i * 2 + 2), radix: 16)));
  }

  static convertToKey(BigInt tlpAnswer) {
    Uint8List aesKey = _bigIntToBytes(tlpAnswer);

    // Ensure the key is exactly 32 bytes (256 bits)
    if (aesKey.length > 32) {
      // Truncate the key to 32 bytes
      aesKey = aesKey.sublist(0, 32);
    } else if (aesKey.length < 32) {
      // Pad the key to 32 bytes
      Uint8List paddedKey = Uint8List(32);
      paddedKey.setAll(32 - aesKey.length, aesKey);
      aesKey = paddedKey;
    }

    final key = encrypt.Key(aesKey);
    return key.base64;
  }
}
