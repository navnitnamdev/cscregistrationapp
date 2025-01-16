import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cscapp/common/CommonAppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../common/AppImagesPath.dart';
import '../common/CommonText.dart';
import '../common/TextStyle.dart';
import '../customwidgets/CustomElevatedButton.dart';
import '../customwidgets/CustomHelper.dart';
 import 'package:get_storage/get_storage.dart';
import 'PreviousScreen.dart';


class Completeregistration extends StatefulWidget {
  const Completeregistration({super.key});

  @override
  State<Completeregistration> createState() => _CompleteregistrationState();
}

class _CompleteregistrationState extends State<Completeregistration> {
  final TextEditingController _ApprefnumberController = TextEditingController();
  final TextEditingController _securecodecontroller = TextEditingController();
  final TextEditingController _mobilenumbercontroller = TextEditingController();
  String _apprefnumber = '';
  String _securecode = '';
  String _mobilenumber = '';
  bool _isPasswordVisible = false;
  GetStorage box = GetStorage();


  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  void validateAppRefNumber(String value) {
    setState(() {
      if (value.isEmpty) {
        _apprefnumber = Commontext.apprefnumbercannot;
      } else if (RegExp(r'^[a-zA-Z]').hasMatch(value)) {
        if (value.length < 12) {
          _apprefnumber =
              'App reference number must be at least 12 characters long.';
        } else if (!RegExp(r'^[A-Z][0-9]{11}$').hasMatch(value)) {
          _apprefnumber = Commontext.pleaseentervalidappnumber;
        } else {
          _apprefnumber = '';
        }
      } else if (RegExp(r'^[0-9]').hasMatch(value)) {
        if (value.length < 16) {
          _apprefnumber =
              'App reference number must be at least 16 digits long.';
        } else if (!RegExp(r'^\d{16}$').hasMatch(value)) {
          _apprefnumber = Commontext.pleaseentervalidappnumber;
        } else {
          _apprefnumber = '';
        }
      } else {
        _apprefnumber = Commontext.pleaseentervalidappnumber;
      }
    });
  }

  TextInputFormatter _inputFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      if (newValue.text.isNotEmpty) {
        int newLength = newValue.text.length;

        if (RegExp(r'^[a-zA-Z]').hasMatch(newValue.text)) {
          if (newLength > 12) {
            newLength = 12;
          }
        } else if (RegExp(r'^[0-9]').hasMatch(newValue.text)) {
          if (newLength > 16) {
            newLength = 16;
          }
        }

        return newValue.copyWith(
          text: newValue.text.substring(0, newLength),
          selection: TextSelection.collapsed(offset: newLength),
        );
      }
      return newValue;
    });
  }

  void validateMobileNumber(String value) {
    setState(() {
      if (value.isEmpty) {
        _mobilenumber = 'Mobile number is required';
      } else if (value.length < 10) {
        _mobilenumber = 'Mobile number must be 10 digits';
      } else if (value == "0000000000") {
        _mobilenumber = 'Mobile number is invalid';
      } else if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
        _mobilenumber = 'Mobile number must start with a digit greater than 6';
      } else {
        _mobilenumber = '';
      }
    });
  }

  void validateSecureCode(String value) {
    setState(() {
      if (value.isEmpty) {
        _securecode = 'Secure code is required';
      } else if (value.length < 6) {
        _securecode = 'Secure code must be at least 6 digits';
      } else {
        _securecode = '';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //_initializeFrontCamera();
  }

 /* Future<void> _initializeFrontCamera() async {
    try {
      cameras = await availableCameras();

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
      );

      await _controller!.initialize();
      setState(() {});
    } catch (e) {}
  }*/

  void validateAndProceed(
      String appRefNumber, String secureCode, String mobileNumber) {
    _saveAndNavigate(appRefNumber, secureCode, mobileNumber);
  }

  void _saveAndNavigate(
      String appRefNumber, String secureCode, String mobileNumber) async {
    final box = GetStorage();

    box.write('apprefnumber', appRefNumber);
    box.write('securecode', secureCode);
    box.write('mobilenumber', mobileNumber);


    List<CameraDescription> cameras = await availableCameras();
    Get.to(Previousscreen(cameras: cameras));
  }

  @override
  void dispose() {
    _ApprefnumberController.dispose();
    _securecodecontroller.dispose();
    _mobilenumbercontroller.dispose();
   // _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Commonappcolor.white,
        body: WillPopScope(
          onWillPop: () async{
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
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: /*Column(
              children: [

              ],
            ),*/SingleChildScrollView(
              child:  Container(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Column(
                          children: [

                            CustomHelper.verticalSpace(30),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Image.asset(
                                    AppimagesPath.backicon,
                                    scale: .8,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    Commontext.completeregistration,
                                    /*  style: Stylefile.Textcolor_blue_30,
                                  overflow: TextOverflow.ellipsis,*/
                                    style: Stylefile.Textcolor_blue_20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 80),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              textAlignVertical: TextAlignVertical.center,
                              controller: _ApprefnumberController,
                              keyboardType: TextInputType.text,
                              inputFormatters: [_inputFormatter()],
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(
                                    color: Commonappcolor.blue),
                                prefixIcon: Image.asset(
                                  AppimagesPath.appreficon,
                                  scale: 2.5,
                                ),
                                hintText: Commontext.apprefnum,
                                hintStyle: Stylefile.hinttextstle_16,
                                errorText: _apprefnumber.isNotEmpty
                                    ? _apprefnumber
                                    : null,
                              ),
                              focusNode: _focusNode1,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                // Move focus to the next field when "next" is pressed
                                _focusNode1.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_focusNode2);
                              },
                              onChanged: (value) {
                                validateAppRefNumber(value);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Application Ref Number is required';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              textAlignVertical: TextAlignVertical.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              maxLines: 1,
                              obscureText: !_isPasswordVisible,
                              controller: _securecodecontroller,
                              focusNode: _focusNode2,
                              textInputAction: TextInputAction.next,
                              // Use next action key
                              onEditingComplete: () {
                                // Move focus to the next field when "next" is pressed
                                _focusNode2.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_focusNode3);
                              },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible =
                                      !_isPasswordVisible;
                                    });
                                  },
                                ),
                                labelStyle: const TextStyle(
                                    color: Commonappcolor.blue),
                                prefixIcon: Image.asset(
                                  AppimagesPath.sourcecodeicon,
                                  scale: 3,
                                ),
                                hintText: Commontext.securecode,
                                hintStyle: Stylefile.hinttextstle_16,
                                errorText: _securecode.isNotEmpty
                                    ? _securecode
                                    : null,
                              ),
                              onChanged: (value) {
                                validateSecureCode(value);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Secure code is required';
                                }
                                if (value.length < 6) {
                                  return 'Secure code must be at least 6 digits';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              maxLines: 1,
                              controller: _mobilenumbercontroller,
                              focusNode: _focusNode3,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(
                                    color: Commonappcolor.blue),
                                prefixIcon: Image.asset(
                                  AppimagesPath.mobileimg,
                                  scale: 3,
                                ),
                                hintText: Commontext.mobilenumber,
                                hintStyle: Stylefile.hinttextstle_16,
                                errorText: _mobilenumber.isNotEmpty
                                    ? _mobilenumber
                                    : null,
                              ),
                              onChanged: (value) {
                                validateMobileNumber(value);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Mobile number is required';
                                }
                                if (value.length != 10) {
                                  return 'Mobile number must be exactly 10 digits';
                                }
                                if (!RegExp(r'^[6-9]\d{9}$')
                                    .hasMatch(value)) {
                                  return ' Mobile number must start with a digit greater than 6 ';
                                }
                                return null;
                              },
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomElevatedButton(
                                label: Commontext.proceedtocapture,
                                onPressed: () {
                                  final apprefnumberinput =
                                      _ApprefnumberController.text;
                                  final securecodeinput =
                                      _securecodecontroller.text;
                                  final mobnumberinput =
                                      _mobilenumbercontroller.text;

                                  validateSecureCode(securecodeinput);
                                  validateMobileNumber(mobnumberinput);
                                  validateAppRefNumber(apprefnumberinput);

                                  if (apprefnumberinput.isEmpty) {
                                    CustomHelper.showToast(context,
                                        Commontext.pleasefillapprefnumber);
                                  } else if (apprefnumberinput.length < 12) {
                                    CustomHelper.showToast(
                                        context,
                                        Commontext
                                            .pleasefillapprefnumberupto1216);
                                  } else if (securecodeinput.isEmpty) {
                                    CustomHelper.showToast(context,
                                        Commontext.pleasefillsecurecode);
                                  } else if (securecodeinput.length < 6) {
                                    CustomHelper.showToast(
                                        context,
                                        Commontext
                                            .pleasefillsecurecodesixdigit);
                                  } else if (mobnumberinput.isEmpty) {
                                    CustomHelper.showToast(
                                        context, Commontext.mobcannotbeempty);
                                  } else if (mobnumberinput.length < 10) {
                                    CustomHelper.showToast(context,
                                        Commontext.mobilenumbertendigit);
                                  } else if (!RegExp(r'^[6-9]\d{9}$')
                                      .hasMatch(mobnumberinput.toString())) {
                                    CustomHelper.showToast(
                                        context,
                                        Commontext
                                            .mobnumberstartabovesixdigit);
                                  } else if (mobnumberinput == "0000000000") {
                                    CustomHelper.showToast(context,
                                        Commontext.mobilenummberinvalid);
                                  } else {
                                    validateAndProceed(apprefnumberinput, securecodeinput, mobnumberinput);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ),
        ));
  }

  Future<bool> showExitPopup() async {
    return await
    showDialog(

      context: context,

      builder: (BuildContext context)
      {
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
          title:
          Container(
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
                      child: Text(Commontext.areyousure,style: Stylefile.Textcolor_black_16_heading_h4,),
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

                CustomHelper.horizontalSpace(20),
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
              ],)
          ],
        );
      },
    ) ??
        false;
  }
}
