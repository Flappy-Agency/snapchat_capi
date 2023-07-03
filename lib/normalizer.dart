import 'package:crypto/crypto.dart';

class Normalizer {
  static String normalize(String str) {
    return str.replaceAll(' ', '').toLowerCase().trim();
  }

  static String hash(String str) {
    return sha256.convert(str.codeUnits).toString();
  }
}