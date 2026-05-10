import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/local_notification_service.dart';

class SettingsProvider extends ChangeNotifier {
  String _username = 'Smartkas User';
  String _defaultFilter = 'Semua';
  bool _isReminderEnabled = false;
  int _reminderHour = 20;
  int _reminderMinute = 0;

  SettingsProvider() {
    _loadSettings();
  }

  String get username => _username;
  String get defaultFilter => _defaultFilter;
  bool get isReminderEnabled => _isReminderEnabled;
  int get reminderHour => _reminderHour;
  int get reminderMinute => _reminderMinute;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? 'Smartkas User';
    _defaultFilter = prefs.getString('default_filter') ?? 'Semua';
    _isReminderEnabled = prefs.getBool('is_reminder_enabled') ?? false;
    _reminderHour = prefs.getInt('reminder_hour') ?? 20;
    _reminderMinute = prefs.getInt('reminder_minute') ?? 0;
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

  Future<void> toggleReminder(bool enabled) async {
    _isReminderEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_reminder_enabled', enabled);
    
    if (enabled) {
      _scheduleNotification();
    } else {
      await LocalNotificationService.cancelNotification(101);
    }
    
    notifyListeners();
  }

  Future<void> setReminderTime(int hour, int minute) async {
    _reminderHour = hour;
    _reminderMinute = minute;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_hour', hour);
    await prefs.setInt('reminder_minute', minute);
    
    if (_isReminderEnabled) {
      _scheduleNotification();
    }
    
    notifyListeners();
  }

  void _scheduleNotification() {
    LocalNotificationService.scheduleDailyNotification(
      id: 101,
      title: 'Ingat Catat Transaksi!',
      body: 'Jangan lupa catat transaksi hari ini agar keuangan tetap terpantau.',
      hour: _reminderHour,
      minute: _reminderMinute,
    );
  }
}

final settingsProvider = SettingsProvider();
