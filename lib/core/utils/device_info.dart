import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfo {
  static final DeviceInfo _instance = DeviceInfo._internal();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  DeviceInfo._internal();
  factory DeviceInfo() => _instance;

  Future<String> getDeviceIdentifier() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfo.webBrowserInfo;
        return webInfo.userAgent ?? 'unknown';
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id; // Returns the Android ID
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ??
            'unknown'; // Returns the Vendor ID
      }
      return 'unknown_platform';
    } catch (e) {
      debugPrint('Error getting device identifier: $e');
      return 'unknown_error';
    }
  }
}
