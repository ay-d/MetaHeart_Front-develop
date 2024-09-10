import 'package:flutter/material.dart';
import 'package:cardio_sim/common/styles/sizes.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double borderRadiusCircular;
  late final EdgeInsetsGeometry padding;
  final void Function()? onPressed;

  CustomElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color = Colors.black,
    this.borderRadiusCircular = 20.0,
    EdgeInsetsGeometry? padding,
  }) {
    this.padding = padding ??
        EdgeInsets.symmetric(
          vertical: kPaddingSmallSize,
          horizontal: kPaddingMiniSize,
        );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusCircular),
        ),
      ),
      onPressed: onPressed,
      child: Padding(padding: padding, child: child),
    );
  }
}
