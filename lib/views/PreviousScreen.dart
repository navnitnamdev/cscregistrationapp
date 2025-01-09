import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';

import 'package:cscapp/views/Videorecordingdirectory/Firsttimerecording.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import '../../common/AppImagesPath.dart';
import '../../common/CommonText.dart';
import '../../common/TextStyle.dart';
import '../../customwidgets/RoundedContainer.dart';
import '../../customwidgets/SpaceBox.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../common/CommonAppColor.dart';
import '../customwidgets/CustomElevatedButton.dart';
import 'PreviewDetailsScreeen.dart';

class Previousscreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Previousscreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<Previousscreen> createState() => PreviousscreenState();
}

class PreviousscreenState extends State<Previousscreen> {
  bool playvdpvisibility = true;
  bool displayitems = true;
  bool showVideoPreview = false;
  bool vdodisplyhisde = true;
  bool capturevideovalidation = false;
  bool takevideohide = true;
  bool getvideopreview = false;
  String getvaluehere = "";
  VideoPlayerController? _videoController;

  String? _videoPath;

  bool clicktbtn_new_visible = true;
  String fileName = "";
  File? videoFile;
  String? refId;
  String? currentDateTime;
  String? getlatitude;
  String? getlongitude;
  String? getAddress;
  String? ipAddress;

  @override
  void initState() {
    setState(() {
      locget();
    });

    fetchLocation();

    refId = generateRefId();
    currentDateTime = getCurrentDateTime();

    _initializeVideoPlayer();
    super.initState();
  }

  Future<void> _initializeVideoPlayer() async {
    _videoController = VideoPlayerController.file(File(_videoPath.toString()));
    await _videoController!.initialize();

    fileName = basename(_videoPath.toString());

    setState(() {});
  }

  void locget() async {
    String result = await getSimpleLocation();
    ipAddress = await getIpAddress();
  }

  void fetchLocation() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.location.request();
    // Display the latitude, longitude, and address
  }

  @override
  void dispose() {
    _videoController?.dispose();
    // _clearVideoPreview();

    super.dispose();
  }

  Future<String> getIpAddress() async {
    try {
      // Get all network interfaces
      final interfaces = await NetworkInterface.list(
        includeLoopback: false, // Exclude loopback addresses
        type: InternetAddressType.any, // Both IPv4 and IPv6
      );

      for (var interface in interfaces) {
        for (var address in interface.addresses) {
          if (address.address.isNotEmpty) {
            return address.address; // Return the first valid IP address
          }
        }
      }

      return "No valid IP address found";
    } catch (e) {
      return "Failed to get IP address: $e";
    }
  }

  Future<String> getSimpleLocation() async {
    try {
      // Check if location services are enabled
      if (!await Geolocator.isLocationServiceEnabled()) {
        return "Location services are disabled.";
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return "Location permissions are denied.";
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return "Location permissions are permanently denied.";
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

       List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;
      String address =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      getlatitude = position.latitude.toString();
      getlongitude = position.latitude.toString();
      getAddress = address.toString();
      print("latitude_here" + getlatitude.toString());
      // Return formatted result
      return "Latitude: ${position.latitude}, Longitude: ${position.longitude}, Address: $address";
    } catch (e) {
      return "Failed to get location: $e";
    }
  }

  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return formattedDateTime;
  }

  String generateRefId() {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('yyMMddHHmmssSS').format(now);
    Random random = Random();
    int randomNumber =
        random.nextInt(10000); // Generate a random number between 0 and 9999

    String refId = formattedDateTime + randomNumber.toString().padLeft(4, '0');

    return refId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Commonappcolor.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Visibility(
              visible: displayitems,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceBox(height: 30),
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
                          Commontext.capturevideo,
                          style: Stylefile.Textcolor_blue_20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Instructions",
                      style: Stylefile.Textcolor_blue_17_h2,
                    ),
                    const SpaceBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RoundedContainer(),
                        const SpaceBox(
                          width: 14,
                        ),
                        Flexible(
                          child: Text(
                            Commontext.capturevideogeotagged,
                            style: Stylefile.Text_black_13_heading_h6_robo_med,
                          ),
                        )
                      ],
                    ),
                    const SpaceBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        const RoundedContainer(),
                        const SpaceBox(
                          width: 14,
                        ),
                        const SpaceBox(
                          height: 15,
                        ),
                        Flexible(
                          child: Text(
                            Commontext.videoshouldbe,
                            style: Stylefile.Text_black_13_heading_h6_robo_med,
                          ),
                        )
                      ],
                    ),
                    const SpaceBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RoundedContainer(),
                        const SpaceBox(
                          width: 14,
                        ),
                        Flexible(
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: Commontext.whilecapturevideo,
                                  style: Stylefile
                                      .Text_black_13_heading_h6_robo_med,
                                ),
                                TextSpan(
                                  text: Commontext.pannumber,
                                  style: Stylefile
                                      .Text_black_14_heading_h6_robo_bold,
                                ),
                                TextSpan(
                                  text: Commontext.and,
                                  style: Stylefile
                                      .Text_black_13_heading_h6_robo_med,
                                ),
                                TextSpan(
                                  text: Commontext.applicationrefrencenumber,
                                  style: Stylefile
                                      .Text_black_14_heading_h6_robo_bold,
                                ),
                                TextSpan(
                                  text: Commontext.inon,
                                  style: Stylefile
                                      .Text_black_13_heading_h6_robo_med,
                                ),
                                TextSpan(
                                  text: Commontext.A4sizesheet,
                                  style: Stylefile
                                      .Text_black_14_heading_h6_robo_bold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SpaceBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RoundedContainer(),
                        const SpaceBox(
                          width: 14,
                        ),
                        Flexible(
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: Commontext.videoshouldbebackend,
                                  // Large "Sign Up" text
                                  style: Stylefile
                                      .Text_black_13_heading_h6_robo_med,
                                ),
                                TextSpan(
                                  text: Commontext.kiosk,
                                  // Large "Sign Up" text
                                  style: Stylefile
                                      .Text_black_14_heading_h6_robo_bold,
                                ),
                                TextSpan(
                                  text: Commontext.alongwith,
                                  // Smaller subtitle
                                  style: Stylefile
                                      .Text_black_13_heading_h6_robo_med,
                                ),
                                TextSpan(
                                  text: Commontext.applicantstanding,
                                  // Smaller subtitle
                                  style: Stylefile
                                      .Text_black_14_heading_h6_robo_bold,
                                ),
                                TextSpan(
                                  text: Commontext.infrontof,
                                  // Smaller subtitle
                                  style: Stylefile
                                      .Text_black_13_heading_h6_robo_med,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SpaceBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SpaceBox(
                          width: 14,
                        ),
                        Flexible(
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: Commontext.whilerecordingthevideo,
                                  // Large "Sign Up" text
                                  style: Stylefile
                                      .Text_black_13_heading_h6_robo_med,
                                ),
                                TextSpan(
                                  text: Commontext.name,
                                  // Large "Sign Up" text
                                  style: Stylefile
                                      .Text_black_14_heading_h6_robo_bold,
                                ),
                                TextSpan(
                                  text: Commontext.and,
                                  // Large "Sign Up" text
                                  style: Stylefile
                                      .Text_black_13_heading_h6_robo_med,
                                ),
                                TextSpan(
                                  text: Commontext.dob,
                                  // Large "Sign Up" text
                                  style: Stylefile
                                      .Text_black_14_heading_h6_robo_bold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SpaceBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            if (_videoPath == null)
              GestureDetector(
                onTap: () async {
                  List<CameraDescription> cameras = await availableCameras();

                  // Navigate to Screen B and wait for the result
                  final recordedVideoPath = await Get.to(
                    Firsttimerecording(cameras: cameras),
                  );

                  if (recordedVideoPath != null) {
                    setState(() {
                      _videoPath = recordedVideoPath;
                      print("video_path_0" + _videoPath.toString());

                      _videoController =
                          VideoPlayerController.file(File(_videoPath!))
                            ..addListener(() {
                              if (_videoController!.value.position ==
                                  _videoController!.value.duration) {
                                setState(() {});
                              }
                            })
                            ..initialize().then((_) {
                              setState(() {});
                              _videoController!.pause();
                            });
                    });

                    fileName = basename(_videoPath.toString());
                    locget();
                  }
                },
                child: Container(
                    margin: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                //color: Commonappcolor.backgrounfimagecolor,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Commonappcolor.textbluecolor,
                                  // Set the border color
                                  width: 3.0, // Set the border width
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.play_circle,
                                    size: 100,
                                    color: Commonappcolor.red,
                                  ),
                                  Text(
                                    Commontext.clickhere,
                                    style:
                                        Stylefile.Textcolor_black_16_heading_h4,
                                  )
                                ],
                              )),
                        ),
                      ],
                    )),
              )
            else
              const SizedBox(),
            _videoPath != null &&
                    _videoController != null &&
                    _videoController!.value.isInitialized
                ? const SizedBox()
                : const Padding(
                    padding: EdgeInsets.only(left: 15, top: 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Please capture the video",
                        style: TextStyle(color: Commonappcolor.red),
                      ),
                    ),
                  ),
            if (_videoPath != null &&
                _videoController != null &&
                _videoController!.value.isInitialized)
              Container(
                //padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(20.0),
                /*   width: MediaQuery
                    .of(context)
                    .size
                    .width,*/
                width: 220,
                height: 220,

                decoration: BoxDecoration(
                  //color: Commonappcolor.backgrounfimagecolor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Commonappcolor.textbluecolor, // Set the border color
                    width: 3.0, // Set the border width
                  ),
                ),

                child: Stack(
                  children: [
                    Container(
                      //  width: MediaQuery.of(context).size.width,
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Commonappcolor.backgrounfimagecolor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          // Adjust this to your desired fit (cover, contain, fill, etc.)
                          child: SizedBox(
                            width: _videoController!.value.size.width,
                            // Video width
                            height: _videoController!.value.size.height,
                            // Video height
                            child: VideoPlayer(_videoController!),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_videoController!.value.isPlaying) {
                              _videoController!.pause();
                            } else {
                              _videoController!.play();
                            }
                          });
                        },
                        child: _videoController!.value.position ==
                                _videoController!.value.duration
                            ? const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 40,
                              )
                            : (_videoController!.value.isPlaying
                                ? const Icon(
                                    Icons.pause,
                                    color: Colors.white,
                                    size: 40,
                                  )
                                : const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 40,
                                  )),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  if (_videoPath != null &&
                      _videoController != null &&
                      _videoController!.value.isInitialized)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            label: Commontext.retake,
                            onPressed: () async {
                              List<CameraDescription> cameras =
                                  await availableCameras();

                              // Navigate to Screen B and wait for the result
                              final recordedVideoPath = await Get.to(
                                Firsttimerecording(cameras: cameras),
                              );

                              if (recordedVideoPath != null) {
                                setState(() {
                                  _videoPath = recordedVideoPath;

                                  _videoController = VideoPlayerController.file(
                                      File(_videoPath!))
                                    ..addListener(() {
                                      if (_videoController!.value.position ==
                                          _videoController!.value.duration) {
                                        setState(() {});
                                      }
                                    })
                                    ..initialize().then((_) {
                                      setState(() {});
                                      _videoController!
                                          .pause(); // Optionally auto-play the video
                                    });
                                });
                              }
                            },
                          ),
                        ),
                        const SpaceBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CustomElevatedButton(
                            label: Commontext.proceedtoreview,
                            onPressed: () {
                              setState(() {});

                              Get.to(PreviewDetailsScreeen(
                                //  videopath: videoPath_.toString(),
                                videopath: _videoPath.toString(),
                                filename: fileName,
                                refrenceid: refId.toString(),
                                currenttimedate: currentDateTime.toString(),
                                latitde: getlatitude.toString(),
                                longitude: getlongitude.toString(),
                                address: getAddress.toString(),
                                ipaddress: ipAddress.toString(),
                              ));
                            },
                          ),
                        ),
                      ],
                    )
                  else
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: CustomElevatedButton(
                          label: Commontext.proceedtoreview,
                          onPressed: () {
                            print("ooo");
                            if (_videoPath == null) {
                              setState(() {
                                capturevideovalidation = true;
                              });
                            } else {
                              Get.to(PreviewDetailsScreeen(
                                  //  videopath: videoPath_.toString(),
                                  videopath: _videoPath.toString(),
                                  filename: fileName,
                                  refrenceid: refId.toString(),
                                  currenttimedate: currentDateTime.toString(),
                                  latitde: getlatitude.toString(),
                                  longitude: getlongitude.toString(),
                                  address: getAddress.toString(),
                                  ipaddress: ipAddress.toString()));
                            }
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
