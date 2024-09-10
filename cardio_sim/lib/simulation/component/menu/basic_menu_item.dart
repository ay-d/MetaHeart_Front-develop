import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:flutter/material.dart';

class BasicMenuItem extends StatelessWidget {
  final BasicMenuItemData data;
  final VoidCallback? onTap;

  final TextStyle textStyle;

  const BasicMenuItem(
    this.data, {
    Key? key,
    this.onTap,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: kPaddingMiniSize,
          horizontal: kPaddingSmallSize,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (data.prefix != null) ...[
              Icon(data.prefix, size: kIconMiniSize, color: textStyle.color),
              SizedBox(width: kPaddingMiniSize),
            ],
            Text(
              data.text,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class BasicMenuItemData {
  IconData? prefix;
  String text;

  BasicMenuItemData(this.text, {this.prefix});
}
