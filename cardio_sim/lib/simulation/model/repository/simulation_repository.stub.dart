import 'dart:convert';
import 'package:cardio_sim/simulation/model/entity/input_deck_data.dart';
import 'package:cardio_sim/simulation/model/repository/simulation_repository.dart';
import 'package:dio/dio.dart';

class SimulationRepositoryStub implements SimulationRepository {
  final List<InputDeckData> _inputDeckData = [
    InputDeckData(
      title: "Number of Paces",
      items: [
        InputDeckItemData(
          type: InputDeckItemType.radio,
          data: [
            InputDeckItemDataData("a", "a"),
            InputDeckItemDataData("v", "v"),
          ],
        ),
      ],
    ),
    InputDeckData(
      title: "Cycle Length",
      items: [
        // InputDeckItemData(type: InputDeckItemType.number, unit: "msec"),
      ],
    ),
    InputDeckData(
      title: "Conductance",
      items: [
        // InputDeckItemData(title: "GNaL", type: InputDeckItemType.slider),
        // InputDeckItemData(title: "GNaL", type: InputDeckItemType.slider),
        // InputDeckItemData(title: "GNaL", type: InputDeckItemType.slider),
      ],
    ),
    InputDeckData(
      title: "Biometrics",
      items: [
        // InputDeckItemData(
        //   title: "GNaL",
        //   type: InputDeckItemType.dropdown,
        //   data: ["ADP", "qNet", "qInward"],
        // ),
      ],
    ),
    InputDeckData(
      title: "Dose-response file",
      items: [
        // InputDeckItemData(type: InputDeckItemType.file),
      ],
    ),
  ];

  @override
  Future<String> getInputDeck(String menu) async {
    // print(_inputDeckData.map((e) => e.toJson()).toList().toString());
    return _inputDeckData
        .map((e) => json.encode(e.toJson()))
        .toList()
        .toString();
  }

  @override
  Future setInputDeck(String type, Map<String, dynamic> inputData) async {}

  @override
  Future uploadInputFile(String type, String name, FormData formData) async {}
}
