import 'dart:io';

import 'package:cardio_sim/auth/model/state/member_state.dart';
import 'package:cardio_sim/common/component/chart/custom_chart_controller.dart';
import 'package:cardio_sim/common/component/container/accordion_container.dart';
import 'package:cardio_sim/common/local_storage/local_storage.dart';
import 'package:cardio_sim/common/value_state/util/value_state_util.dart';
import 'package:cardio_sim/logcat/model/service/logcat_chart_service.dart';
import 'package:cardio_sim/simulation/component/input_deck/custom_dropdown_button.dart';
import 'package:cardio_sim/simulation/component/input_deck/file_picker.dart';
import 'package:cardio_sim/simulation/component/input_deck/radio_button.dart';
import 'package:cardio_sim/simulation/component/input_deck/slider_number_input_field.dart';
import 'package:cardio_sim/simulation/component/menu/accordion_menu/accordion_menu.dart';
import 'package:cardio_sim/simulation/component/menu/basic_menu_item.dart';
import 'package:cardio_sim/simulation/component/menu/tab_menu/tab_menu.dart';
import 'package:cardio_sim/simulation/model/entity/chart_data.dart';
import 'package:cardio_sim/simulation/model/entity/input_deck_data.dart';
import 'package:cardio_sim/simulation/model/state/simulation_state.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:screenshot/screenshot.dart';

final logcatCharViewModelProvider =
    Provider((ref) => LogcatChartViewModel(ref));

class LogcatChartViewModel {
  Ref ref;
  final LocalStorage storage = LocalStorage();

  final ScreenshotController screenshotController = ScreenshotController();

  final CustomPopupMenuController customPopupMenuController =
      CustomPopupMenuController();

  late LogcatChartService _service;

  final InputDeckState inputDeckState = InputDeckState();

  final MemberState _memberState = MemberState();

  final ChartState chartState = ChartState();

  final StaticState staticState = StaticState();

  late final TabMenuController topTabController;

  late final AccordionMenuController leftAccordionController;
  late final AccordionMenuController rightAccordionController;
  late final AccordionMenuController bottomAccordionController;

  late final CustomChartController chartController;

  String get title => "LogCat";

  final LogList logList = LogList();

  List<AccordionController> accordionControllers = [];
  List<List<ValueNotifier>> inputControllers = [];

  LogcatChartViewModel(this.ref) {
    _service = ref.read(logcatChartServiceProvider);

    chartController = CustomChartController();

    inputDeckState.addListener(() {
      if (inputDeckState.isSuccess) {
        accordionControllers = inputDeckState.value!
            .map((e) => AccordionController(initState: true))
            .toList();
        inputControllers = inputDeckState.value!
            .map((e) => e.items.map((e) => e.controller).toList())
            .toList();
        leftAccordionController.open();
      }
      if (inputDeckState.isNone) {
        accordionControllers.clear();
        inputControllers.clear();
        leftAccordionController.close();
      }
    });

    chartState.addListener(() {
      if (chartState.isSuccess) {
        topTabController.menuList =
            chartState.value!.map((e) => BasicMenuItemData(e.title)).toList();
        leftAccordionController.close();
        topTabController.onMenuItemTap(0);
      }
      if (chartState.isNone) {
        topTabController.menuList.clear();
        chartController.clearAll();
      }
    });

    topTabController = TabMenuController([]);
    leftAccordionController = AccordionMenuController(
      [BasicMenuItemData("Input Deck", prefix: Icons.add)],
    );
    rightAccordionController = AccordionMenuController(
      [BasicMenuItemData("Statics", prefix: Icons.add)],
    );
    bottomAccordionController = AccordionMenuController(
      [BasicMenuItemData("Logcat", prefix: Icons.add)],
    );

    topTabController.addListener(() {
      final dataAtIndex = chartState.value![topTabController.index];
      if (dataAtIndex is ChartData) {
        chartController.setChartData(dataAtIndex);
      } else {
        print('Invalid type at index ${topTabController.index}');
      }
    });
  }

  void getInputDeck() {
    inputDeckState.withResponse(_service.getInputDeck());
  }

  void getResult() {
    bottomAccordionController.close();
    chartState.withResponse(_service.getChartData());

    // TODO : static data 받아오기
  }

  void navigatePop(BuildContext context) {
    context.pop();
    inputDeckState.none();
    chartState.none();
  }

  void closeSavePopup() {
    customPopupMenuController.hideMenu();
  }

  void screenshot() {
    closeSavePopup();
    screenshotController
        .capture(delay: const Duration(milliseconds: 5))
        .then((capturedImage) async {
      if (chartState.isSuccess == false) {
        throw Exception('캡처된 이미지가 빈 차트입니다.');
      }
      if (capturedImage == null) {
        throw Exception('캡처된 이미지가 null입니다.');
      }
      if (Platform.isWindows || Platform.isLinux) {
        download();
      } else {
        downloadWeb(capturedImage);
      }
    }).catchError((onError) {
      print("[screenshot error] " + onError.toString());
    });
  }

  Future<void> download() async {
    String userName = _memberState.value!.name;
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    String baseFileName = "${title}_${userName}_logcat.PNG";
    String path = '$selectedDirectory';
    String fileName = await generateUniqueFileName(path, baseFileName);
    screenshotController.captureAndSave(path, fileName: fileName);
  }

  Future<String> generateUniqueFileName(String directory, String baseFileName) async {
    String fileName = baseFileName;
    int index = 1;

    while (await File('$directory/$fileName').exists()) {
      fileName = '${baseFileName.replaceAll('.PNG', ' ($index).PNG')}';
      index++;
    }

    return fileName;
  }

  Future<void> downloadWeb(Uint8List capturedImage) async {
    String userName = _memberState.value!.name;

    await WebImageDownloader.downloadImageFromUInt8List(
        uInt8List: capturedImage, name: "${title}_${userName}_logcat");
  }
}

extension _InputDeckItemDataToController on InputDeckItemData {
  ValueNotifier get controller {
    switch (type) {
      case InputDeckItemType.number:
        return TextEditingController(text: defaultValue.toString());
      case InputDeckItemType.slider:
        return SliderController(
          double.parse(defaultValue.toString()),
          min: 0,
          max: 10,
          divisions: 100,
        );
      case InputDeckItemType.dropdown:
        return CustomDropdownButtonController(data!);
      case InputDeckItemType.file:
        return FileSelectController(null,
            title: title ?? "", allowedExtensions: ['csv']);
      case InputDeckItemType.radio:
        return RadioButtonController(data!);
      case InputDeckItemType.text:
        return TextEditingController(text: defaultValue?.toString() ?? '');
    }
  }
}

class LogList extends ChangeNotifier {
  final List<String> _logList = [];

  String operator [](int index) => _logList[index];

  int get length => _logList.length;

  void clear() => _logList.clear();

  void add(String log) {
    _logList.add(log);
    notifyListeners();
  }
}
