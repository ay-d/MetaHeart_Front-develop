import 'package:cardio_sim/logcat/model/repository/logcat_chart_repository.impl.dart';
import 'package:cardio_sim/simulation/model/entity/chart_data.dart';
import 'package:cardio_sim/simulation/model/entity/input_deck_data.dart';
import 'package:cardio_sim/simulation/model/entity/static_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logcatChartRepositoryProvider =
    Provider((ref) => LogcatChartRepositoryImpl());

abstract class LogcatChartRepository {
  Future<List<InputDeckData>> getInputDeck();

  Future<ChartData> getChartData();

  Future<List<StaticData>> getStatics();
}
