import 'package:cardio_sim/common/component/custom_icon_button.dart';
import 'package:cardio_sim/common/component/default_container.dart';
import 'package:cardio_sim/common/responsive_widget/responsive_container.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:cardio_sim/common/value_state/component/value_state_listener.dart';
import 'package:cardio_sim/logcat/model/entity/log_data.dart';
import 'package:cardio_sim/logcat/viewmodel/logcat_viewmodel.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/styles/colors.dart';
import '../../common/styles/sizes.dart';

class LogcatView extends ConsumerStatefulWidget {
  static String get name => 'logcat';

  const LogcatView({super.key});

  @override
  ConsumerState<LogcatView> createState() => _LogcatViewState();
}

class _LogcatViewState extends ConsumerState<LogcatView> {
  late LogcatViewModel viewModel;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(logcatViewmodelProvider)..getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
        title: "LogDownload",
        backgroundColor: Colors.transparent,
        backgroundImage: Image.asset(
          "assets/image/background.png",
          fit: BoxFit.fill,
        ),
        titleColor: kTextReverseColor,
        leading: CustomIconButton(
          onPressed: () => viewModel.navigatePop(context),
          icon: Icons.navigate_before,
          iconColor: kTextReverseColor,
        ),
        actions: [
          CustomIconButton(
            onPressed: () => viewModel.navigateToLogcatChartView(context),
            icon: Icons.area_chart,
          ),
        ],
        body: ListenableBuilder(
            listenable: viewModel.logcatState,
            builder: (_, __) => viewModel.logcatState.isSuccess
                ? ResponsiveContainer(
                    children: [
                      ResponsiveWidget(
                        wFlex: 1,
                        child: Container(),
                      ),
                      ResponsiveWidget(
                        wFlex: 8,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(
                                kBorderRadiusSize,
                              ),
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                    child: Table(
                                  border: TableBorder.all(color: Colors.white.withOpacity(0.6)),
                                  columnWidths: const {
                                    0: FlexColumnWidth(1.0),
                                    1: FlexColumnWidth(4.0),
                                    2: FlexColumnWidth(4.0),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                            child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text('Index',
                                                  style: kTextReverseStyle.copyWith(fontSize: 15.0))),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text('Log File',
                                                  style: kTextReverseStyle.copyWith(fontSize: 15.0))),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text('Output File',
                                                  style: kTextReverseStyle.copyWith(fontSize: 15.0))),
                                        )),
                                      ],
                                    ),
                                    ...viewModel.logcatState.value!.reversed
                                        .toList()
                                        .asMap()
                                        .entries
                                        .where((entry) {
                                      final LogData logCatData = entry.value;
                                      return logCatData.logName.isNotEmpty &&
                                          logCatData.outputName.isNotEmpty;
                                    }).map((entry) {
                                      final int index = entry.key + 1;
                                      final LogData logCatData = entry.value;
                                      return TableRow(
                                        children: [
                                          TableCell(
                                            verticalAlignment: TableCellVerticalAlignment.middle,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        minWidth: 20.0),
                                                child: Center(
                                                    child: Text(
                                                        index.toString(),
                                                        style:
                                                            kTextReverseStyle.copyWith(fontSize: 15.0))),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        minWidth: 100.0),
                                                child: InkWell(
                                                  onTap: () =>
                                                      viewModel.downloadFile(
                                                          logCatData.logName
                                                              .toString()),
                                                  child: Center(
                                                      child: TextButton(
                                                    onPressed: () {
                                                      viewModel.downloadFile(
                                                          logCatData.logName
                                                              .toString());
                                                    },
                                                    child: Text(
                                                      logCatData.logName
                                                          .toString(),
                                                      style: kTextReverseStyle.copyWith(fontSize: 16),
                                                    ),
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        minWidth: 100.0),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: List.generate(
                                                      logCatData
                                                          .outputName.length,
                                                      (index) => InkWell(
                                                        onTap: () => viewModel
                                                            .downloadFile(
                                                                logCatData
                                                                    .outputName[
                                                                        index]
                                                                    .toString()),
                                                        child: TextButton(
                                                          child: Text(
                                                            logCatData
                                                                .outputName[
                                                                    index]
                                                                .toString(),
                                                            style:
                                                                kTextReverseStyle.copyWith(fontSize: 16),
                                                          ),
                                                          onPressed: () {
                                                            viewModel
                                                                .downloadFile(
                                                                logCatData
                                                                    .outputName[
                                                                index]
                                                                    .toString());
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ));
                              },
                            )),
                      ),
                      ResponsiveWidget(
                        wFlex: 1,
                        child: Container(),
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  )));
  }
}
