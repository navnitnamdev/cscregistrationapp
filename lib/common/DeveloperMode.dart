import 'package:flutter/services.dart';

class DeveloperMode {
  static const platform = MethodChannel('com.example.developerMode');

  static Future<bool> checkDeveloperMode() async {
    try {
      final bool isEnabled = await platform.invokeMethod('checkDeveloperMode');
      return isEnabled;
    } on PlatformException catch (e) {
      print("Failed to check Developer Mode: '${e.message}'.");
      return false;
    }
  }
}
