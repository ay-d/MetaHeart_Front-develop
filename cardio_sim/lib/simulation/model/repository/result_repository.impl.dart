import 'package:cardio_sim/simulation/model/entity/chart_data.dart';
import 'package:cardio_sim/simulation/model/entity/static_data.dart';
import 'package:cardio_sim/simulation/model/repository/result_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ResultRepositoryImpl implements ResultRepository {
  ResultRepositoryImpl();

  @override
  Future<ChartData> getChartData(String s3Path, String fileName) async {
    final result =
        await http.get(Uri.parse('${dotenv.get("S3_PATH")}/$s3Path/$fileName'));
    return ChartData.fromPlt(fileName, result.body);
  }

  final List<StaticData> _statics = [
    StaticData(type: StaticDataType.max, title: "APD90", value: 52.0),
    StaticData(type: StaticDataType.max, title: "AP", value: 52.0),
    StaticData(type: StaticDataType.max, title: "dVm/dt", value: 52.0),
  ];

  @override
  Future<List<StaticData>> getStatics(String s3Path, String fileName) async {
    return _statics;
  }

  @override
  Future<String> getCSVContent(String s3Path, String fileName) async {
    final result =
    await http.get(Uri.parse('${dotenv.get("S3_PATH")}/$s3Path/$fileName'));
    return result.body;
  }
}
