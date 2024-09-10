import 'package:cardio_sim/menu/model/type/menu_type/menu_type.dart';

import 'extension/menu_type_extension.dart';

enum CardiacCellularElectrophysiologyType implements MenuType {
  epSimulation("EP Simulation"),
  patchClamp(
    "Patch Clamp",
    extension: {MenuTypeExtension.radioPng},
  ),
  drugSimulationBootstrapUQ(
    "Bootstrap",
    extension: {MenuTypeExtension.pdfOutPut},
  ),
  mutation("Cardiac Genetic Mutation"),
  drugToxicity("Drug Safety Evaluation"),
  population("Population Simulation"),
  restitution("Restitution");

  @override
  final String title;
  @override
  final String? explain;
  @override
  final List<MenuType>? subMenu;
  @override
  final Set<MenuTypeExtension>? extension;

  const CardiacCellularElectrophysiologyType(
    this.title, {
    this.explain,
    this.subMenu,
    this.extension,
  });

  @override
  String toString() => title;
}
