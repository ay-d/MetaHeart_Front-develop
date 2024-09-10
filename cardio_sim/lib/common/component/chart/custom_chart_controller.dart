import 'package:cardio_sim/simulation/model/entity/chart_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomChartController extends ChangeNotifier {
  final Map<String, ChartSeriesController> seriesControllers = {};
  final Map<String, List<double>> seriesDataSource = {};
  ChartData? chartData;

  List<double> get xList => chartData?.xList ?? [];
  List<String> get seriesNames => chartData?.data.keys.toList() ?? [];

  void setChartData(ChartData? chartData) {
    this.chartData = chartData;
    seriesControllers.clear();
    seriesDataSource.clear();
    for (String name in seriesNames) {
      seriesDataSource[name] = [];
    }
    if (chartData != null) {
      for (String name in seriesNames) {
        if (chartData.data[name] != null) {
          for (int i = 0; i < chartData.data[name]!.length; i++) {
            addSeriesData({name: chartData.data[name]![i]});
          }
        }
      }
    }
    print(xList.length);
    notifyListeners();
  }

  /// chart에서 seires 하나의 controller를 받아온다.
  /// 이 controller를 통해 데이터가 추가 될 때 chart 전체를 다시 그리지 않고 그 series에 데이터를 추가하기만 할 수 있다.
  void onRendererCreated(String name, ChartSeriesController controller) {
    seriesControllers[name] = controller;
  }

  void addSeriesData(Map<String, double> seriesData) {
    seriesData.forEach(_addSeriesData);
  }

  void _addSeriesData(String name, double data) {
    seriesDataSource[name]?.add(data);
    seriesControllers[name]?.updateDataSource(
      addedDataIndex: seriesDataSource[name]!.length - 1,
    );
//    Future.delayed(Duration(milliseconds: 1));
  }

  void clearSeriesData(String name) {
    seriesControllers[name]?.updateDataSource(
        removedDataIndexes:
            List.generate(seriesDataSource[name]!.length, (index) => index)
                .toList());
    seriesDataSource[name]?.clear();
  }

  void clearAll() {
    setChartData(null);
  }
}
