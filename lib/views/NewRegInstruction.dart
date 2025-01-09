import 'package:cscapp/common/AppImagesPath.dart';
import 'package:cscapp/common/CommonAppColor.dart';
import 'package:cscapp/common/CommonText.dart';
import 'package:cscapp/common/TextStyle.dart';
import 'package:cscapp/views/Completeregistration.dart';
import 'package:flutter/material.dart';
import '../customwidgets/CustomElevatedButton.dart';
import '../customwidgets/RoundedContainer.dart';
import '../customwidgets/SpaceBox.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Newreginstruction extends StatefulWidget {
  const Newreginstruction({super.key});

  @override
  State<Newreginstruction> createState() => _NewreginstructionState();
}

class _NewreginstructionState extends State<Newreginstruction> {
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Commonappcolor.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Commonappcolor.white,
        padding: const EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height,
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
                    Commontext.newregistrationheading,
                    style: Stylefile.Textcolor_blue_20,
                  ),
                ],
              ),
              const SpaceBox(
                height: 30,
              ),
              const Text(
                "Instructions",
                style: Stylefile.Textcolor_blue_17_h2,
              ),
              const SpaceBox(
                height: 10,
              ),
              Text(
                Commontext.instruction_heading,
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
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: Commontext.applicationsecurecode,
                            // Large "Sign Up" text
                            style: Stylefile.Text_black_14_heading_h6_robo_bold,
                          ),
                          const TextSpan(
                            text: " and", // Smaller subtitle
                            style: Stylefile.Text_black_13_heading_h6_robo_med,
                          ),
                          const TextSpan(
                            text: " Mobile Number ", // Large "Sign Up" text
                            style: Stylefile.Text_black_14_heading_h6_robo_bold,
                          ),
                          TextSpan(
                            text: Commontext.whichissentonmobile,
                            // Smaller subtitle
                            style: Stylefile.Text_black_13_heading_h6_robo_med,
                          ),
                          const TextSpan(
                            text: " Email Id ", // Smaller subtitle
                            style: Stylefile.Text_black_14_heading_h6_robo_bold,
                          ),
                          TextSpan(
                            text: Commontext.retrive, // Smaller subtitle
                            style: Stylefile.Text_black_13_heading_h6_robo_med,
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
                      Commontext.devicelocation,
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
                            text: Commontext.camerafunctioning,
                            // Large "Sign Up" text
                            style: Stylefile.Text_black_13_heading_h6_robo_med,
                          ),
                          TextSpan(
                            text: Commontext.geotaggedvidio,
                            // Large "Sign Up" text
                            style: Stylefile.Text_black_14_heading_h6_robo_bold,
                          ),
                          TextSpan(
                            text: Commontext.ofself,
                            // Smaller subtitle
                            style: Stylefile.Text_black_13_heading_h6_robo_med,
                          ),
                          TextSpan(
                            text:  Commontext.kioskcenter,
                            // Smaller subtitle
                            style: Stylefile.Text_black_14_heading_h6_robo_bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SpaceBox(
                height: 40,
              ),
              Center(
                child: CustomElevatedButton(
                  label: Commontext.proceed,
                  onPressed: () {
                     Get.to(Completeregistration());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
