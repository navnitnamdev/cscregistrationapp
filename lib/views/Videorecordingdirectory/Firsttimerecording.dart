import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../common/CommonAppColor.dart';
import '../../common/CommonText.dart';
import '../../common/TextStyle.dart';

class Firsttimerecording extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Firsttimerecording({Key? key, required this.cameras}) : super(key: key);

  @override
  State<Firsttimerecording> createState() => _FrontCameraScreenState();
}

class _FrontCameraScreenState extends State<Firsttimerecording>  with WidgetsBindingObserver  {
  CameraController? _controller;
  VideoPlayerController? _videoController;
  Timer? _timer;
  String? _videoPath;

  bool visiblesaynamedob = false;
  bool clearvisibleornot = true;
  bool btnstartrecording = true;
  bool isRecording = false;
  bool showVideoPreview = false;
  String? _recordedVideoPath;
  int _remainingTime = 10;
  int _recordingTime = 0;
  final int _maxRecordingTime = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeFrontCamera();
  }

  Future<void> _initializeFrontCamera() async {
    final frontCamera = widget.cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(frontCamera, ResolutionPreset.high);
    await _controller!.initialize();
    setState(() {});
  }

  Future<void> _startRecording() async {
    if (!_controller!.value.isInitialized || isRecording) return;

    final directory = await getTemporaryDirectory();
    final videoPath = '${directory.path}/front_camera_video.mp4';

    await _controller!.startVideoRecording();
    setState(() {
      isRecording = true;
      _recordedVideoPath = videoPath;
      _recordingTime = 0;
      _remainingTime = _maxRecordingTime;
      showVideoPreview = false;
    });

    _startCountdownTimer();
  }

  Future<void> _stopRecording() async {
    if (!_controller!.value.isRecordingVideo) return;

    final videoFile = await _controller!.stopVideoRecording();

    setState(() {
      isRecording = false;
      _timer?.cancel();
      _recordedVideoPath = videoFile.path;
      showVideoPreview = true;
      btnstartrecording = true;
    });

    Get.back(result: _recordedVideoPath);

  /*  // After video is saved, clear cache (delete temp file)
    final File recordedVideo = File(videoFile.path);
    if (await recordedVideo.exists()) {
      await recordedVideo.delete(); // Clear the video file from storage
      print('Video cache cleared.');
    }*/
    print('Recorded Video Path: $_recordedVideoPath');
  }

  void _startCountdownTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;
        _recordingTime++;
      });

      if (_remainingTime <= 0 || _recordingTime >= _maxRecordingTime) {
        _stopRecording();
        timer.cancel();
      }
    });
  }

  Future<void> _initializeVideoPlayer() async {
    if (_recordedVideoPath != null) {
      _videoController = VideoPlayerController.file(File(_recordedVideoPath!));
      await _videoController!.initialize();
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
       if (isRecording) {
        _stopRecording();
      }
    }

  }

  @override
  void dispose() {
    _controller?.dispose();
    _videoController?.dispose();
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Camera Preview
            Visibility(
              visible: clearvisibleornot,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                      child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                          textAlign: TextAlign.left,
                          Commontext.pleaseensure,
                          style: Stylefile.Textcolor_white_16_heading_h4),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 20,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.clear_outlined),
                        ),
                        color: Colors.white,
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: visiblesaynamedob,
              child: Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                    textAlign: TextAlign.left,
                    Commontext.saynamedob,
                    style: Stylefile.Textcolor_white_16_heading_h4),
              )),
            ),
            const SizedBox(height: 10),
            if (_controller != null && _controller!.value.isInitialized)
              Container(
                height: 430,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Commonappcolor.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),

            //   else Center(child: CircularProgressIndicator()),

            const SizedBox(height: 20),

            // Countdown Timer Display
            if (isRecording)
              Text(
                'Remaining Time: $_remainingTime seconds',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),

            // Buttons for Recording
            Visibility(
              visible: btnstartrecording,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      isRecording ? null : _startRecording();
                      clearvisibleornot = false;
                      visiblesaynamedob = true;
                      btnstartrecording = false;
                    },
                    icon: const Icon(
                      Icons.videocam,
                      color: Commonappcolor.textbluecolor,
                    ),
                    label: const Text(
                      'Start Recording',
                      style: TextStyle(color: Commonappcolor.textbluecolor),
                    ),
                  ),
                ],
              ),
            ),

            // Video Preview
            if (showVideoPreview && _videoController != null)
              Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Video Preview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 200,
                    child: VideoPlayer(_videoController!),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _videoController!.value.isPlaying
                            ? _videoController!.pause()
                            : _videoController!.play();
                      });
                    },
                    child: Text(_videoController!.value.isPlaying
                        ? 'Pause Video'
                        : 'Play Video'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
