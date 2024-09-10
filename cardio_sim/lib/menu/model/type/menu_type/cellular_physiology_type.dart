import 'package:cardio_sim/menu/model/type/menu_type/cardiac_cellular_electrophysiology_type.dart';
import 'package:cardio_sim/menu/model/type/menu_type/menu_type.dart';

import 'extension/menu_type_extension.dart';

enum CellularPhysiologyType implements MenuType {
  cardiacCellularElectrophysiology(
    "Cardiac Cellular Electrophysiology",
    subMenu: CardiacCellularElectrophysiologyType.values,
  ),
  nervousCellularElectrophysiology("Neuron EP Simulation"),
  cardiacMuscleMechanics("Cardiac Muscle"),
  skeletalMuscleMechanics("Skeletal Muscle"),
  smoothMuscleMechanics("Smooth Muscle");

  @override
  final String title;
  @override
  final String? explain;
  @override
  final List<MenuType>? subMenu;
  @override
  final Set<MenuTypeExtension>? extension;

  const CellularPhysiologyType(
    this.title, {
    this.explain,
    this.subMenu,
    this.extension,
  });

  @override
  String toString() => title;
}
