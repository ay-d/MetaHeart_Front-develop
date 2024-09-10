import 'package:cardio_sim/simulation/model/entity/output_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chart_data.g.dart';

@JsonSerializable()
class ChartData extends OutputData {
  @override
  String title;
  String x;
  List<double> xList;
  Map<String, List<double>> data;

  ChartData(this.title, this.x, this.xList, this.data) : super(title: title);

  @override
  Map<String, dynamic> toJson() => _$ChartDataToJson(this);

  factory ChartData.fromJson(Map<String, dynamic> json) =>
      _$ChartDataFromJson(json);

  factory ChartData.fromPlt(String title, String pltFile) {
    List<String> rawList = pltFile.split("\n");
    List<String> columnList = rawList[0].split(",");

    String x = columnList[0];
    List<double> xList = [];
    Map<String, List<double>> data = {};

    for (int i = 1; i < columnList.length; i++) {
      data[columnList[i]] = [];
    }

    for (int i = 1; i < rawList.length; i += (rawList.length / 10000).ceil()) {
      try {
        List<double> raw = rawList[i].split(",").map(double.parse).toList();
        xList.add(raw[0]);
        for (int j = 1; j < raw.length; j++) {
          data[columnList[j]]!.add(raw[j]);
        }
      } catch (e) {
        print(e);
      }
    }

   // print(data);
    return ChartData(title, x, xList, data);
  }
}
