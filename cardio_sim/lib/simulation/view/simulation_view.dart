import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cardio_sim/common/component/chart/custom_chart.dart';
import 'package:cardio_sim/common/component/components.dart';
import 'package:cardio_sim/common/component/container/accordion_container.dart';
import 'package:cardio_sim/common/responsive_widget/responsive_container.dart';
import 'package:cardio_sim/common/component/custom_elevated_button.dart';
import 'package:cardio_sim/common/component/custom_icon_button.dart';
import 'package:cardio_sim/common/component/default_container.dart';
import 'package:cardio_sim/common/responsive_widget/responsive_value_listener.dart';
import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:cardio_sim/common/value_state/component/value_state_listener.dart';
import 'package:cardio_sim/home/viewmodel/home_viewmodel.dart';
import 'package:cardio_sim/simulation/component/input_deck/basic_number_input_field.dart';
import 'package:cardio_sim/simulation/component/input_deck/custom_dropdown_button.dart';
import 'package:cardio_sim/simulation/component/input_deck/custom_dropdown_button2.dart';
import 'package:cardio_sim/simulation/component/input_deck/file_picker.dart';
import 'package:cardio_sim/simulation/component/input_deck/radio_button.dart';
import 'package:cardio_sim/simulation/component/input_deck/slider_number_input_field.dart';
import 'package:cardio_sim/simulation/component/menu/accordion_menu/accordion_menu.dart';
import 'package:cardio_sim/simulation/component/menu/basic_menu.dart';
import 'package:cardio_sim/simulation/component/menu/tab_menu/tab_menu.dart';
import 'package:cardio_sim/simulation/component/menu_type_extension/pulse_viewer.dart';
import 'package:cardio_sim/simulation/component/statics/static_item.dart';
import 'package:cardio_sim/simulation/model/entity/input_deck_data.dart';
import 'package:cardio_sim/simulation/viewmodel/simulation_viewmodel.dart';
import 'package:collection/collection.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfx/pdfx.dart';
import 'package:screenshot/screenshot.dart';
import 'package:video_player/video_player.dart';

class SimulationView extends ConsumerStatefulWidget {
  static String get name => "simulation";

  const SimulationView({Key? key}) : super(key: key);

  @override
  ConsumerState<SimulationView> createState() => _SimulationViewState();
}

class _SimulationViewState extends ConsumerState<SimulationView> {
  late SimulationViewModel viewModel;
  late HomeViewModel homeViewModel;
  bool _isMouseHovered = false;
  bool _isBarHovered = false;

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(simulationViewModelProvider)..getInputDeck();
    homeViewModel = ref.read(homeViewModelProvider);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      title: viewModel.title,
      backgroundColor: Colors.transparent,
      backgroundImage: Image.asset(
        "assets/image/background.png",
        fit: BoxFit.fill,
      ),
      titleColor: kTextReverseColor,
      leading: CustomIconButton(
        onPressed: () => viewModel.navigatePop(homeViewModel),
        icon: Icons.navigate_before,
        iconColor: kTextReverseColor,
        hintMessage: "Back",
      ),
      actions: [
        CustomIconButton(
          onPressed: viewModel.navigatePopAll,
          icon: Icons.home,
          iconColor: kTextReverseColor,
          hintMessage: "Go Home",
        ),
        Tooltip(
          message: "Save",
          textStyle: kTextNormalStyle.copyWith(
            fontSize: kTextSmallSize,
            color: kTextReverseColor,
            fontWeight: FontWeight.w400,
          ),
          child: CustomPopupMenu(
            controller: viewModel.customPopupMenuController,
            menuBuilder: () => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    viewModel.getType() == 1
                        ? Material(
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
                        : Container(),
                    viewModel.getType() == 1
                        ? Material(
                            color: const Color(0xFF4C4C4C),
                            child: InkWell(
                              onTap: viewModel.downloadCSV,
                              child: Container(
                                height: ResponsiveSize.S(50),
                                padding: EdgeInsets.symmetric(
                                  horizontal: kPaddingLargeSize,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.note,
                                      size: kIconSmallSize,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "CSV",
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
                        : Container(),
                    viewModel.getType() == 2
                        ? Material(
                            color: const Color(0xFF4C4C4C),
                            child: InkWell(
                              onTap: viewModel.downloadMP4orPDF,
                              child: Container(
                                height: ResponsiveSize.S(50),
                                padding: EdgeInsets.symmetric(
                                  horizontal: kPaddingLargeSize,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.video_collection,
                                      size: kIconSmallSize,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "MP4",
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
                        : Container(),
                    viewModel.getType() == 3
                        ? Material(
                            color: const Color(0xFF4C4C4C),
                            child: InkWell(
                              onTap: viewModel.downloadMP4orPDF,
                              child: Container(
                                height: ResponsiveSize.S(50),
                                padding: EdgeInsets.symmetric(
                                  horizontal: kPaddingLargeSize,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.sticky_note_2_outlined,
                                      size: kIconSmallSize,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "PDF",
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
                        : Container(),
                  ],
                ),
              ),
            ),
            pressType: PressType.singleClick,
            verticalMargin: -10,
            child: Icon(Icons.save, color: Colors.white, size: kIconMiddleSize),
          ),
        )
      ],
      body: Column(
        children: [
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
                            Padding(
                              padding: EdgeInsets.only(
                                top: kPaddingMiddleSize,
                              ),
                              child: CustomElevatedButton(
                                onPressed: viewModel.onExecuteClick,
                                child: Text(
                                  "Execute",
                                  style: kTextReverseStyle.copyWith(
                                    fontSize: kTextMiddleSize,
                                  ),
                                ),
                              ),
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
                            Padding(
                              padding: EdgeInsets.only(
                                top: kPaddingMiddleSize,
                              ),
                              child: CustomElevatedButton(
                                onPressed: viewModel.onExecuteClick,
                                child: Text(
                                  "Execute",
                                  style: kTextReverseStyle.copyWith(
                                    fontSize: kTextMiddleSize,
                                  ),
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
                  child: Column(
                    children: [
                      if (viewModel.isRadioPng)
                        _DesignedAccordionMenu(
                          controller: viewModel.pulseAccordionController,
                          align: BasicMenuAlign.top,
                          children: [
                            Center(
                              child: PulseViewer(
                                path: "assets/image/pulse",
                                height: ResponsiveSize.S(500),
                                controller: viewModel.pulseViewerController,
                              ),
                            ),
                          ],
                        ),
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
                              builder: (_, __) => (viewModel.getType() == 1)
                                  ? (viewModel.isPdfOutPut ||
                                          viewModel.isMP4OutPut)
                                      ? Container()
                                      : Screenshot(
                                          controller:
                                              viewModel.screenshotController,
                                          child: CustomChart(
                                            controller:
                                                viewModel.chartController,
                                          ),
                                        )
                                  : (viewModel.getType() == 2)
                                      ? ListenableBuilder(
                                          listenable:
                                              viewModel.videoPlayerController,
                                          builder: (_, __) => Center(
                                              child: viewModel
                                                      .videoPlayerController
                                                      .value
                                                      .isInitialized
                                                  ? AspectRatio(
                                                      aspectRatio: viewModel
                                                          .videoPlayerController
                                                          .value
                                                          .aspectRatio,
                                                      child: MouseRegion(
                                                        onHover: (event) => {
                                                          setState(() {
                                                            _isMouseHovered =
                                                                true;
                                                          })
                                                        },
                                                        onExit: (event) => {
                                                          setState(() {
                                                            _isMouseHovered =
                                                                false;
                                                          })
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            VideoPlayer(viewModel
                                                                .videoPlayerController),
                                                            _isMouseHovered ==
                                                                    true
                                                                ? Opacity(
                                                                    opacity:
                                                                        0.2,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              color: Colors.black),
                                                                    ))
                                                                : Container(),
                                                            _isMouseHovered ==
                                                                    true
                                                                ? Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        FloatingActionButton(
                                                                          focusElevation:
                                                                              0,
                                                                          // hoverColor: Colors.transparent,
                                                                          highlightElevation:
                                                                              0,
                                                                          disabledElevation:
                                                                              0,
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                                                          foregroundColor:
                                                                              Colors.white,
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              viewModel.videoPlayerController.value.isCompleted
                                                                                  ? viewModel.videoPlayerController.play()
                                                                                  : viewModel.videoPlayerController.value.isPlaying
                                                                                      ? viewModel.videoPlayerController.pause()
                                                                                      : viewModel.videoPlayerController.play();
                                                                            });
                                                                          },
                                                                          splashColor:
                                                                              Colors.transparent,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          hoverElevation:
                                                                              0,
                                                                          elevation:
                                                                              0,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10.0),
                                                                            child:
                                                                                Icon(
                                                                              viewModel.videoPlayerController.value.isCompleted
                                                                                  ? Icons.replay
                                                                                  : viewModel.videoPlayerController.value.isPlaying
                                                                                      ? Icons.pause
                                                                                      : Icons.play_arrow,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Container(),
                                                            _isMouseHovered ==
                                                                    true
                                                                ? Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            10.0),
                                                                        child:
                                                                            MouseRegion(
                                                                          onHover:
                                                                              (event) => {
                                                                            setState(() {
                                                                              _isBarHovered = true;
                                                                            })
                                                                          },
                                                                          onExit:
                                                                              (event) => {
                                                                            setState(() {
                                                                              _isBarHovered = false;
                                                                            })
                                                                          },
                                                                          child:
                                                                              ProgressBar(
                                                                            timeLabelType:
                                                                                TimeLabelType.remainingTime,
                                                                            timeLabelTextStyle:
                                                                                kTextReverseStyle,
                                                                            timeLabelPadding: _isBarHovered
                                                                                ? 2.0
                                                                                : 5.0,
                                                                            baseBarColor:
                                                                                Colors.white.withOpacity(0.5),
                                                                            thumbGlowRadius:
                                                                                0.0,
                                                                            thumbRadius: _isBarHovered
                                                                                ? 6.0
                                                                                : 0.0,
                                                                            barHeight: _isBarHovered
                                                                                ? 6.0
                                                                                : 5.0,
                                                                            progress:
                                                                                viewModel.videoPlayerController.value.position,
                                                                            total:
                                                                                viewModel.videoPlayerController.value.duration,
                                                                            onSeek:
                                                                                (duration) {
                                                                              viewModel.videoPlayerController.seekTo(duration);
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : const CircularProgressIndicator()))
                                      : viewModel.getType() == 3
                                          ? Stack(
                                              children: [
                                                PdfView(
                                                  builders: PdfViewBuilders<
                                                      DefaultBuilderOptions>(
                                                    options:
                                                        const DefaultBuilderOptions(),
                                                    documentLoaderBuilder:
                                                        (_) => const Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    pageLoaderBuilder: (_) =>
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                  ),
                                                  controller:
                                                      viewModel.pdfController,
                                                ),
                                                IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(Icons
                                                            .navigate_before),
                                                        onPressed: () {
                                                          viewModel
                                                              .pdfController
                                                              .previousPage(
                                                            curve: Curves.ease,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                          );
                                                        },
                                                      ),
                                                      Center(
                                                        child: PdfPageNumber(
                                                          controller: viewModel
                                                              .pdfController,
                                                          builder: (_,
                                                                  loadingState,
                                                                  page,
                                                                  pagesCount) =>
                                                              Text(
                                                                  '$page/${pagesCount ?? 0}',
                                                                  style:
                                                                      kTextNormalStyle),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(Icons
                                                            .navigate_next),
                                                        onPressed: () {
                                                          viewModel
                                                              .pdfController
                                                              .nextPage(
                                                            curve: Curves.ease,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container()),
                        ),
                      ),
                    ],
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
        );
      case InputDeckItemType.slider:
        return SliderNumberInputField(
          labelText: title ?? "",
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
          labelText: title,
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
          title: title ?? "",
          controller as RadioButtonController,
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
