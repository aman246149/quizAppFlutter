import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalDb {
  static final LocalDb _instance = LocalDb._internal();
  late SharedPreferences _prefs;

  // Private constructor
  LocalDb._internal();

  // Singleton instance getter
  factory LocalDb() => _instance;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveData(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<String?> getData(String key) async {
    return _prefs.getString(key);
  }

  Future<void> removeData(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }

  bool hasData(String key) {
    return _prefs.containsKey(key);
  }
}
