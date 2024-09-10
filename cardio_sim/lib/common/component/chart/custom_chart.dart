import 'package:cardio_sim/common/component/chart/custom_chart_controller.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomChart extends StatefulWidget {
  final CustomChartController controller;

  const CustomChart({super.key, required this.controller});

  @override
  State<CustomChart> createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (_, __) {
        return SfCartesianChart(
          legend: Legend(
            isVisible: true,
            textStyle: TextStyle(fontSize: kTextMiniSize),
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            textStyle: TextStyle(fontSize: kTextMiniSize),
          ),
          zoomPanBehavior: ZoomPanBehavior(
            enableDoubleTapZooming: true,
            enableMouseWheelZooming: true,
            enablePanning: true,
          ),
          primaryXAxis: NumericAxis(
            labelStyle: TextStyle(fontSize: kTextMiniSize),
          ),
          primaryYAxis: NumericAxis(
            labelStyle: TextStyle(fontSize: kTextMiniSize),
          ),
          series: widget.controller.seriesNames
              .mapIndexed(
                (i, e) =>
                FastLineSeries(
                  initialIsVisible: i == 0 ? true : false,
                  name: e,
                  dataSource: widget.controller.seriesDataSource[e]!,
                  xValueMapper: (_, i) => widget.controller.xList[i],
                  yValueMapper: (data, _) => data,
                  onRendererCreated: (c) =>
                      widget.controller.onRendererCreated(e, c),
                ),
          )
              .toList(),
        );
      }
    );
  }
}
