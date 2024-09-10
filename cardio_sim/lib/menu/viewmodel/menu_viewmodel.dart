import 'package:cardio_sim/menu/component/animated_menu_container.dart';
import 'package:cardio_sim/menu/model/type/menu_type/menu_type.dart';
import 'package:cardio_sim/menu/provider/menu_stack_provider.dart';
import 'package:flutter/material.dart' hide Stack;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final menuViewModelProvider =
    ChangeNotifierProvider((ref) => MenuViewModel(ref));

class MenuViewModel extends ChangeNotifier {
  Ref ref;

  late final MenuStack _menuStack;
  late MenuType _hoveredMenu;

  late final AnimatedMenuContainerController menuController;

  MenuViewModel(this.ref) {
    _menuStack = ref.read(menuStackProvider);
    _hoveredMenu = _menuStack.peek()!;
    menuController = AnimatedMenuContainerController(
      currentMenu,
      menuStack: _menuStack,
      onMenuItemClicked: (menuType) => onMenuClicked(
        menuType,
        currentIndex,
      ),
      onMenuItemHover: onMenuHovered,
      onMenuPop: () => popMenu(currentIndex),
    );
  }

  bool get isRoot => _menuStack.peek() == null;

  MenuType get hoveredMenu => _hoveredMenu;

  MenuType get currentMenu => _menuStack.peek()!;

  int get currentIndex => _menuStack.length - 1;

  List<MenuType> get menuList => _menuStack.all;

  void onMenuClicked(MenuType menuType, int index) => _menuStack.push(
        menuType,
        index: index,
        callback: () {
          _hoveredMenu = _menuStack.peek()!;
          notifyListeners();
        },
      );

  void onMenuHovered(MenuType menuType) {
    _hoveredMenu = menuType;
    notifyListeners();
  }

  void popMenu(int index) => _menuStack.pop(
        index: index,
        callback: notifyListeners,
      );
}
