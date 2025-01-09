import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cscapp/common/CommonText.dart';
import 'package:cscapp/common/TextStyle.dart';
import 'package:cscapp/customwidgets/CustomElevatedButton.dart';
import 'package:cscapp/views/NewRegInstruction.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../common/CommonAppColor.dart';
import '../views/SignUpButton.dart';
import 'Apiservice.dart';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SecureCodeApi {
  BuildContext context;

  SecureCodeApi(this.context);

  static Future Securecode_regmobapi(
      context,
      String appRefNo,
      String secureCode,
      String mobile,
      String getipaddress,
      String geoLat,
      String geolong,
      String geoaddress,
      String refrenceid,
      String timestamp) async {
    showLoader(context);

    String apiUrlSec = Apiservice.regmobile_api;
    final headers = {
      'Accept': 'application/json',
    };

    final head = {
      'clientId': 'P001',
      'appName': 'Register Web',
      //'refId': '${DateTime.now().toUtc().toIso8601String()}${Random().nextInt(9999999) + 1000000}',
      'refId': refrenceid,
      'ts': timestamp,
      // Replace with actual timestamp value
      'reqAction': 'vidRegister',
      'clientIp': getipaddress,
      // Replace with actual IP value
      'geoLocation': 'NA',
    };

    final body = {
      'appRefNo': appRefNo, // Replace with actual value
      'appType': 'V',
      'mobileNo': mobile, // Replace with actual value
      'secureCode': secureCode, // Replace with actual value
      'geoLat': geoLat, // Replace with actual value
      'geoLong': geolong, // Replace with actual value
      'geoLocation': geoaddress, // Replace with actual value
      'videoDat': 'mp4',
      'picMatch': '70',
      'checkSum':
          'b63688ee69575a94acaee10c30d3efba9e249e41007cef7f8c0a1c4a33338334',
    };

    final param = {
      'head': head,
      'body': body,
    };
    var aeskey = "c+cNh7y44v4wLjb30U2xwcbimGz0ci4VoSxmQvhC94o=";
    final jsonData = json.encode(param);
    var enc = aesEncryptionThree(jsonData, aeskey);


    try {
      var aeskey = "c+cNh7y44v4wLjb30U2xwcbimGz0ci4VoSxmQvhC94o=";
      final jsonData = json.encode(param);
      aesEncryptionThree(jsonData, aeskey);
      // Encrypt the data (implement your encryption logic here)
      final encryptData = enc; // Replace with encrypted data

      final parameters = {
        'reqData': encryptData,
        'clientId': 'P001',
        'userId': 'NA',
      };

      final response = await http.post(
        Uri.parse(apiUrlSec),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(parameters),
      );
      print("params_" + parameters.toString());

      hideLoader(context);
      //print("rescode_secure_RESONSE" + response.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        var resCode = responseData['resCode'];
        String resMsg = responseData['resMsg'] ?? '';

        print("response_Secure_Code " + resCode + resMsg);

        if (resCode == "859") {
          showSuccessDialogfor_859(context, resMsg);
          print("rescode_secure_859" + resCode);
          print("rescode_secure_859" + resCode);
          clearFiles();
        } else if (resCode == "858") {
          showSuccessDialog(context, resMsg);
          print("rescode_secure_858" + resCode);
          print("rescode_secure_858" + resCode);
          clearFiles();
        } else {
          showErrorDialog(context, resMsg);
          print("rescode_secure" + resCode);
          clearFiles();
        }
      } else {
        showErrorDialog(
            context, 'Failed with status code: ${response.statusCode}');
        clearFiles();
      }
    } catch (error) {
      hideLoader(context);
      showErrorDialog(context, 'Error: $error');
    }
  }

  static void showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  static void hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('CSC APP'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Replace with your success screen
                Get.offAll(SignupButton());
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showSuccessDialogfor_859(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Commonappcolor.white,
            insetPadding: EdgeInsets.zero, // Removes default padding
            child: Container(
                width: MediaQuery.of(context).size.width * 0.7, // Full width
                height: MediaQuery.of(context).size.height * 0.7, // Full height
                decoration: BoxDecoration(
                  color: Commonappcolor.white,
                  borderRadius:
                      BorderRadius.circular(5.0), // Optional rounded corners
                ),
                child: SizedBox(
                    width: MediaQuery.of(context)
                        .size
                        .width, // 80% of screen width
                    height: 400,
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        // Adjust size to fit content
                        children: [
                          SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              'images/successimg.jpg',
                              // Replace with your image path
                              height: 100,
                              width: 100,
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              Commontext.congrets,
                              style:
                                  Stylefile.Text_black_20_heading_h6_robo_bold,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                                textAlign: TextAlign.center,
                                Commontext.successmessage,
                                style: Stylefile.Textcolor_black_14_heading_h4),
                          ), // Add spacing between the image and the text

                          SizedBox(height: 40),
                          Center(
                              child: Container(
                            margin: EdgeInsets.all(30),
                            child: CustomElevatedButton(
                                label: "OK",
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Get.offAll(SignupButton());
                                }),
                          )),
                        ]))));
      },
    );
  }

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('CSC APP'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

String aesEncryptionThree(String data, String aesKey) {
  // Decode the Base64 encoded key
  final aesKeyBytes = base64Decode(aesKey);

  // Generate a random IV (Initialization Vector)
  final iv = encrypt.IV.fromLength(16); // AES block size is 16 bytes

  // Create AES encryption with CBC mode and PKCS7 padding
  final encrypter = encrypt.Encrypter(
    encrypt.AES(
      encrypt.Key(aesKeyBytes),
      mode: encrypt.AESMode.cbc,
      padding: 'PKCS7',
    ),
  );

  // Encrypt the data
  final encrypted = encrypter.encrypt(data, iv: iv);

  // Combine IV and encrypted data, then encode to Base64
  final combined = Uint8List.fromList(iv.bytes + encrypted.bytes);
  return base64Encode(combined);
}
// This method clears files from the app's cache directory
Future<void> clearFiles() async {
  final directory = await getTemporaryDirectory(); // Get temporary directory
  final cacheDir = directory.path;

  final dir = Directory(cacheDir);
  if (dir.existsSync()) {
    final files = dir.listSync();
    for (var file in files) {
      file.deleteSync(); // Delete each file
    }
  }
}