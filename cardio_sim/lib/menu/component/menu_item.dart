import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:cardio_sim/menu/model/type/menu_type/menu_type.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final void Function(MenuType)? onTap;
  final void Function(bool)? onHover;
  final MenuType menu;
  final Color? textColor;

  const MenuItem(
    this.menu, {
    Key? key,
    this.onTap,
    this.onHover,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(menu),
      onHover: onHover,
      child: Padding(
        padding: EdgeInsets.all(kPaddingMiddleSize),
        child: Row(
          children: [
            Expanded(
              child: Text(
                menu.title,
                style: kTextMainStyle.copyWith(
                  fontSize: kTextMiddleSize,
                  color: textColor,
                ),
              ),
            ),
            SizedBox(width: kPaddingMiddleSize),
            Icon(
              menu.subMenu == null
                  ? Icons.subdirectory_arrow_right
                  : Icons.navigate_next,
              size: kIconMiddleSize,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
