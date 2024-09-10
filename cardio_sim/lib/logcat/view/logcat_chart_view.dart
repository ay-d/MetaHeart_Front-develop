import 'package:cardio_sim/common/component/chart/custom_chart.dart';
import 'package:cardio_sim/common/component/container/accordion_container.dart';
import 'package:cardio_sim/common/component/custom_text_form_field.dart';
import 'package:cardio_sim/common/responsive_widget/responsive_container.dart';
import 'package:cardio_sim/common/component/custom_elevated_button.dart';
import 'package:cardio_sim/common/component/custom_icon_button.dart';
import 'package:cardio_sim/common/component/default_container.dart';
import 'package:cardio_sim/common/responsive_widget/responsive_value_listener.dart';
import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:cardio_sim/common/value_state/component/value_state_listener.dart';
import 'package:cardio_sim/logcat/viewmodel/logcat_chart_viewmodel.dart';
import 'package:cardio_sim/simulation/component/input_deck/basic_number_input_field.dart';
import 'package:cardio_sim/simulation/component/input_deck/custom_dropdown_button.dart';
import 'package:cardio_sim/simulation/component/input_deck/custom_dropdown_button2.dart';
import 'package:cardio_sim/simulation/component/input_deck/file_picker.dart';
import 'package:cardio_sim/simulation/component/input_deck/radio_button.dart';
import 'package:cardio_sim/simulation/component/input_deck/slider_number_input_field.dart';
import 'package:cardio_sim/simulation/component/menu/accordion_menu/accordion_menu.dart';
import 'package:cardio_sim/simulation/component/menu/basic_menu.dart';
import 'package:cardio_sim/simulation/component/menu/tab_menu/tab_menu.dart';
import 'package:cardio_sim/simulation/component/statics/static_item.dart';
import 'package:cardio_sim/simulation/model/entity/input_deck_data.dart';
import 'package:collection/collection.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LogcatChartView extends ConsumerWidget {
  static String get name => "logcatChart";

  const LogcatChartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(logcatCharViewModelProvider);
    // return Container();
    return DefaultContainer(
      title: viewModel.title,
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
        CustomPopupMenu(
          controller: viewModel.customPopupMenuController,
          menuBuilder: () => ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Material(
                    color: const Color(0xFF4C4C4C),
                    child: InkWell(
                      onTap: viewModel.screenshot,
                      child: Container(
                        height: ResponsiveSize.S(50),
                        padding: EdgeInsets.symmetric(
                          horizontal: kPaddingLargeSize,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.image,
                              size: kIconSmallSize,
                              color: Colors.white,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Text(
                                "PNG",
                                style: kTextReverseStyle.copyWith(
                                  fontSize: kTextMiddleSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          pressType: PressType.singleClick,
          verticalMargin: -10,
          child: Icon(Icons.save, color: Colors.white, size: kIconMiddleSize),
        ),
      ],
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: kPaddingLargeSize * 3,
              bottom: kPaddingLargeSize,
            ),
            child: Row(
              children: [
                CustomElevatedButton(
                  borderRadiusCircular: 5.0,
                  color: Colors.white,
                  onPressed: viewModel.getInputDeck,
                  child:  const Text("upload log file"),
                ),
                SizedBox(width: kPaddingLargeSize),
                CustomElevatedButton(
                  borderRadiusCircular: 5.0,
                  color: Colors.white,
                  onPressed: viewModel.getResult,
                  child: const Text("upload plt file"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ResponsiveContainer(
              children: [
                ResponsiveChangeListener(
                  notifier: viewModel.leftAccordionController,
                  builder: (_, notifier, child) => ResponsiveWidget(
                    wFlex: notifier.isOpen ? 3 : null,
                    child: child!,
                  ),
                  child: _DesignedAccordionMenu(
                    align: ResponsiveData.kIsMobile
                        ? BasicMenuAlign.top
                        : BasicMenuAlign.left,
                    controller: viewModel.leftAccordionController,
                    children: [
                      ValueStateListener(
                        state: viewModel.inputDeckState,
                        defaultBuilder: (_, __) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: ResponsiveData.kIsMobile ? 0 : 1,
                              child: Container(),
                            ),
                          ],
                        ),
                        successBuilder: (_, state) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: ResponsiveData.kIsMobile ? 0 : 1,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: state.value!
                                      .expandIndexed<Widget>(
                                        (i, e) => [
                                          _DesignedAccordionContainer(
                                            title: e.title,
                                            controller: viewModel
                                                .accordionControllers[i],
                                            children: e.items
                                                .expandIndexed(
                                                  (j, e) => [
                                                    e.widget(viewModel
                                                            .inputControllers[i]
                                                        [j]),
                                                    if (viewModel
                                                            .inputControllers[i]
                                                            .length !=
                                                        1)
                                                      SizedBox(
                                                        height:
                                                            kPaddingSmallSize,
                                                      ),
                                                  ],
                                                )
                                                .toList(),
                                          ),
                                          SizedBox(height: kPaddingMiddleSize),
                                        ],
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ResponsiveChangeListener(
                  notifier: viewModel.leftAccordionController,
                  builder: (_, notifier, __) => ResponsiveSizedBox(
                    size: notifier.isOpen ? kLayoutGutterSize : 0,
                  ),
                ),
                ResponsiveWidget(
                  wFlex: 9,
                  mFlex: 1,
                  child: ValueStateListener(
                    state: viewModel.chartState,
                    defaultBuilder: (_, state) => Column(
                      children: [
                        TabMenu(
                          controller: viewModel.topTabController,
                          align: BasicMenuAlign.top,
                        ),
                        SizedBox(height: kPaddingSmallSize),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: kMainColor3.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(
                                kBorderRadiusSize,
                              ),
                            ),
                            padding: EdgeInsets.all(kPaddingMiddleSize),
                            child: SfCartesianChart(
                              legend: Legend(
                                isVisible: true,
                                textStyle: TextStyle(fontSize: kTextMiniSize),
                              ),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              zoomPanBehavior: ZoomPanBehavior(
                                enableMouseWheelZooming: true,
                                enablePanning: true,
                              ),
                              primaryXAxis: NumericAxis(
                                labelStyle: TextStyle(fontSize: kTextMiniSize),
                              ),
                              primaryYAxis: NumericAxis(
                                labelStyle: TextStyle(fontSize: kTextMiniSize),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    successBuilder: (_, state) => Column(
                      children: [
                        TabMenu(
                          controller: viewModel.topTabController,
                          align: BasicMenuAlign.top,
                        ),
                        SizedBox(height: kPaddingSmallSize),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: kMainColor3.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(
                                kBorderRadiusSize,
                              ),
                            ),
                            padding: EdgeInsets.all(kPaddingMiddleSize),
                            child: ListenableBuilder(
                              listenable: viewModel.topTabController,
                              builder: (_, __) {
                                final data = state
                                    .value![viewModel.topTabController.index];
                                return Screenshot(
                                  controller: viewModel.screenshotController,
                                  child: CustomChart(
                                    controller: viewModel.chartController,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveChangeListener(
                  notifier: viewModel.rightAccordionController,
                  builder: (_, notifier, __) => ResponsiveSizedBox(
                    size: notifier.isOpen ? kLayoutGutterSize : 0,
                  ),
                ),
                ResponsiveChangeListener(
                  notifier: viewModel.rightAccordionController,
                  builder: (_, notifier, child) => ResponsiveWidget(
                    wFlex: notifier.isOpen ? 3 : null,
                    child: child!,
                  ),
                  child: _DesignedAccordionMenu(
                    align: ResponsiveData.kIsMobile
                        ? BasicMenuAlign.bottom
                        : BasicMenuAlign.right,
                    controller: viewModel.rightAccordionController,
                    children: [
                      ValueStateListener(
                        state: viewModel.staticState,
                        defaultBuilder: (_, __) => Column(
                          children: [
                            _DesignedAccordionContainer(
                              title: 'Statics',
                              children: const [],
                            ),
                          ],
                        ),
                        successBuilder: (_, state) => Column(
                          children: [
                            _DesignedAccordionContainer(
                              title: 'Statics',
                              children: state.value!
                                  .expand(
                                    (e) => [
                                      StaticItem(e),
                                      SizedBox(
                                        height: kPaddingMiddleSize,
                                      )
                                    ],
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kPaddingMiddleSize),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveData.kIsMobile
                  ? 0
                  : kPaddingMiniSize * 3 +
                      kTextSmallSize +
                      kPaddingMiddleSize +
                      1,
            ),
            child: _DesignedAccordionMenu(
              align: BasicMenuAlign.bottom,
              controller: viewModel.bottomAccordionController,
              decoration: BoxDecoration(
                border: Border.all(color: kDisabledColor),
              ),
              children: [
                Container(
                  height: ResponsiveSize.S(250),
                  padding: EdgeInsets.all(kPaddingMiddleSize),
                  child: ListenableBuilder(
                    listenable: viewModel.logList,
                    builder: (_, __) => ListView.builder(
                      itemCount: viewModel.logList.length,
                      itemBuilder: (_, int index) => Text(
                        viewModel.logList[index],
                        style: kTextReverseStyle.copyWith(
                          fontSize: kTextMiddleSize,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension _InputDeckItemDataToWidget on InputDeckItemData {
  Widget widget(Listenable controller) {
    switch (type) {
      case InputDeckItemType.number:
        return BasicNumberInputField(
          headText: title,
          tail: Text(
            unit ?? "",
            style: kTextReverseStyle.copyWith(
              fontSize: kTextMiddleSize,
              fontWeight: FontWeight.normal,
            ),
          ),
          backgroundColor: Colors.transparent,
          textController: controller as TextEditingController,
          inputBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kDisabledColor),
            borderRadius: BorderRadius.circular(kBorderRadiusSize),
          ),
          decorationStyle: kTextReverseStyle.copyWith(
              fontSize: kTextMiddleSize, fontWeight: FontWeight.normal),
          enabled: false,
        );
      case InputDeckItemType.slider:
        return SliderNumberInputField(
          headText: title,
          sliderController: controller as SliderController,
          backgroundColor: Colors.transparent,
          inputBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kDisabledColor),
            borderRadius: BorderRadius.circular(kBorderRadiusSize),
          ),
          decorationStyle: kTextReverseStyle.copyWith(
              fontSize: kTextMiddleSize, fontWeight: FontWeight.normal),
        );
      case InputDeckItemType.dropdown:
        return CustomDropdownButton2(
          controller as CustomDropdownButtonController,
          headText: title,
          itemHeight: ResponsiveSize.S(44),
          textStyle: kTextNormalStyle.copyWith(
            fontSize: kTextMiddleSize,
            fontWeight: FontWeight.w400,
          ),
          decoration: BoxDecoration(
            color: kBackgroundMainColor,
            borderRadius: BorderRadius.circular(kBorderRadiusSize),
            border: Border.all(color: kDisabledColor),
          ),
        );
      case InputDeckItemType.file:
        return FileSelector(
          fileController: controller as FileSelectController,
          backgroundColor: Colors.transparent,
          inputBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kDisabledColor),
            borderRadius: BorderRadius.circular(kBorderRadiusSize),
          ),
          decorationStyle: kTextReverseStyle.copyWith(
              fontSize: kTextMiddleSize, fontWeight: FontWeight.normal),
        );
      case InputDeckItemType.radio:
        return RadioButton(
          controller as RadioButtonController,
          title: title ?? "",
          itemHeight: ResponsiveSize.S(44),
          textStyle: kTextReverseStyle.copyWith(
            fontSize: kTextMiddleSize,
            fontWeight: FontWeight.normal,
          ),
        );
      case InputDeckItemType.text:
        return CustomTextFormField(
          labelText: title ?? "",
          tail: Text(
            unit ?? "",
            style: kTextReverseStyle.copyWith(
              fontSize: kTextMiddleSize,
              fontWeight: FontWeight.normal,
            ),
          ),
          backgroundColor: Colors.transparent,
          textController: controller as TextEditingController,
          inputBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: kDisabledColor),
            borderRadius: BorderRadius.circular(kBorderRadiusSize),
          ),
          decorationStyle: kTextReverseStyle.copyWith(
            fontSize: kTextMiddleSize,
            fontWeight: FontWeight.normal,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: kPaddingMiddleSize,
            horizontal: kPaddingSmallSize,
          ),
        );
    }
  }
}

class _DesignedAccordionContainer extends AccordionContainer {
  _DesignedAccordionContainer({
    required super.title,
    super.controller,
    required super.children,
  }) : super(
          textColor: kTextReverseColor,
          closedDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              kBorderRadiusSize,
            ),
            color: kMainColor3.withOpacity(0.5),
          ),
          openDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              kBorderRadiusSize,
            ),
            gradient: RadialGradient(
              colors: [
                kMainColor.withOpacity(0.5),
                kMainColor3.withOpacity(0.5),
              ],
              stops: const [0, 1],
              center: const Alignment(-2, 2),
              radius: 5,
            ),
          ),
        );
}

class _DesignedAccordionMenu extends AccordionMenu {
  _DesignedAccordionMenu({
    super.align,
    super.decoration,
    required super.controller,
    required super.children,
  }) : super(
          titleColor: kTextReverseColor,
        );
}
