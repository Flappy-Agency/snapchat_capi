import 'package:flutter_test/flutter_test.dart';
import 'package:snapchat_capi/normalizer.dart';

void main() {
  group('Test normalizer', () {
    test('Should normalize ThomasEcalle@gmail.com', () {
      final normalizedValue = Normalizer.normalize('ThomasEcalle @gmail.com');
      expect(normalizedValue, 'thomasecalle@gmail.com');
    });

    test('Should encrypt to sha256 value', () {
      const value = 'Coucou';
      final encryptedValue = Normalizer.hash(value);
      expect(encryptedValue, '11df1b59ae8a206b9dd1fc76fe629fa48e2f6ecbbf14b12843869af295d8c425');
    });

    test('other encryption test', () {
      const value = 'thomasecalle@gmail.com';
      final encryptedValue = Normalizer.hash(value);
      expect(encryptedValue, '934473d14050c2bfc1f8ca64b77d1925c6e8d7b9626ecc8f17eb8336eb8b0b3f');
    });
  });
}
