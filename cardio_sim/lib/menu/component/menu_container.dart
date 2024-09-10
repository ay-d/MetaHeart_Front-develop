import 'package:cardio_sim/common/component/custom_icon_button.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:cardio_sim/menu/component/menu_item.dart';
import 'package:cardio_sim/menu/model/type/menu_type/menu_type.dart';
import 'package:flutter/material.dart';

class MenuContainer extends StatelessWidget {
  final MenuType menu;
  final Decoration? decoration;
  final void Function(MenuType) onMenuItemClicked;
  final void Function(MenuType)? onMenuItemHover;
  final void Function()? onMenuPop;

  const MenuContainer(
    this.menu, {
    Key? key,
    required this.onMenuItemClicked,
    this.onMenuItemHover,
    this.decoration,
    required this.onMenuPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                padding: EdgeInsets.all(kPaddingLargeSize),
                child: Center(
                  child: Text(
                    menu.title,
                    style: kTextMainStyle.copyWith(fontSize: kTextLargeSize),
                  ),
                ),
              ),
              if (onMenuPop != null)
                Positioned(
                  left: kPaddingMiddleSize,
                  child: CustomIconButton(
                    icon: Icons.navigate_before,
                    onPressed: onMenuPop,
                  ),
                ),
            ],
          ),
          SizedBox(height: kPaddingMiddleSize),
          Container(
            constraints: BoxConstraints(
              minHeight: ResponsiveSize.S(200)
            ),
            child: ListView.builder(
              itemCount: menu.subMenu?.length ?? 0,
              itemBuilder: (context, i) => MenuItem(
                menu.subMenu![i],
                onTap: onMenuItemClicked,
                onHover: onMenuItemHover != null
                    ? (value) => onMenuItemHover!(value ? menu.subMenu![i] : menu)
                    : null,
              ),
              shrinkWrap: true,
            ),
          )
        ],
      ),
    );
  }
}
