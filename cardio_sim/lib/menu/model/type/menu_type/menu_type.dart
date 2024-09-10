import 'extension/menu_type_extension.dart';

abstract class MenuType {
  final String title;
  final String? explain;
  final List<MenuType>? subMenu;
  final Set<MenuTypeExtension>? extension;

  MenuType(this.title, {this.explain, this.subMenu, this.extension});

  @override
  String toString() => title;
}

extension MenuTypeFromString on MenuType {
  MenuType? fromString(String value) {
    if (value == title) {
      return this;
    } else {
      return subMenu
          ?.map((element) => element.fromString(value))
          .where((element) => element != null)
          .firstOrNull;
    }
  }
}
