import 'dart:async';
import 'package:cscapp/common/AppImagesPath.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../common/CommonText.dart';
import '../common/TextStyle.dart';
import 'package:get/get.dart';

import 'SignUpButton.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  GetStorage box = GetStorage();

  String? formattedDate;

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
              'You are not connected to the internet. Please check your connection and try again.'),
          actions: [
            TextButton(
              onPressed: () async {
                // Close the dialog
                //AppSettings.openAppSettings();
                SystemNavigator.pop();
                Navigator.pop(context);
              },
              child: const Text('Retry'),
            ),
          ],
        );
      },
    );
  }



  @override
  void initState() {
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy').format(now);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _animation = Tween<double>(
      begin: 2 * 3.141,
      end: 0,
    ).animate(_controller);

    _controller.repeat();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.duration =
            _controller.duration! + const Duration(seconds: 2);
        _controller.repeat();
      }
    });
    Future.delayed(const Duration(seconds: 5), () {
      Get.off(const SignupButton());
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  AppimagesPath.splash,
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 250,
                        height: 250,
                        child: Stack(
                          children: [
                            AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _animation.value,
                                  // Rotate based on animation value
                                  child: Center(
                                    child: Image.asset(
                                      scale: .7,
                                      'images/innerglobe.png', // Replace with your outer image
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Inner static image
                            Center(
                              child: Image.asset(
                                scale: .65,
                                'images/outerglobe.png', // Replace with your inner image
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      Commontext.cscapp,
                      style: Stylefile.elevationbuton_white_26_headingbold,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 50,
                left: 50,
                right: 50,
                child: SizedBox(
                  width: 0,
                  height: 120,
                  child: Image.asset(AppimagesPath.cscnameimg, scale: .5),
                ),
              ),
              Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              Commontext.cscgovin,
                              style: Stylefile.elevationbuton_white_16_heading,
                            ),
                          ),
                          Text("@ $formattedDate${Commontext.copywritetext}",
                              style: Stylefile.Textcolor_white_12_heading_h6),
                        ],
                      )
                    ],
                  ))
            ],
          )
          /* ;}
                  })*/ /*),
        ],
      ),*/
          )
    ]));
    //color: Colors.white, child:  Image.asset("assets/images/splashimage.png"),);
  }
}
