import 'package:cardio_sim/common/component/custom_animation_list.dart';
import 'package:cardio_sim/common/component/custom_icon_button.dart';
import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/menu/component/menu_item.dart';
import 'package:cardio_sim/menu/model/type/menu_type/menu_type.dart';
import 'package:cardio_sim/menu/provider/menu_stack_provider.dart';
import 'package:flutter/material.dart';

import '../../common/styles/text_styles.dart';

class AnimatedMenuContainer extends StatelessWidget {
  final Decoration? decoration;
  final AnimatedMenuContainerController controller;
  final Color? textColor;

  const AnimatedMenuContainer({
    Key? key,
    required this.controller,
    this.decoration,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (_, value, child) => Container(
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
                      value.title,
                      style: kTextMainStyle.copyWith(
                        fontSize: kTextLargeSize,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                if (controller.onMenuPop != null)
                  Positioned(
                    left: kPaddingMiddleSize,
                    child: CustomIconButton(
                      icon: Icons.navigate_before,
                      onPressed: controller.onMenuPop,
                      iconColor: textColor,
                    ),
                  ),
              ],
            ),
            SizedBox(height: kPaddingMiddleSize),
            Expanded(child: SingleChildScrollView(child: child)),
          ],
        ),
      ),
      child: CustomAnimationList(controller: controller.controller),
    );
  }
}

class AnimatedMenuContainerController extends ValueNotifier<MenuType> {
  final MenuStack menuStack;

  late final AnimationListController<MenuType> controller;

  late final void Function(MenuType) onMenuItemClicked;
  late final void Function() _onMenuPop;
  final void Function(MenuType)? onMenuItemHover;

  bool isReverse = true;

  AnimatedMenuContainerController(
    super._value, {
    required this.menuStack,
    required final void Function(MenuType) onMenuItemClicked,
    required final void Function() onMenuPop,
    this.onMenuItemHover,
  }) {
    menuStack.addListener(onMenuChange);

    this.onMenuItemClicked = (menu) {
      isReverse = false;
      onMenuItemClicked(menu);
    };

    _onMenuPop = () {
      isReverse = true;
      onMenuPop();
    };

    controller = AnimationListController<MenuType>(
      listKey: GlobalKey(),
      initList: value.subMenu,
      allMethodDuration: const Duration(milliseconds: 50),
      itemBuilder: (menu) => MenuItem(
        menu,
        onTap: this.onMenuItemClicked,
        onHover: onMenuItemHover != null
            ? (isHovered) => onMenuItemHover!(isHovered ? menu : value)
            : null,
        textColor: kTextReverseColor,
      ),
    );
  }

  void Function()? get onMenuPop => menuStack.length <= 1 ? null : _onMenuPop;

  void onMenuChange() async {
    MenuType? menu = menuStack.peek();
    if (menu?.subMenu == null) return;
    controller.removeAll(reverse: isReverse);
    await Future.delayed(Duration(milliseconds: 300 + 50 * controller.length));
    controller.insertAll(menu!.subMenu ?? [], reverse: isReverse);
    value = menu;
  }

  @override
  void dispose() {
    menuStack.removeListener(onMenuChange);
    super.dispose();
  }
}
