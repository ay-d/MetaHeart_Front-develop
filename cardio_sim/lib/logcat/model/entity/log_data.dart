import 'package:json_annotation/json_annotation.dart';

part 'log_data.g.dart';

@JsonSerializable()
class LogData {
  String logName;
  List<String> outputName;

  LogData(this.logName, this.outputName);

  Map<String, dynamic> toJson() => _$LogDataToJson(this);

  factory LogData.fromJson(Map<String, dynamic> json) =>
      _$LogDataFromJson(json);
}
