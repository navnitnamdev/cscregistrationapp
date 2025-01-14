import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cscapp/CommonBaseUrl/SecureCodeApi.dart';
import 'package:cscapp/views/Completeregistration.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import '../common/CommonText.dart';
import '../customwidgets/CustomHelper.dart';

class Apiservice {
  static var resMsg;

  //static String baseurl = "https://cscregister.csccloud.in/"; // this is production main url
  static String baseurl =
      "http://payuat.csccloud.in/registration/"; // this is UAT url
  static String fileupload_endpoint = '${baseurl}reg/upload';
  static String regmobile_api = "${baseurl}reg/mobile";

  static Future Fileupload_api_(
      BuildContext context,
      String appRef,
      String secCode,
      String mobileNo,
      String camImgLatitude,
      String camImgLongitude,
      File videoFile,
      String getipaddress,
      String getaddress,
      String refrenceid,
      String currenttimedate) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final Uri apiUrlVideo =
        Uri.parse(fileupload_endpoint); // Replace with your API URL

    Map<String, String> parameters = {
      'appRefNo': appRef,
      'secureCode': secCode,
      'mobile': mobileNo,
      'lat': camImgLatitude,
      'long': camImgLongitude,
    };

    try {
      var request = http.MultipartRequest('POST', apiUrlVideo);
      parameters.forEach((key, value) {
        request.fields[key] = value;
      });
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          videoFile.path,
          filename: basename(videoFile.path),
          contentType: MediaType('video', 'mp4'),
        ).timeout(const Duration(seconds: 20)),
      );
      var response = await request.send();

      Navigator.pop(context);

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();

        var jsonResponse = jsonDecode(responseBody);

        var resCode = jsonResponse['resCode'];
        resMsg = jsonResponse['resMsg'];
        var resData = jsonResponse['resData'];

        if (resCode == "000") {
          SecureCodeApi.Securecode_regmobapi(
            context,
            appRef,
            secCode,
            mobileNo,
            getipaddress,
            camImgLatitude,
            camImgLongitude,
            getaddress.toString(),
            refrenceid.toString(),
            currenttimedate.toString(),
          ).then((value) async {
            print("secureapi-" + value);
            final File recordedVideo = File(videoFile.path);
            if (await recordedVideo.exists()) {
              await recordedVideo.delete(); // Clear the video file from storage
            }
          }).catchError((error) {});
        } else {
          showErrorDialog(context, resMsg);

          final File recordedVideo = File(videoFile.path);
          if (await recordedVideo.exists()) {
            await recordedVideo.delete(); // Clear the video file from storage
          }
        }
      } else {
        showErrorDialog(context, resMsg);
        final File recordedVideo = File(videoFile.path);
        if (await recordedVideo.exists()) {
          await recordedVideo.delete(); // Clear the video file from storage
        }
      }
    } on SocketException {
      Navigator.pop(context);

      CustomHelper.showToast(context, Commontext.SERVERCONNECTION);
    } on TimeoutException {
      Navigator.pop(context);

      CustomHelper.showToast(context, Commontext.timeout);
    } catch (e) {}
  }

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('CSC APP'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () async {
                Get.offAll(const Completeregistration());
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
