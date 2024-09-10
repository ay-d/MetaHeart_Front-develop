import 'package:cardio_sim/simulation/model/repository/result_repository.impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/chart_data.dart';
import '../entity/static_data.dart';

final resultRepositoryProvider = Provider((ref) {
//  return ResultRepositoryStub();
  return ResultRepositoryImpl();
});

abstract class ResultRepository {
  Future<ChartData> getChartData(String s3Path, String fileName);

  Future<List<StaticData>> getStatics(String s3Path, String fileName);

  Future<String> getCSVContent(String s3Path, String fileName);
}