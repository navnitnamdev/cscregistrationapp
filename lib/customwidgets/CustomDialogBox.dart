import 'package:cscapp/common/CommonAppColor.dart';
import 'package:flutter/material.dart';

class Customdialogbox {
  static showInternetDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
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
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                      'You need to have mobile data or wifi to access this. '),
                )),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Commonappcolor.COLOR_PRIMARY,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                child: const SizedBox(
                    width: 100,
                    child: Center(
                        child: Text(
                      'Close',
                      style: TextStyle(color: Commonappcolor.white),
                    ))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

 }
