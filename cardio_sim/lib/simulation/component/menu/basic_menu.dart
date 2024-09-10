import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:cardio_sim/simulation/component/menu/basic_menu_item.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class BasicMenu extends StatelessWidget {
  final BasicMenuAlign align;
  final BasicMenuController controller;

  const BasicMenu({
    Key? key,
    required this.controller,
    this.align = BasicMenuAlign.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColumnRow(
      isColumn: align.isHorizontal,
      children: controller.menuList
          .mapIndexed(
            (i, e) => RotatedBox(
              quarterTurns: align.isVertical ? 0 : -1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: i == 0
                        ? Radius.circular(kBorderRadiusSize)
                        : Radius.zero,
                    right: i == controller.menuList.length - 1
                        ? Radius.circular(kBorderRadiusSize)
                        : Radius.zero,
                  ),
                  color: controller.index == i
                      ? kMainColor3.withOpacity(0.5)
                      : kMainColor3.withOpacity(0.8),
                ),
                child: BasicMenuItem(
                  e,
                  onTap: () => controller.onMenuItemTap(i),
                  textStyle: kTextReverseStyle.copyWith(fontSize: kTextSmallSize),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class ColumnRow extends StatelessWidget {
  final bool isColumn;
  final List<Widget> children;
  final MainAxisSize mainAxisSize;

  const ColumnRow({
    Key? key,
    required this.isColumn,
    this.mainAxisSize = MainAxisSize.max,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isColumn
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: mainAxisSize,
            children: children,
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: mainAxisSize,
            children: children,
          );
  }
}

abstract class BasicMenuController extends ChangeNotifier {
  List<BasicMenuItemData> menuList;
  int index = 0;

  BasicMenuController(this.menuList);

  void onMenuItemTap(int index);
}

enum BasicMenuAlign {
  left,
  right,
  top,
  bottom;
}

extension BasicMenuAlignData on BasicMenuAlign {
  bool get isVertical =>
      (this == BasicMenuAlign.top) || (this == BasicMenuAlign.bottom);

  bool get isHorizontal =>
      (this == BasicMenuAlign.left) || (this == BasicMenuAlign.right);

  bool get isReversed =>
      (this == BasicMenuAlign.bottom) || (this == BasicMenuAlign.right);
}
