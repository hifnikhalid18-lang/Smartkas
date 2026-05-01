import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  String _username = 'KasKu User';
  String _defaultFilter = 'Semua';

  SettingsProvider() {
    _loadSettings();
  }

  String get username => _username;
  String get defaultFilter => _defaultFilter;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? 'KasKu User';
    _defaultFilter = prefs.getString('default_filter') ?? 'Semua';
    notifyListeners();
  }

  Future<void> setUsername(String name) async {
    _username = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
    notifyListeners();
  }

  Future<void> setDefaultFilter(String filter) async {
    _defaultFilter = filter;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('default_filter', filter);
    notifyListeners();
  }
}

final settingsProvider = SettingsProvider();
