import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import '../customwidgets/CustomHelper.dart';

class PermissionHelper {

  /// Request Location Permission
  static Future<bool> requestLocationPermission(BuildContext context) async {
    PermissionStatus locationStatus = await Permission.location.status;

    if (locationStatus.isGranted) {
      print("Location permission already granted.");
      return true;
    } else if (locationStatus.isDenied) {
      locationStatus = await Permission.location.request();

      if (locationStatus.isGranted) {
        print("Location permission granted.");
        return true;
      } else {
        CustomHelper.showToast(context, "Allow location permission");
        CustomHelper.showCustomAlertDialogDeveloperMode(
          context: context,
          title: "CSC APP",
          description: "Allow location permission for access lat long ",
          onOkPressed: () async {
            await Permission.location.request();

          },
          backgroundColor: Colors.white,
          titleBackgroundColor: Colors.blue,
          buttonColor: Colors.blue,
        );
      }
    } else if (locationStatus.isPermanentlyDenied) {
      print("Location permission permanently denied. Redirecting to settings...");
      await openAppSettings();
    }

    return false;
  }

  /// Request Camera Permission
  static Future<bool> requestCameraPermission(BuildContext context) async {
    PermissionStatus cameraStatus = await Permission.camera.status;

    if (cameraStatus.isGranted) {
      print("Camera permission already granted.");
      return true;
    } else if (cameraStatus.isDenied) {
      cameraStatus = await Permission.camera.request();

      if (cameraStatus.isGranted) {
        print("Camera permission granted.");
        return true;
      } else {
        CustomHelper.showToast(context, "Allow camera permission");
        CustomHelper.showCustomAlertDialogDeveloperMode(
          context: context,
          title: "CSC APP",
          description: "Allow camera permission for video recording",
          onOkPressed: () async {
            await Permission.camera.request();

          },
          backgroundColor: Colors.white,
          titleBackgroundColor: Colors.blue,
          buttonColor: Colors.blue,
          buttonTextColor: Colors.white,
        );
      }
    } else if (cameraStatus.isPermanentlyDenied) {
      print("Camera permission permanently denied. Redirecting to settings...");
      await openAppSettings();
    }
    return false;
  }

  /// Request Microphone Permission for Video Recording
  static Future<bool> requestMicrophonePermission(BuildContext context) async {
    PermissionStatus microphoneStatus = await Permission.microphone.status;

    if (microphoneStatus.isGranted) {
      print("Microphone permission already granted.");
      return true;
    } else if (microphoneStatus.isDenied) {
      microphoneStatus = await Permission.microphone.request();

      if (microphoneStatus.isGranted) {
        print("Microphone permission granted.");
        return true;
      } else {
        CustomHelper.showToast(context, "Allow Microphone permission");
        CustomHelper.showCustomAlertDialogDeveloperMode(
          context: context,
          title: "CSC APP",
          description: "Allow Microphone permission for access recording ",
          onOkPressed: () async {
            await Permission.microphone.request();

          },
          backgroundColor: Colors.white,
          titleBackgroundColor: Colors.blue,
          buttonColor: Colors.blue,
          buttonTextColor: Colors.white,
        );
      }
    } else if (microphoneStatus.isPermanentlyDenied) {
      print("Microphone permission permanently denied. Redirecting to settings...");
      await openAppSettings();
    }
    return false;
  }

}

