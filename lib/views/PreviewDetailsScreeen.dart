import 'dart:io';
import 'package:cscapp/customwidgets/CustomHelper.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:cscapp/CommonBaseUrl/Apiservice.dart';
import 'package:cscapp/common/CommonAppColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../common/AppImagesPath.dart';
import '../common/CommonText.dart';
import '../common/TextStyle.dart';
import '../customwidgets/CustomDialogBox.dart';
 import '../customwidgets/CustomElevatedButton.dart';
import '../customwidgets/SpaceBox.dart';
import 'package:get_storage/get_storage.dart';

class PreviewDetailsScreeen extends StatefulWidget {
  String videopath;
  String filename = "";
  String refrenceid = "";
  String currenttimedate = "";
  String latitde = "";
  String longitude = "";
  String address = "";
  String ipaddress = "";

  PreviewDetailsScreeen(
      {required this.videopath,
      required this.filename,
      required this.refrenceid,
      required this.currenttimedate,
      required this.latitde,
      required this.longitude,
      required this.address,
      required this.ipaddress,
      super.key});

  @override
  State<PreviewDetailsScreeen> createState() => _DetailsScreeenState();
}

class _DetailsScreeenState extends State<PreviewDetailsScreeen> {
  bool? value = false;
  GetStorage box = GetStorage();
  late String thumbnailPath;
  File? getvideofie;
  String? base64Video;
  String getfilename = "";
  late Uri fileUri;
  String fileName = "";
  File? imgfile;

  String? getrefrenceid;
  String? getcurrenttimedate;
  String? getlatitde;
  String? getlongitude;
  String? getaddress;
  String? getipaddress;
  bool _isChecked = false; // Checkbox state
  String? _errorMessage;
  String? vdopathget;

  late VideoPlayerController _controller;

  void initializeFileUri(String vdopathget) async {
    fileUri = Uri.file(vdopathget);

    final bytes = imgfile!.readAsBytesSync().lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;

    print("File URI initialized: $mb");
  }

  @override
  void initState() {
    vdopathget = widget.videopath;
    getlatitde = widget.latitde;
    getlongitude = widget.longitude;
    getaddress = widget.address;
    getipaddress = widget.ipaddress;
    // TODO: implement initState
    imgfile = File(vdopathget.toString());

    getfilename = widget.filename.toString();
    getrefrenceid = widget.refrenceid.toString();
    getcurrenttimedate = widget.currenttimedate.toString();

    _controller = VideoPlayerController.file(imgfile!)
      ..initialize().then((_) {
        setState(() {
          // Ensures the build method runs and _controller is initialized
        });
      }).catchError((error) {});

    initializeFileUri(widget.videopath);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _validateAndSubmit() {
    if (!_isChecked) {
      setState(() {
        _errorMessage = Commontext.pleaseceept;
      });
    } else {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Commonappcolor.white,
      body: Container(
        padding: const EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Commonappcolor.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceBox(height: 40),
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
                  const SpaceBox(
                    width: 20,
                  ),
                  Text(
                    Commontext.previewdetails,
                    style: Stylefile.Textcolor_blue_20,
                  ),
                ],
              ),
              const SpaceBox(
                height: 20,
              ),
              Center(
                child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Commonappcolor.blue, width: 3),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: _controller.value.isInitialized
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: VideoPlayer(_controller),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Play/Pause button
                              const Center(
                                child: SizedBox(),
                              ),
                            ],
                          )
                        : const SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(child: CircularProgressIndicator()))),
              ),
              const SpaceBox(
                height: 30,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Commontext.applicationrefnumber,
                      style: Stylefile.Text_black_16_heading_h6_robo_med,
                    ),
                    const SpaceBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset(
                            AppimagesPath.appreficon,
                            scale: .2,
                          ),
                        ),
                        const SpaceBox(
                          width: 10,
                        ),
                        Text(box.read("apprefnumber").toString()),
                      ],
                    ),

                    CustomHelper.customDivider(
                      color: Commonappcolor.grey,   // Divider color
                      thickness: 1.0,       // Divider thickness
                      indent: 0.0,         // Left indent
                      endIndent: 0.0,      // Right indent
                    ),
                    const SpaceBox(
                      height: 20,
                    ),
                    Text(
                      Commontext.sourcecode,
                      style: Stylefile.Text_black_16_heading_h6_robo_med,
                    ),
                    const SpaceBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        //Icon(Icons.sourcecodeicon),
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset(
                            AppimagesPath.sourcecodeicon,
                            scale: .2,
                          ),
                        ),
                        const SpaceBox(
                          width: 10,
                        ),

                        Text(box.read("securecode").toString()),
                      ],
                    ),
                   // const Customdivider(),
                    CustomHelper.customDivider(
                      color: Commonappcolor.grey,   // Divider color
                      thickness: 1.0,       // Divider thickness
                      indent: 0.0,         // Left indent
                      endIndent: 0.0,      // Right indent
                    ),
                    const SpaceBox(
                      height: 20,
                    ),
                    Text(
                      Commontext.mobilenumber,
                      style: Stylefile.Text_black_16_heading_h6_robo_med,
                    ),
                    const SpaceBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset(
                            AppimagesPath.mobileimg,
                            scale: .2,
                          ),
                        ),
                        const SpaceBox(
                          height: 5,
                        ),
                        const SpaceBox(
                          width: 10,
                        ),
                        Text(box.read("mobilenumber").toString()),
                      ],
                    ),
                   // const Customdivider(),
                    CustomHelper.customDivider(
                      color: Commonappcolor.grey,   // Divider color
                      thickness: 1.0,       // Divider thickness
                      indent: 0.0,         // Left indent
                      endIndent: 0.0,      // Right indent
                    ),
                    const SpaceBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                          Align(
                            alignment: Alignment.topLeft,
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.all(0),
                              controlAffinity: ListTileControlAffinity.leading,

                              title: Transform.translate(
                                offset: Offset(-10, 0),
                                child: Text(
                                  Commontext.iherebythat,
                                  style: Stylefile.Text_black_14_heading_h6_robo_med,
                                ),
                              ),
                              visualDensity: VisualDensity.comfortable,
                              activeColor: Commonappcolor.blue,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              autofocus: true,

                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value ?? false;
                                  _validateAndSubmit();
                                });
                              },
                            ),
                          ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                    const SpaceBox(
                      height: 20,
                    ),
                    Center(
                        child: CustomElevatedButton(
                            label: Commontext.submit,
                            onPressed: () async {
                              if (_isChecked != true) {
                                _validateAndSubmit();
                              } else {
                                try {
                                  final result = await InternetAddress.lookup(
                                      'example.com');
                                  if (result.isNotEmpty &&
                                      result[0].rawAddress.isNotEmpty) {
                                    Apiservice.Fileupload_api_(
                                      context,
                                      box.read("apprefnumber").toString(),
                                      box.read("securecode").toString(),
                                      box.read("mobilenumber").toString(),
                                      getlatitde.toString(),
                                      getlongitude.toString(),
                                      imgfile!,
                                      getipaddress.toString(),
                                      getaddress.toString(),
                                      getrefrenceid.toString(),
                                      getcurrenttimedate.toString(),
                                    ).then((value) {}).catchError((error) {
                                      Get.snackbar("Upload Error",
                                          "There was an error uploading the file: $error");
                                    });
                                  }
                                } on SocketException catch (_) {
                                  Customdialogbox.showInternetDialog(context);
                                }
                              }
                            })),
                    const SpaceBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
