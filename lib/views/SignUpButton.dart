import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cscapp/common/CommonAppColor.dart';
import 'package:cscapp/customwidgets/CustomHelper.dart';
import 'package:cscapp/views/NewRegInstruction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
 import 'package:permission_handler/permission_handler.dart';
import 'package:root_checker_plus/root_checker_plus.dart';
import '../common/CommonText.dart';
import '../common/PermissionHelper.dart';
import '../common/TextStyle.dart';
import '../customwidgets/CustomElevatedButton.dart';

class SignupButton extends StatefulWidget {
  const SignupButton({super.key});

  @override
  State<SignupButton> createState() => _SignupState();
}

class _SignupState extends State<SignupButton> {
  String? formattedDate;

  bool rootedCheck = false;

  bool jailbreak = false;

  bool devMode = false;

  @override
  void initState() {

    if (Platform.isAndroid) {
      androidRootChecker();
      developerMode();
    }

    if (Platform.isIOS) {
      iosJailbreak();
    }
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy').format(now);

    clearAppCache();
    clearApplicationCache();

    super.initState();
  }

  Future<void> androidRootChecker() async {
    try {
      rootedCheck = (await RootCheckerPlus
          .isRootChecker())!; // return root check status is true or false
    } on PlatformException {
      rootedCheck = false;
    }
    if (!mounted) return;
    setState(() {
      rootedCheck = rootedCheck;
    });
  }

  Future<void> developerMode() async {
    try {
      devMode = (await RootCheckerPlus
          .isDeveloperMode())!; // return Android developer mode status is true or false
    } on PlatformException {
      devMode = false;
    }
    if (!mounted) return;
    setState(() {
      devMode = devMode;
      print('Developer Mode: $devMode');
    });

    if (devMode) {
      CustomHelper.showCustomAlertDialogDeveloperMode(
        context: context,
        title: "CSC APP",
        description: Commontext.devmodedesc,
        onOkPressed: () {
          AppSettings.openAppSettings(type: AppSettingsType.developer);
        },
        backgroundColor: Colors.white,
        titleBackgroundColor: Colors.blue,
        buttonColor: Colors.blue,
        buttonTextColor: Colors.white,
      );
    }
  }

  Future<void> iosJailbreak() async {
    try {
      jailbreak = (await RootCheckerPlus
          .isJailbreak())!; // return iOS jailbreak status is true or false
    } on PlatformException {
      jailbreak = false;
    }
    if (!mounted) return;
    setState(() {
      jailbreak = jailbreak;
    });
  }

  void Navigatemethod() {
    if (Platform.isAndroid) {
      if (devMode == true) {
        androidRootChecker();
        developerMode();
      } else {

        onSubmit(context);
      }
    } else if (Platform.isIOS) {

      if (devMode == true) {
        iosJailbreak();
        developerMode();
      } else {
        Get.to(const Newreginstruction());
      }
    } else {
      // Handle other platforms if needed (e.g., Web, Fuchsia)
      print('This platform is not supported.');
    }
  }

  Future<void> clearAppCache() async {
    try {
      await DefaultCacheManager().emptyCache();

    } catch (e) {
     }
  }




  Future<void> clearApplicationCache() async {
    try {
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();

      // Get the application support directory
      final appSupportDir = await getApplicationSupportDirectory();

      // Get the application documents directory
      final appDocumentsDir = await getApplicationDocumentsDirectory();

      // Delete the temporary directory
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
        print("Temporary cache cleared.");
      }

      // Delete the application support directory
      if (appSupportDir.existsSync()) {
        appSupportDir.deleteSync(recursive: true);
        print("Application support cache cleared.");
      }

      // Delete the application documents directory
      if (appDocumentsDir.existsSync()) {
        appDocumentsDir.deleteSync(recursive: true);
        print("Application documents cache cleared.");
      }

      print("All application cache cleared successfully!");
    } catch (e) {
      print("Error while clearing application cache: $e");
    }
  }

  void onSubmit(BuildContext context) async {
    List<String> deniedPermissions = await checkPermissionsStatus();

    if (deniedPermissions.isEmpty) {
      // Navigatemethod();
      Get.to(const Newreginstruction());
    } else {
      await requestAllPermissions(context);
    }
  }
  Future<List<String>> checkPermissionsStatus() async {
    List<String> deniedPermissions = [];

    if (await Permission.location.isDenied) {
      deniedPermissions.add("Location");
      PermissionHelper.requestLocationPermission(context);
    }

    // Check Camera Permission
    if (await Permission.camera.isDenied) {
      deniedPermissions.add("Camera");
      PermissionHelper.requestCameraPermission(context);
    }

    // Check Microphone Permission
    if (await Permission.microphone.isDenied) {
      deniedPermissions.add("Microphone");
      PermissionHelper.requestMicrophonePermission(context);
    }



    return deniedPermissions;
  }
     Future<bool> requestAllPermissions(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
      Permission.microphone,
    ].request();

    List<String> deniedPermissions = [];

    if (statuses[Permission.location]?.isDenied == true) {
      deniedPermissions.add("Location");
    }
    if (statuses[Permission.camera]?.isDenied == true) {
      deniedPermissions.add("Camera");
    }
    if (statuses[Permission.microphone]?.isDenied == true) {
      deniedPermissions.add("Microphone");
    }

    /*if (deniedPermissions.isNotEmpty) {
      CustomHelper.showCustomAlertDialogDeveloperMode(
        context: context,
        title: "Permissions Required",
        description: "Please allow the following permissions: ${deniedPermissions.join(", ")}",
        onOkPressed: () async {
          await requestAllPermissions(context);
          Navigator.of(context).pop();
        },
        backgroundColor: Colors.white,
        titleBackgroundColor: Colors.blue,
        buttonColor: Colors.blue,
      );
      return false;
    }*/

    print("All permissions granted.");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Commonappcolor.white,
      body: WillPopScope(
        onWillPop: () async {
          return await CustomHelper.showExitPopup(
            context: context,
            title: Commontext.exitapp,
            description: Commontext.areyousure,
            yesText: Commontext.yes,
            noText: Commontext.no,
            titleBackgroundColor: Commonappcolor.blue,
            buttonColor: Commonappcolor.blue,
          );
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Commonappcolor.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            "images/mann.png",
                            scale: .8,
                            fit: BoxFit.cover,
                          )),
                      CustomHelper.verticalSpace(40),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 20),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            Commontext.notavleyet,
                            style: Stylefile.elevationbuton_blue_25_heading_h1,
                          ),
                        ),
                      ),
                      CustomHelper.verticalSpace(10),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            Commontext.completereg,
                            style: Stylefile.Text_black_13_heading_h6_robo_med,
                          ),
                        ),
                      ),
                      CustomHelper.verticalSpace(30),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 20),
                        child: Center(
                          child: CustomElevatedButton(
                            label: Commontext.signup,
                            onPressed: () async {
                              Navigatemethod();
                            //  onSubmit(context);


                            },
                          ),
                        ),
                      ),
                      CustomHelper.verticalSpace(100),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              Commontext.cscgovin,
                              style: Stylefile.elevationbuton_blue_16_heading,
                            ),
                          ),
                          Text("@ $formattedDate${Commontext.copywritetext}",
                              style: Stylefile.Textcolor_black_12_heading_h6),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,

          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Commonappcolor.white,
              titlePadding: const EdgeInsets.only(top: 0, left: 0, right: 00),
              buttonPadding: const EdgeInsets.all(10),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    5.0,
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 5),
              title: Container(
                color: Commonappcolor.blue,
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Exit App",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Commonappcolor.white),
                      ),
                    ),
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            Commontext.areyousure,
                            style: Stylefile.Textcolor_black_16_heading_h4,
                          ),
                        )),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Commonappcolor.COLOR_PRIMARY,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: const SizedBox(
                            width: 100,
                            child: Center(
                                child: Text(
                              'YES',
                              style: TextStyle(color: Commonappcolor.white),
                            ))),
                        onPressed: () {
                          exit(0);
                        },
                      ),
                    ),
                    CustomHelper.horizontalSpace(20),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Commonappcolor.COLOR_PRIMARY,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: const SizedBox(
                            width: 100,
                            child: Center(
                                child: Text(
                              'NO',
                              style: TextStyle(color: Commonappcolor.white),
                            ))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ) ??
        false;
  }
}
