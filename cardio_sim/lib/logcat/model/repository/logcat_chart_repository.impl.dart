import 'package:cardio_sim/common/utils/file_utils.dart';
import 'package:cardio_sim/logcat/model/repository/logcat_chart_repository.dart';
import 'package:cardio_sim/simulation/model/entity/chart_data.dart';
import 'package:cardio_sim/simulation/model/entity/input_deck_data.dart';
import 'package:cardio_sim/simulation/model/entity/static_data.dart';

class LogcatChartRepositoryImpl extends LogcatChartRepository {
  @override
  Future<ChartData> getChartData() async {
    String? data = await FileUtil.getFile(['plt']);
    if (data == null) throw Exception("파일을 읽을 수 없습니다.");
    return ChartData.fromPlt('logcat', data!);
  }

  @override
  Future<List<InputDeckData>> getInputDeck() async {
    String? data = await FileUtil.getFile(['log']);

    if (data == null) throw Exception("파일을 읽을 수 없습니다.");


    List<String> rawList = data!.split("\n");
    int currentIndex = 8;
    String current = rawList[currentIndex];

    InputDeckData result = InputDeckData(title: "inputDeck", items: []);

    while (current.contains('--')) {
      List<String> inputs = current.split(" -- ");
      try {
        result.items.add(
          InputDeckItemData(
            title: inputs[0],
            type: InputDeckItemType.number,
            defaultValue: double.parse(inputs[1]),
          ),
        );
      } catch (e) {
        result.items.add(
          InputDeckItemData(
            type: InputDeckItemType.dropdown,
            defaultValue: inputs[1],
            data: [InputDeckItemDataData(inputs[1], inputs[1])],
            title: inputs[0],
          ),
        );
      }
      current = rawList[++currentIndex];
    }

    return [result];
  }

  @override
  Future<List<StaticData>> getStatics() async {
    return [];
  }
}
