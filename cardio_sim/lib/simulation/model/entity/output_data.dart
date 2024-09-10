import 'package:json_annotation/json_annotation.dart';

part 'output_data.g.dart';

@JsonSerializable()
class OutputData {
  String title;
  OutputData({
    required this.title,
  });

  Map<String, dynamic> toJson() => _$OutputDataToJson(this);

  factory OutputData.fromJson(Map<String, dynamic> json) =>
      _$OutputDataFromJson(json);
}