import 'package:cardio_sim/common/value_state/state/value_state.dart';
import 'package:cardio_sim/simulation/model/entity/chart_data.dart';
import 'package:cardio_sim/simulation/model/entity/input_deck_data.dart';
import 'package:cardio_sim/simulation/model/entity/output_data.dart';
import 'package:cardio_sim/simulation/model/entity/static_data.dart';

class InputDeckState extends ValueStateNotifier<List<InputDeckData>> {}

class ChartState extends ValueStateNotifier<List<OutputData>> {}

class StaticState extends ValueStateNotifier<List<StaticData>> {}

class CSVState extends ValueStateNotifier<List<String>> {}
