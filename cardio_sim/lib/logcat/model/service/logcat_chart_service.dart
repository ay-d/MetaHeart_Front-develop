import 'dart:convert';

import 'package:cardio_sim/common/entity/response_entity.dart';
import 'package:cardio_sim/logcat/model/repository/logcat_chart_repository.dart';
import 'package:cardio_sim/menu/provider/menu_stack_provider.dart';
import 'package:cardio_sim/simulation/model/entity/chart_data.dart';
import 'package:cardio_sim/simulation/model/entity/input_deck_data.dart';
import 'package:cardio_sim/simulation/model/entity/static_data.dart';
import 'package:cardio_sim/simulation/model/repository/result_repository.dart';
import 'package:cardio_sim/simulation/model/repository/simulation_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logcatChartServiceProvider = Provider((ref) {
  final logcatCharRepository = ref.read(logcatChartRepositoryProvider);
  final menuStack = ref.read(menuStackProvider);
  return LogcatChartService(logcatCharRepository, menuStack);
});

class LogcatChartService {
  final LogcatChartRepository logcatCharRepository;
  final MenuStack menuStack;

  LogcatChartService(this.logcatCharRepository, this.menuStack);

  Future<ResponseEntity<List<InputDeckData>>> getInputDeck() async {
    try {
      final result = await logcatCharRepository.getInputDeck();
      return ResponseEntity.success(entity: result);
    } on DioException catch (e) {
      return ResponseEntity.error(message: e.message);
    } catch (e) {
      return ResponseEntity.error(message: e.toString());
    }
  }

  Future<ResponseEntity<List<ChartData>>> getChartData() async {
    try {
      final chartValue = await logcatCharRepository.getChartData();
      return ResponseEntity.success(entity: [chartValue]);
    } on DioException catch (e) {
      return ResponseEntity.error(message: e.message);
    } catch (e) {
      return ResponseEntity.error(message: e.toString());
    }
  }

  Future<ResponseEntity<List<StaticData>>> getStaticData() async {
    try {
      final staticValue = await logcatCharRepository.getStatics();
      return ResponseEntity.success(entity: staticValue);
    } on DioException catch (e) {
      return ResponseEntity.error(message: e.message);
    } catch (e) {
      return ResponseEntity.error(message: e.toString());
    }
  }
}
