import 'package:cardio_sim/menu/model/type/menu_type/menu_type.dart';

import 'extension/menu_type_extension.dart';

enum CardiacElectrophysiology3DType implements MenuType {
  cardiacElectrophysiology("3D Cardiac EP",
      extension: {MenuTypeExtension.mp4OutPut});

  @override
  final String title;
  @override
  final String? explain;
  @override
  final List<MenuType>? subMenu;
  @override
  final Set<MenuTypeExtension>? extension;

  const CardiacElectrophysiology3DType(
    this.title, {
    this.explain,
    this.subMenu,
    this.extension,
  });

  @override
  String toString() => title;
}
