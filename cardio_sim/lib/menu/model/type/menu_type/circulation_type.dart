import 'package:cardio_sim/menu/model/type/menu_type/menu_type.dart';

import 'extension/menu_type_extension.dart';

enum CirculationType implements MenuType {
  hemodynamics("Hemodynamics"),
  bodyFluidCirculation("Body Fluid Balance");

  @override
  final String title;
  @override
  final String? explain;
  @override
  final List<MenuType>? subMenu;
  @override
  final Set<MenuTypeExtension>? extension;

  const CirculationType(
    this.title, {
    this.explain,
    this.subMenu,
    this.extension,
  });

  @override
  String toString() => title;
}
