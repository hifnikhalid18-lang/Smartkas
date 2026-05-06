import 'package:flutter/material.dart';
import '../services/secure_storage_service.dart';

class SecurityProvider extends ChangeNotifier {
  bool _isLocked = false;
  bool _pinEnabled = false;

  SecurityProvider() {
    _loadSecurityStatus();
  }

  bool get isLocked => _isLocked;
  bool get pinEnabled => _pinEnabled;

  Future<void> _loadSecurityStatus() async {
    _pinEnabled = await SecureStorageService.isPINEnabled();
    // If PIN is enabled, app should start in locked state
    _isLocked = _pinEnabled;
    notifyListeners();
  }

  void unlock() {
    _isLocked = false;
    notifyListeners();
  }

  void lock() {
    if (_pinEnabled) {
      _isLocked = true;
      notifyListeners();
    }
  }

  Future<void> togglePIN(bool enabled, String pin) async {
    _pinEnabled = enabled;
    await SecureStorageService.setPINEnabled(enabled);
    if (enabled) {
      await SecureStorageService.savePIN(pin);
    }
    notifyListeners();
  }

  Future<bool> verifyPIN(String pin) async {
    final savedPIN = await SecureStorageService.getPIN();
    return savedPIN == pin;
  }

  Future<void> updatePIN(String newPin) async {
    await SecureStorageService.savePIN(newPin);
    notifyListeners();
  }
}

final securityProvider = SecurityProvider();
