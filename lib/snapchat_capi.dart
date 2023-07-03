library snapchat_capi;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:snapchat_capi/normalizer.dart';

import 'event_type.dart';

const String _apiBaseUrl = 'https://tr.snapchat.com/v2/conversion';

class SnapchatCAPI {
  static SnapchatCAPI? _instance;

  final String apiKey;
  final String appId;
  final String snapAppId;
  final bool testMode;

  String? advertisingId;
  String? _userEmail;
  String? _userPhoneNumber;

  SnapchatCAPI._internal({
    required this.apiKey,
    required this.appId,
    required this.snapAppId,
    this.testMode = false,
    this.advertisingId,
  });

  static void initialize({
    required String apiKey,
    required String appId,
    required String snapAppId,
    bool testMode = false,
    String? advertisingId,
  }) {
    _instance = SnapchatCAPI._internal(
      apiKey: apiKey,
      appId: appId,
      snapAppId: snapAppId,
      testMode: testMode,
      advertisingId: advertisingId,
    );
  }

  static SnapchatCAPI get instance {
    if (_instance == null) {
      throw Exception('SnapchatCAPI is not initialized');
    }
    return _instance!;
  }

  void setUserEmail(String? email) {
    _userEmail = email;
  }

  void setUserPhoneNumber(String? phoneNumber) {
    _userPhoneNumber = phoneNumber;
  }

  Future<bool> sendEvent({
    required EventType eventType,
    String price = '',
    String currency = '',
  }) async {
    try {
      final urlEnd = testMode ? '/validate' : '';
      final url = '$_apiBaseUrl$urlEnd';

      final normalizedPhoneNumber = _normalizePhoneNumber(_userPhoneNumber);

      final response = await http.post(
        Uri.parse(url),
        headers: _buildHeaders(),
        body: json.encode({
          'app_id': appId,
          'snap_app_id': snapAppId,
          'timestamp': _currentTimeStamp.toString(),
          'event_type': eventType.value,
          'event_conversion_type': 'MOBILE_APP',
          'hashed_email': _hashValue(_userEmail),
          'hashed_phone_number': _hashValue(normalizedPhoneNumber),
          'hashed_mobile_ad_id': _hashValue(advertisingId),
          'price': price,
          'currency': currency,
        }),
      );

      if (response.statusCode != 200) {
        _print('Error trying to send event to SnapchatCAPI: ${response.body}');
        throw Exception('Error trying to send event to SnapchatCAPI: ${response.body}');
      }

      _print('SnapchatCAPI event sent successfully');
      _print('Response: ${response.body}');

      return true;
    } catch (error) {
      _print('Error trying to send event to SnapchatCAPI: $error');
      rethrow;
    }
  }

  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
  }

  int get _currentTimeStamp => DateTime.now().millisecondsSinceEpoch;

  String _normalizePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) return '';

    phoneNumber = phoneNumber.toLowerCase().replaceAll(' ', '').trim();

    final handledCountryCodes = ['+33', '+32', '+44'];
    String phoneNumberWithoutCountryCode = '';
    String phoneNumberCountryCode = '';

    for (final countryCode in handledCountryCodes) {
      if (phoneNumber.startsWith(countryCode)) {
        phoneNumberWithoutCountryCode = phoneNumber.replaceFirst(countryCode, '');
        phoneNumberCountryCode = countryCode.replaceAll('+', '');
        break;
      }
    }

    if (phoneNumberWithoutCountryCode.isEmpty) {
      return '';
    }

    // remove any double 0 in front of the country code.
    phoneNumberWithoutCountryCode = phoneNumberWithoutCountryCode.replaceAll(RegExp(r'^00'), '');

    // If the number itself begins with a 0,
    if (phoneNumberWithoutCountryCode.startsWith('0')) {
      phoneNumberWithoutCountryCode = phoneNumberWithoutCountryCode.replaceFirst(RegExp(r'^0'), '');
    }

    //exclude any non-numeric characters such as whitespace, parentheses, ‘+’, or ‘-’
    phoneNumberWithoutCountryCode = phoneNumberWithoutCountryCode.replaceAll(RegExp(r'[^0-9]'), '');

    // Add country code at the beginning of the number
    phoneNumberWithoutCountryCode = '$phoneNumberCountryCode$phoneNumberWithoutCountryCode';

    return phoneNumberWithoutCountryCode;
  }

  String _hashValue(String? value) {
    if (value == null || value.isEmpty) return '';
    final normalizedValue = Normalizer.normalize(value);
    return Normalizer.hash(normalizedValue);
  }

  void _print(String message) {
    if (testMode) {
      print('[Snapchat-TestMode] $message');
    }
  }
}
