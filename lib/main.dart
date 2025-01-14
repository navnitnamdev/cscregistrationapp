import 'package:cscapp/views/PreviousScreen.dart';
import 'package:cscapp/views/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

late List<CameraDescription> cameras;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CSC APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: SplashScreen(),
       debugShowCheckedModeBanner: false,
    );
  }
}
