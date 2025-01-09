import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cscapp/common/CommonAppColor.dart';
import 'package:cscapp/customwidgets/SpaceBox.dart';
import 'package:cscapp/views/NewRegInstruction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:root_checker_plus/root_checker_plus.dart';
import '../common/CommonText.dart';
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
      //  _showDeveloperModeAlert();
    });

    if (devMode) {
      // Show an alert dialog when Developer Mode is enabled
      _showDeveloperModeAlert();
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

  void _showDeveloperModeAlert() {
    showDialog(
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
          contentPadding: EdgeInsets.symmetric(horizontal: 5),
          title: Container(
            color: Commonappcolor.blue,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "CSC APP",
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
                        Commontext.devmodedesc,
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Commonappcolor.COLOR_PRIMARY,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: SizedBox(
                      width: 100,
                      child: Center(
                          child: Text(
                        'OK',
                        style: TextStyle(color: Commonappcolor.white),
                      ))),
                  onPressed: () {
                    AppSettings.openAppSettings(
                        type: AppSettingsType.developer);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void Navigatemethod() {
    if (Platform.isAndroid) {
      if (devMode == true) {
        androidRootChecker();
        developerMode();
      } else {
        Get.to(const Newreginstruction());
      }
    } else if (Platform.isIOS) {
      // iOS-specific logic
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Commonappcolor.white,
      body: WillPopScope(
        onWillPop: showExitPopup,
        child:
            /* Center(
            child: Platform.isAndroid
                ? Text('Running on Android\n\n Root Checker: $rootedCheck\n Developer Mode Enable:$devMode')
                : Text('Running on iOS\n Jailbreak: $jailbreak \n')),
      ),*/
            SingleChildScrollView(
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
                      const SpaceBox(
                        height: 40,
                      ),
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
                      const SpaceBox(
                        height: 10,
                      ),
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
                      const SpaceBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 20),
                        child: Center(
                          child: CustomElevatedButton(
                            label: Commontext.signup,
                            onPressed: () {
                             // Navigatemethod();
                              Get.to(const Newreginstruction());
                            },
                          ),
                        ),
                      ),
                      const SpaceBox(
                        height: 100,
                      ),
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
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
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
                        child: SizedBox(
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
                    SpaceBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Commonappcolor.COLOR_PRIMARY,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: SizedBox(
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
