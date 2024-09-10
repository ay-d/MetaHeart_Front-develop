import 'package:cardio_sim/simulation/model/entity/chart_data.dart';
import 'package:cardio_sim/simulation/model/entity/static_data.dart';
import 'package:cardio_sim/simulation/model/repository/result_repository.dart';

class ResultRepositoryStub implements ResultRepository {
  final List<ChartData> _chartDataList = [
    ChartData(
      "voltage",
      "time",
      [1, 2, 3, 4, 5, 6, 7],
      {
        "cai": List.generate(7, (index) => index * 1),
        "nai": List.generate(7, (index) => index * 2),
        "ki": List.generate(7, (index) => index * 3),
      },
    ),
    ChartData(
      "currents",
      "time",
      [1, 2, 3, 4, 5, 6, 7],
      {
        "cai": List.generate(7, (index) => index * 3),
        "nai": List.generate(7, (index) => index * 2),
        "ki": List.generate(7, (index) => index * 1),
      },
    ),
  ];

  final List<StaticData> _statics = [
    StaticData(type: StaticDataType.max, title: "APD90", value: 52.0),
    StaticData(type: StaticDataType.max, title: "AP", value: 52.0),
    StaticData(type: StaticDataType.max, title: "dVm/dt", value: 52.0),
  ];


  @override
  Future<ChartData> getChartData(String s3Path, String fileName) async {
    String plt = 'Time,Vm,dVm/dt,Cai(x1.000.000)(milliM->picoM),INa(x1.000)(microA->picoA),INaL(x1.000)(microA->picoA),ICaL(x1.000)(microA->picoA),IKs(x1.000)(microA->picoA),IKr(x1.000)(microA->picoA),IK1(x1.000)(microA->picoA),Ito(x1.000)(microA->picoA)\n0.00,-87.00,-0.16,100,-0,-0,-0,0,0,-0,149\n0.01,-87.00,-0.16,100,-0,-0,-0,0,0,-0,149';
    return ChartData.fromPlt(s3Path, plt);
  }

  @override
  Future<List<StaticData>> getStatics(String s3Path, String fileName) async  {
    return _statics;
  }

  @override
  Future<String> getCSVContent(String s3Path, String fileName) {
    throw UnimplementedError();
  }
}
