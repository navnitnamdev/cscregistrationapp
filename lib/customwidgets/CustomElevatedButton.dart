import 'package:cscapp/common/CommonAppColor.dart';
import 'package:flutter/material.dart';

import '../common/TextStyle.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    required this.label,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(

      width: MediaQuery.of(context).size.width,
      height: 45,
      
      child: ElevatedButton(

        style: ElevatedButton.styleFrom(
          foregroundColor: Commonappcolor.textbluecolor, backgroundColor: Commonappcolor.btnbackgroundcolor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(
              color:Commonappcolor.textbluecolor,
              width: 2.0,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: Stylefile.elevationbuttonstyle_16,

        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text("Custom Elevated Button"),
      ),
      body: Center(
        child: CustomElevatedButton(
          label: "Click Me",
          onPressed: () {
            print("Button Pressed!");
          },
        ),
      ),
    ),
  ));
}
