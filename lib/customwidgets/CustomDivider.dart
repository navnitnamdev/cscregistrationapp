import 'package:cscapp/common/CommonAppColor.dart';
import 'package:flutter/material.dart';

class Customdivider extends StatelessWidget {
  const Customdivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(color: Commonappcolor.grey, thickness: 1),
        ),
      ],
    );
  }
}
