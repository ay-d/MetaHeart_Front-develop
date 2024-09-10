import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:cardio_sim/auth/model/state/member_state.dart';
import 'package:cardio_sim/common/component/chart/custom_chart_controller.dart';
import 'package:cardio_sim/common/component/container/accordion_container.dart';
import 'package:cardio_sim/common/local_storage/local_storage.dart';
import 'package:cardio_sim/common/value_state/util/value_state_util.dart';
import 'package:cardio_sim/home/viewmodel/home_viewmodel.dart';
import 'package:cardio_sim/menu/model/type/menu_type/extension/menu_type_extension.dart';
import 'package:cardio_sim/menu/model/type/menu_type/menu_type.dart';
import 'package:cardio_sim/menu/provider/menu_stack_provider.dart';
import 'package:cardio_sim/simulation/component/input_deck/custom_dropdown_button.dart';
import 'package:cardio_sim/simulation/component/input_deck/file_picker.dart';
import 'package:cardio_sim/simulation/component/input_deck/radio_button.dart';
import 'package:cardio_sim/simulation/component/input_deck/slider_number_input_field.dart';
import 'package:cardio_sim/simulation/component/menu/accordion_menu/accordion_menu.dart';
import 'package:cardio_sim/simulation/component/menu/basic_menu_item.dart';
import 'package:cardio_sim/simulation/component/menu/tab_menu/tab_menu.dart';
import 'package:cardio_sim/simulation/component/menu_type_extension/pulse_viewer.dart';
import 'package:cardio_sim/simulation/model/entity/chart_data.dart';
import 'package:cardio_sim/simulation/model/entity/input_deck_data.dart';
import 'package:cardio_sim/simulation/model/entity/mp4_data.dart';
import 'package:cardio_sim/simulation/model/entity/pdf_data.dart';
import 'package:cardio_sim/simulation/model/service/simulation_service.dart';
import 'package:cardio_sim/simulation/model/state/simulation_state.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:pdfx/pdfx.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

final simulationViewModelProvider = Provider((ref) => SimulationViewModel(ref));

class SimulationViewModel {
  Ref ref;
  final LocalStorage storage = LocalStorage();

  final ScreenshotController screenshotController = ScreenshotController();

  final CustomPopupMenuController customPopupMenuController =
      CustomPopupMenuController();

  late final MenuStack _menuStack;

  late SimulationService _service;

  final InputDeckState inputDeckState = InputDeckState();

  final MemberState _memberState = MemberState();

  final ChartState chartState = ChartState();

  final StaticState staticState = StaticState();

  final CSVState csvState = CSVState();

  late final TabMenuController topTabController;

  late final AccordionMenuController leftAccordionController;
  late final AccordionMenuController rightAccordionController;
  late final AccordionMenuController bottomAccordionController;
  late final AccordionMenuController pulseAccordionController;

  final int initialPage = 1;
  late PdfController pdfController;
  late VideoPlayerController videoPlayerController;

  late final CustomChartController chartController;

  MenuType get _menu => _menuStack.peek()!;

  bool get isRadioPng =>
      _menu.extension?.contains(MenuTypeExtension.radioPng) ?? false;

  bool get isPdfOutPut =>
      _menu.extension?.contains(MenuTypeExtension.pdfOutPut) ?? false;

  bool get isMP4OutPut =>
      _menu.extension?.contains(MenuTypeExtension.mp4OutPut) ?? false;

  String get title => _menuStack.peek()?.title ?? "";

  final LogList logList = LogList();

  List<AccordionController> accordionControllers = [];
  List<List<ValueNotifier>> inputControllers = [];

  final PulseViewerController pulseViewerController =
      PulseViewerController(PulseType.single);

  SimulationViewModel(this.ref) {
    _service = ref.read(simulationServiceProvider);

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

        if (_menu.extension?.contains(MenuTypeExtension.radioPng) ?? false) {
          pulseViewerController.setNotifier(findPulseRadio()!, (data) {
            switch (data.toString()) {
              case "Single Pulse":
                return PulseType.single;
              case "Double Pulse":
                return PulseType.double;
              case "Triple Pulse":
                return PulseType.triple;
              default:
                return PulseType.single;
            }
          });
        }
      }
      if (inputDeckState.isNone) {
        accordionControllers.clear();
        inputControllers.clear();
        leftAccordionController.close();
      }
    });

    chartState.addListener(() {
      if (chartState.isSuccess) {
        topTabController.menuList = chartState.value!
            .map(
              (e) => BasicMenuItemData(e.title),
            )
            .toList();
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
    pulseAccordionController = AccordionMenuController(
      [BasicMenuItemData("Pulse Type")],
    );

    _menuStack = ref.read(menuStackProvider);

    topTabController.addListener(() {
      if (chartState.isSuccess && chartState.value != null) {
        final dataAtIndex = chartState.value![topTabController.index];
        if (dataAtIndex is ChartData) {
          chartController.setChartData(dataAtIndex);
        } else if (dataAtIndex is MP4Data) {
          Uri uri = Uri.parse(dataAtIndex.fileName);
          videoPlayerController = VideoPlayerController.networkUrl(uri)
            ..initialize();
          videoPlayerController.play();
        } else if (dataAtIndex is PDFData) {
          final Future<PdfDocument> doc =
              PdfDocument.openData(Uint8List.fromList(dataAtIndex.fileContent));
          pdfController = PdfController(document: doc);
        } else {
          //TODO: *.img(ex. ImgData), *.txt(ex. TxtData) 처리 추가
          print('Invalid type at index ${topTabController.index}');
        }
      }
    });
  }

  RadioButtonController? findPulseRadio() {
    RadioButtonController? result;

    for (int i = 0; i < (inputDeckState.value ?? []).length; i++) {
      InputDeckData data = (inputDeckState.value ?? [])[i];
      if (data.title == "Pulse Type") {
        result = inputControllers[i][0] as RadioButtonController;
        break;
      }
    }
    return result;
  }

  void getInputDeck() {
    inputDeckState.withResponse(_service.getInputDeck());
    chartState.none();
    staticState.none();
  }

  void getResult() {
    if (logList.length == 0) return;

    String temp = logList[logList.length - 1].toString();

    temp = temp.replaceAll('[', '');
    temp = temp.replaceAll(']', '');
    temp = temp.replaceAll('"', '');

    List<String> fileList = temp.split(',');

    //print(fileList.sublist(1));

    bottomAccordionController.close();
    chartState.withResponse(_service.processFile(
        _memberState.value!.s3Path,
        fileList.sublist(1),
        // list
    ));
    // TODO : static data 받아오기
  }

  int getType() {
    try {
      String extension =
          getExtension(topTabController.menuList[topTabController.index].text);
      switch (extension) {
        case "plt":
          return 1;
        case "mp4":
          return 2;
        case "pdf":
          return 3;
        default:
          return 1;
      }
    } catch (e) {
      return 1;
    }
  }

  String getExtension(String fileName) {
    int dotIndex = fileName.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex < fileName.length - 1) {
      return fileName.substring(dotIndex + 1);
    } else {
      print("output error");
      return "";
    }
  }

  void navigatePop(HomeViewModel viewModel) {
    inputDeckState.none();
    chartState.none();
    staticState.none();
    logList.clear();
    _menuStack.pop();
    viewModel.maintain();
  }

  void navigatePopAll() {
    inputDeckState.none();
    chartState.none();
    staticState.none();
    logList.clear();
    _menuStack.clear();
  }

  void closeSavePopup() {
    customPopupMenuController.hideMenu();
  }

  // captures a screenshot of a chart, downloads the captured image.
  void screenshot() {
    closeSavePopup();
    screenshotController
        .capture(delay: const Duration(milliseconds: 5))
        .then((capturedImage) async {
      if (chartState.isSuccess == false) {
        throw Exception('The captured image is an empty chart.');
      }
      if (capturedImage == null) {
        throw Exception('The captured image is null.');
      }
      downloadWeb(capturedImage);
      //download();
    }).catchError((onError) {
      print("[screenshot error] " + onError.toString());
    });
  }

  List<String> getPlt() {
    closeSavePopup();
    return _service.getPltContent2();
  }

  List<String> getCsv() {
    closeSavePopup();
    return _service.getPltContent2();
  }

  // Function to download a PNG file when running in local version.
  Future<void> download() async {
    String userName = _memberState.value!.name;
    String tempTabName = topTabController.menuList[topTabController.index].text;
    String tabName =
        (tempTabName[0].toUpperCase() + tempTabName.substring(1)).split('.')[0];
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    String baseFileName = "${title}_${userName}_$tabName.PNG";
    String path = '$selectedDirectory';
    String fileName = await generateUniqueFileName(path, baseFileName);

    screenshotController.captureAndSave(path, fileName: fileName);
  }

  // Function to download a PNG file when running in Web.
  Future<void> downloadWeb(Uint8List capturedImage) async {
    String userName = _memberState.value!.name;
    String tempTabName = topTabController.menuList[topTabController.index].text;
    String tabName =
        (tempTabName[0].toUpperCase() + tempTabName.substring(1)).split('.')[0];
    await WebImageDownloader.downloadImageFromUInt8List(
        uInt8List: capturedImage, name: "${title}_${userName}_$tabName");
  }

  Future<String> generateUniqueFileName(
      String directory, String baseFileName) async {
    String fileName = baseFileName;
    int index = 1;
    while (await File('$directory/$fileName').exists()) {
      fileName = baseFileName.replaceAll('.png', ' ($index).png');
      index++;
    }
    return fileName;
  }

  void downloadMP4orPDF() async {
    String name = topTabController.menuList[topTabController.index].text;
    if (await canLaunchUrl(Uri.parse(
        '${dotenv.get("S3_PATH")}/${_memberState.value!.s3Path}/$name'))) {
      await launchUrl(Uri.parse(
          '${dotenv.get("S3_PATH")}/${_memberState.value!.s3Path}/$name'));
    } else {
      print('Could not launch $name');
    }
  }

  Future<void> downloadCSV() async {
    String userName = _memberState.value!.name;
    String tempTabName = topTabController.menuList[topTabController.index].text;
    String tabName =
        (tempTabName[topTabController.index].toUpperCase() + tempTabName.substring(1)).split('.')[0];
    String pltData = getPlt()[topTabController.index];
    List<String> rawList = pltData.split("\n");
    List<String> columnList = rawList[topTabController.index].split(",");

    String header = columnList.join(',');

    List<String> rows = [];
    for (int i = 1; i < rawList.length; i += (rawList.length / 10000).ceil()) {
      try {
        List<String> raw = rawList[i].split(",");
        rows.add(raw.join(','));
      } catch (e) {}
    }
    Uint8List bytes =
        Uint8List.fromList(utf8.encode('$header\n${rows.join('\n')}'));

    await FileSaver.instance.saveFile(
      name: "${title}_${userName}_$tabName",
      bytes: bytes,
      ext: 'csv',
      mimeType: MimeType.csv,
    );
  }

  void _updateLog(String? log) {
    if (log != null) {
      //print(log);
      logList.add(log);
    }
  }

  void onExecuteClick() async {
    List<InputDeckData>? inputDeckDataList = inputDeckState.value;
    if (inputDeckDataList == null) return;
    chartState.none();
    leftAccordionController.close();
    bottomAccordionController.open();
    Map<String, dynamic> body = {};
    for (int i = 0; i < inputDeckDataList.length; i++) {
      final items = inputDeckDataList[i].items;
      for (int j = 0; j < items.length; j++) {
        final item = items[j];
        if (inputControllers[i][j] is TextEditingController) {
          String temp = (inputControllers[i][j] as TextEditingController).text;
          body[item.name ?? ''] =
              int.tryParse(temp.isEmpty ? '0' : temp) ?? temp;
        } else if (inputControllers[i][j] is CustomDropdownButtonController ||
            inputControllers[i][j] is RadioButtonController) {
          body[item.name ?? ''] =
              (inputControllers[i][j].value as InputDeckItemDataData).value;
        } else {
          body[item.name ?? ''] = inputControllers[i][j].value;
        }
      }
      body["User_Name"] = _memberState.value!.name;
    }

    _service.simulation(
      _menuStack.peek().toString(),
      _updateLog,
      getResult,
      body,
    );
  }
}

extension _InputDeckItemDataToController on InputDeckItemData {
  ValueNotifier get controller {
    switch (type) {
      case InputDeckItemType.number:
        return TextEditingController(text: defaultValue?.toString() ?? '');
      case InputDeckItemType.slider:
        return SliderController(
          double.tryParse(defaultValue?.toString() ?? '0.') ?? 0.0,
          min: 0,
          max: 10,
          divisions: 100,
        );
      case InputDeckItemType.dropdown:
        return CustomDropdownButtonController(data!);
      case InputDeckItemType.file:
        return FileSelectController(
          null,
          title: title ?? "",
          allowedExtensions: ['csv'],
        );
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
