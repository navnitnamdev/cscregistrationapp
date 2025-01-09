import 'package:flutter/material.dart';

class SpaceBox extends StatelessWidget {
  final double? height;
  final double? width;

  const SpaceBox({this.height, this.width, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 0,
      width: width ?? 0,
    );
  }
}
