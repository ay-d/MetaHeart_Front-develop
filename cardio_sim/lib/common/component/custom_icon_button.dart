import 'package:flutter/material.dart';
import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? hintMessage;
  final IconData icon;
  final Color? iconColor;

  const CustomIconButton({
    super.key,
    this.hintMessage = "",
    required this.onPressed,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: hintMessage,
      textStyle: kTextNormalStyle.copyWith(
        fontSize: kTextSmallSize,
        color: kTextReverseColor,
        fontWeight: FontWeight.w400,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: kIconMiddleSize, color: iconColor),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        splashRadius: kIconMiddleSize / 1.5,
      ),
    );
  }
}
