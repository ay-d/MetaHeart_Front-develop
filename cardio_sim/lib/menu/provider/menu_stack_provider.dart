import 'package:cardio_sim/common/data_structure/stack.dart';
import 'package:cardio_sim/common/local_storage/session_storage.dart';
import 'package:cardio_sim/home/view/home_view.dart';
import 'package:cardio_sim/menu/model/type/menu_type/main_menu_type.dart';
import 'package:cardio_sim/menu/model/type/menu_type/menu_type.dart';
import 'package:cardio_sim/simulation/view/simulation_view.dart';
import 'package:flutter/material.dart' hide Stack;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final menuStackProvider = ChangeNotifierProvider<MenuStack>(
    (ref) => MenuStack(ref.watch(sessionStorageProvider)));

class MenuStack extends ChangeNotifier {
  final SessionStorage _storage;
  final String _key = "menu_stack";
  final Stack<MenuType> _stack = Stack(init: [MainMenu()]);

  MenuStack(this._storage) {
    _storage.read(key: _key).then((value) {
      if (value != null) _stack.pushAll(_stringToMenu(value));
      notifyListeners();
    });
  }

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final isHomeScreen = state.location == '/${HomeView.routeName}';

    if (_stack.peek()?.subMenu == null) return '/${SimulationView.name}';
    return isHomeScreen ? null : '/${HomeView.routeName}';
  }

  void push(MenuType menuType, {int? index, VoidCallback? callback}) {
    index ??= _stack.length;
    while (_stack.length > index + 1) {
      _stack.pop();
    }
    _stack.push(menuType);
    _storage.write(key: _key, value: _menuToString);
    if (callback != null) callback();
    notifyListeners();
  }

  void pop({int? index, VoidCallback? callback}) {
    index ??= _stack.length - 1;
    while (_stack.length > index) {
      _stack.pop();
    }
    _storage.write(key: _key, value: _menuToString);
    if (callback != null) callback();
    notifyListeners();
  }

  void clear() {
    _stack.clear();
    _stack.push(MainMenu());
    _storage.write(key: _key, value: _menuToString);
    notifyListeners();
  }

  List<MenuType> _stringToMenu(String value) {
    try {
      return value.split(", ").map((e) => MainMenu().fromString(e)!).toList();
    } catch (e) {
      return [];
    }
  }

  String get _menuToString => _stack.all.map((e) => e.title).skip(1).join(", ");

  MenuType? peek() => _stack.peek();

  List<MenuType> get all => _stack.all;

  int get length => _stack.length;
}
