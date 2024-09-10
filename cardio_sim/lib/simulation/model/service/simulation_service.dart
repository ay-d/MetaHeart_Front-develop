import 'dart:convert';
import 'dart:typed_data';

import 'package:cardio_sim/common/entity/response_entity.dart';
import 'package:cardio_sim/menu/provider/menu_stack_provider.dart';
import 'package:cardio_sim/simulation/model/entity/chart_data.dart';
import 'package:cardio_sim/simulation/model/entity/input_deck_data.dart';
import 'package:cardio_sim/simulation/model/entity/mp4_data.dart';
import 'package:cardio_sim/simulation/model/entity/output_data.dart';
import 'package:cardio_sim/simulation/model/entity/pdf_data.dart';
import 'package:cardio_sim/simulation/model/entity/static_data.dart';
import 'package:cardio_sim/simulation/model/repository/result_repository.dart';
import 'package:cardio_sim/simulation/model/repository/simulation_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final simulationServiceProvider = Provider((ref) {
  final simulationRepository = ref.read(simulationRepositoryProvider);
  final resultRepository = ref.read(resultRepositoryProvider);
  final menuStack = ref.read(menuStackProvider);
  return SimulationService(simulationRepository, resultRepository, menuStack);
});

class SimulationService {
  final SimulationRepository simulationRepository;
  final ResultRepository resultRepository;
  final MenuStack menuStack;
  List<String> pltFileList = [];

  SimulationService(
      this.simulationRepository, this.resultRepository, this.menuStack);

  Future<ResponseEntity<List<InputDeckData>>> getInputDeck() async {
    try {
      final value =
          await simulationRepository.getInputDeck(menuStack.peek().toString());
      final jsons = json.decode(value);
      if (jsons is List<dynamic>) {
        return ResponseEntity.success(
            entity: jsons
                .map((e) => InputDeckData.fromJson(e as Map<String, dynamic>))
                .toList());
      }
      return ResponseEntity.success(entity: [InputDeckData.fromJson(jsons)]);
    } on DioException catch (e) {
      return ResponseEntity.error(message: e.message);
    } catch (e) {
      return ResponseEntity.error(message: e.toString());
    }
  }

  Future simulation(
    String type,
    Function(String?)? onData,
    Function()? onDone,
    Map<String, dynamic>? inputData,
  ) async {
    for (String key in inputData?.keys ?? []) {
      if (inputData![key] is Uint8List) {
        String filename = "$key.csv";
        FormData formData = FormData.fromMap({
          "file": MultipartFile.fromBytes(
            inputData[key] as Uint8List,
            filename: filename,
          ),
        });
        await simulationRepository.uploadInputFile(type, filename, formData);
        inputData[key] = filename;
      }
    }

    await simulationRepository.setInputDeck(type, inputData ?? {});
    simulationRepository.executions(type, onData, onDone);
  }

  Future<List<ChartData>> getChartData(
    String s3Path,
    List<String> fileNameList,
  ) async {
    try {
      final List<ChartData> chartValueList = [];
      for (String fileName in fileNameList) {
        final chartValue =
            await resultRepository.getChartData(s3Path, fileName);
        getPltContent(s3Path, fileNameList);
        chartValueList.add(chartValue);
      }
      return chartValueList;
    } on DioException catch (e) {
      throw ("DioException: $e");
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseEntity<List<StaticData>>> getStaticData(
    String s3Path,
    String fileName,
  ) async {
    try {
      final staticValue = await resultRepository.getStatics(s3Path, fileName);
      return ResponseEntity.success(entity: staticValue);
    } on DioException catch (e) {
      return ResponseEntity.error(message: e.message);
    } catch (e) {
      return ResponseEntity.error(message: e.toString());
    }
  }

  Future<void> getPltContent(String s3Path, List<String> fileNameList) async {
    if (pltFileList.isNotEmpty) pltFileList = [];
    for (String fileName in fileNameList) {
      final value = await resultRepository.getCSVContent(s3Path, fileName);
      pltFileList.add(value);
    }
  }

  List<String> getPltContent2() {
    return pltFileList;
  }

  // This function handles different file extensions to ensure proper processing based on the extension.
  // It divides the handling of files based on their extensions. For 'plt', it displays the chart;
  // for 'mp4', it shows the video viewer; and for 'pdf', it displays the PDF viewer.
  Future<ResponseEntity<List<OutputData>>> processFile(
    String s3Path,
    List<String> fileNameList,
  ) async {
    List<String> pltList = [];
    List<String> mp4List = [];
    List<String> pdfList = [];

    List<OutputData> outputList = [];

    for (String fileName in fileNameList) {
      String extension = getExtension(fileName);
      switch (extension) {
        case "plt":
          pltList.add(fileName);
          break;
        case "mp4":
          mp4List.add(fileName);
          break;
        case "pdf":
          pdfList.add(fileName);
          break;

        default:
          break;
      }
    }
    try {
      if (pltList.isNotEmpty) {
        List<OutputData> chartDataList = await getChartData(s3Path, pltList);
        outputList.addAll(chartDataList);
      }
      if (mp4List.isNotEmpty) {
        List<OutputData> mp4DataList = await getMP4Data(s3Path, mp4List);
        outputList.addAll(mp4DataList);
      }
      if (pdfList.isNotEmpty) {
        List<OutputData> pdfDataList = await getPDFData(s3Path, pdfList);
        outputList.addAll(pdfDataList);
      }
      return ResponseEntity.success(entity: outputList);
    } catch (e) {
      return ResponseEntity.error(message: e.toString());
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

  Future<List<MP4Data>> getMP4Data(String s3path, List<String> mp4list) async {
    List<MP4Data> mp4List = [];
    for (var e in mp4list) {
      mp4List.add(MP4Data(e, '${dotenv.get("S3_PATH")}/$s3path/$e'));
    }
    return mp4List;
  }

  Future<List<MP4Data>> getMP4DataStub(
      String s3path, List<String> mp4list) async {
    List<MP4Data> mp4List = [];
    for (var e in mp4list) {
      mp4List.add(MP4Data(e,
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4'));
    }
    return mp4List;
  }

  Future<List<PDFData>> getPDFData(String s3path, List<String> pdfList) async {
    List<PDFData> pdfDataList = [];
    for (var e in pdfList) {
      String fileName = '${dotenv.get("S3_PATH")}/$s3path/$e';
      final http.Response res = await http.get(Uri.parse(fileName));
      pdfDataList.add(PDFData(e, fileName, res.bodyBytes));
    }
    return pdfDataList;
  }

  Future<List<PDFData>> getPDFDataStub(
      String s3path, List<String> pdflist) async {
    List<PDFData> pdfList = [];
    for (var e in pdflist) {
      ByteData data = await rootBundle.load('assets/test/sample.pdf');
      List<int> bytes = data.buffer.asUint8List();
      pdfList.add(PDFData(
          e,
          'https://studyinthestates.dhs.gov/sites/default/files/Form%20I-20%20SAMPLE.pdf',
          bytes));
    }
    print(pdfList.length);
    return pdfList;
  }
}
