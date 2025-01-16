import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../common/CommonAppColor.dart';
import '../common/TextStyle.dart';

class CustomHelper {
  static void showToast(BuildContext context, String message,
      {int durationInMillis = 8000,
      ToastGravity gravity = ToastGravity.BOTTOM}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  static void showScaffoldMessage(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2)}) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: duration,
      backgroundColor: Colors.black,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showCustomAlertDialogDeveloperMode({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onOkPressed,

    Color backgroundColor = Colors.white,
    Color titleBackgroundColor = Colors.blue,
    Color buttonColor = Colors.blue,
    Color buttonTextColor = Colors.white,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          titlePadding: const EdgeInsets.only(top: 0, left: 0, right: 0),
          buttonPadding: const EdgeInsets.all(10),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          title: Container(
            color: titleBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Commonappcolor.white),
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
                        description,
                        style: Stylefile.Textcolor_black_16_heading_h4,
                      ),
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: SizedBox(
                  width: 100,
                  child: Center(
                    child: Text(
                      'OK',
                      style: Stylefile.Textcolor_white_16_heading_h4,
                    ),
                  ),
                ),
                onPressed: () {
                  onOkPressed();
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  static Future<bool> showExitPopup({
    required BuildContext context,
    String title = "Exit App",
    String description = "Are you sure you want to exit?",
    String yesText = "YES",
    String noText = "NO",
    Color titleBackgroundColor = Colors.blue,
    Color backgroundColor = Colors.white,
    Color buttonColor = Colors.blue,
    Color buttonTextColor = Colors.white,
  }) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: backgroundColor,
              titlePadding: const EdgeInsets.only(top: 0, left: 0, right: 0),
              buttonPadding: const EdgeInsets.all(10),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 5),
              title: Container(
                color: titleBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: buttonTextColor,
                    ),
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        description,
                        style: Stylefile.Textcolor_black_16_heading_h4,

                      ),
                    ),
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
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: SizedBox(
                          width: 100,
                          child: Center(
                            child: Text(
                              yesText,
                              style: TextStyle(color: buttonTextColor),
                            ),
                          ),
                        ),
                        onPressed: () {
                          exit(0);
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: SizedBox(
                          width: 100,
                          child: Center(
                            child: Text(
                              noText,
                              style: TextStyle(color: buttonTextColor),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ) ??
        false;
  }

   static Widget customDivider({
    Color color = Colors.grey,
    double thickness = 1.0,
    double indent = 0.0,
    double endIndent = 0.0,
  }) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: color,
            thickness: thickness,
            indent: indent,
            endIndent: endIndent,
          ),
        ),
      ],
    );
  }

  static void showCustomPermissionDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            "Alert",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showToast(context,
                    message);
              },
              child: Text(
                "OK",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
  static SizedBox verticalSpace(double height) {
    return SizedBox(height: height);
  }

   static SizedBox horizontalSpace(double width) {
    return SizedBox(width: width);
  }
}
