import 'package:cardio_sim/auth/model/entity/user_entity.dart';
import 'package:cardio_sim/auth/model/state/member_state.dart';
import 'package:cardio_sim/auth/provider/auth_provider.dart';
import 'package:cardio_sim/logcat/view/logcat_view.dart';
import 'package:cardio_sim/menu/model/type/menu_type/menu_type.dart';
import 'package:cardio_sim/menu/provider/menu_stack_provider.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final homeViewModelProvider = Provider((ref) => HomeViewModel(ref));

class HomeViewModel {
  Ref ref;

  late final MenuStack menuStack;
  late final HoveredMenu hoveredMenu;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final MemberState memberState = MemberState();
  final CustomPopupMenuController menuController = CustomPopupMenuController();

  UserEntity get member => memberState.value!;

  bool isMaintainMenu = false;

  HomeViewModel(this.ref) {
    menuStack = ref.read(menuStackProvider);
    hoveredMenu = HoveredMenu(menuStack.peek()!);
  }

  bool get isRoot => menuStack.peek() == null;

  MenuType get currentMenu => menuStack.peek()!;

  int get currentIndex => menuStack.length - 1;

  List<MenuType> get menuList => menuStack.all;

  void onMenuClicked(MenuType menuType) => menuStack.push(
        menuType,
        index: currentIndex,
        callback: () => hoveredMenu.value = menuStack.peek()!,
      );

  void onMenuHovered(MenuType menuType) => hoveredMenu.value = menuType;

  void popMenu() => menuStack.pop(index: currentIndex);

  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  void navigateToLogcatPage(BuildContext context) {
    GoRouter.of(context).go('/logcat');
  }

  void logout() {
    menuController.hideMenu();
    ref.read(authProvider).logout();
  }

  void maintain() {
    isMaintainMenu = true;
  }

  void close() {
    isMaintainMenu = false;
  }
}

class HoveredMenu extends ValueNotifier<MenuType> {
  HoveredMenu(super.value);
}
