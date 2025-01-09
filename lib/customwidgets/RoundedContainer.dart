import 'package:flutter/cupertino.dart';

import '../common/CommonAppColor.dart';
import '../common/RoundedContainerStyles.dart';

class RoundedContainer extends StatelessWidget {
  final double? borderRadius;
  final Color? color;
  final Widget? child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxShadow? boxShadow;

  const RoundedContainer({
    this.borderRadius,
    this.color,
    this.child,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.boxShadow,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      padding: padding ?? RoundedContainerStyles.defaultPadding,
      margin: margin ?? RoundedContainerStyles.defaultMargin,
      decoration: BoxDecoration(
        color: Commonappcolor.bluedark,
        borderRadius: BorderRadius.circular(
            20),
        boxShadow: boxShadow != null
            ? [boxShadow!]
            : [RoundedContainerStyles.defaultBoxShadow],
      ),
      child: child,
    );
  }
}
