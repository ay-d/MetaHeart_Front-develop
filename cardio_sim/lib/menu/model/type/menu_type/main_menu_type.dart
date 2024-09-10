import 'package:cardio_sim/menu/model/type/menu_type/cardiac_electrophysiology_3d_type.dart';
import 'package:cardio_sim/menu/model/type/menu_type/cardiac_mechanics_3d_type.dart';
import 'package:cardio_sim/menu/model/type/menu_type/cellular_physiology_type.dart';
import 'package:cardio_sim/menu/model/type/menu_type/circulation_type.dart';
import 'package:cardio_sim/menu/model/type/menu_type/extension/menu_type_extension.dart';
import 'package:cardio_sim/menu/model/type/menu_type/menu_type.dart';

class MainMenu implements MenuType {
  @override
  final String title = "Cardio Sim";
  @override
  final String? explain = "인실리코 심장 독성평가 SW";
  @override
  final List<MenuType>? subMenu = MainMenuType.values;
  @override
  Set<MenuTypeExtension>? extension;
}

enum MainMenuType implements MenuType {
  cellularPhysiology(
    "Cellular Physiology",
    subMenu: CellularPhysiologyType.values,
  ),
  cardiacElectrophysiology3D(
    "3D Cardiac Electrophysiology",
    subMenu: CardiacElectrophysiology3DType.values,
  ),
  cardiacMechanics3D(
    "3D Cardiac Mechanics",
    subMenu: CardiacMechanics3DType.values,
  ),
  circulation(
    "Circulation",
    subMenu: CirculationType.values,
  );

  @override
  final String title;
  @override
  final String? explain;
  @override
  final List<MenuType>? subMenu;
  @override
  final Set<MenuTypeExtension>? extension;

  const MainMenuType(
    this.title, {
    this.explain,
    this.subMenu,
    this.extension,
  });

  @override
  String toString() => title;
}
