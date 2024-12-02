import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/asn1.dart';
import 'dart:math';

class DeviceFingerprint {
  static Future<String> getFingerprint({bool isAnnon = false}) async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final info = (await deviceInfo.deviceInfo).data;
      final deviceData = jsonEncode(info);
      final fingerprint = sha256.convert(utf8.encode(deviceData)).toString();
      if (!isAnnon) {
        return fingerprint;
      }
      final pKData = jsonEncode(encryptAndReturnPublicKey(fingerprint));
      final pk = sha256.convert(utf8.encode(pKData)).toString();

      return pk;
    } catch (e) {
      if (kDebugMode) {
        print("Error generating fingerprint: $e");
      }
      return "";
    }
  }

  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair() {
    final secureRandom = FortunaRandom();
    final random = Random.secure();
    final seeds = List<int>.generate(32, (_) => random.nextInt(255));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    final keyGen = RSAKeyGenerator();
    final params = RSAKeyGeneratorParameters(
      BigInt.parse('65537'), // Public exponent
      2048, // Key length
      64, // Certainty
    );

    keyGen.init(ParametersWithRandom(params, secureRandom));

    // Generate key pair and cast individual keys
    final pair = keyGen.generateKeyPair();
    final RSAPublicKey publicKey = pair.publicKey as RSAPublicKey;
    final RSAPrivateKey privateKey = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(publicKey, privateKey);
  }

  static Map<String, String> encryptAndReturnPublicKey(String fingerprint) {
    try {
      final keyPair = generateRSAKeyPair();
      final publicKey = keyPair.publicKey;

      final fingerprintBytes = utf8.encode(fingerprint);
      final cipher = RSAEngine()..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
      final encryptedBytes = cipher.process(Uint8List.fromList(fingerprintBytes));

      final publicKeyDER = ASN1Sequence(
        elements: [
          ASN1Integer(publicKey.modulus!),
          ASN1Integer(publicKey.exponent!),
        ],
      );

      final publicKeyPEM = base64.encode(publicKeyDER.encode());
      final encryptedBase64 = base64.encode(encryptedBytes);

      return {
        'publicKey': '-----BEGIN PUBLIC KEY-----\n$publicKeyPEM\n-----END PUBLIC KEY-----',
        'encryptedFingerprint': encryptedBase64,
      };
    } catch (e) {
      if (kDebugMode) {
        print("Error encrypting fingerprint: $e");
      }
      return {
        'publicKey': '',
        'encryptedFingerprint': '',
      };
    }
  }
}
