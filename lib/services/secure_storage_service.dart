import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const _pinKey = 'app_pin_code';
  static const _pinEnabledKey = 'app_pin_enabled';

  static Future<void> savePIN(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  static Future<String?> getPIN() async {
    return await _storage.read(key: _pinKey);
  }

  static Future<void> setPINEnabled(bool enabled) async {
    await _storage.write(key: _pinEnabledKey, value: enabled.toString());
  }

  static Future<bool> isPINEnabled() async {
    final value = await _storage.read(key: _pinEnabledKey);
    return value == 'true';
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
