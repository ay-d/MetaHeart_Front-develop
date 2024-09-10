import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'static_data.g.dart';

@JsonSerializable()
class StaticData {
  StaticDataType type;
  String title;
  double value;

  StaticData({
    required this.type,
    required this.title,
    required this.value,
  });

  Map<String, dynamic> toJson() => _$StaticDataToJson(this);

  factory StaticData.fromJson(Map<String, dynamic> json) =>
      _$StaticDataFromJson(json);
}

enum StaticDataType {
  max("Max"),
  min("Min"),
  avg("Avg");

  factory StaticDataType.fromJson(String value) =>
      StaticDataType.values
          .firstWhereOrNull((element) => element.value == value) ??
      StaticDataType.max;

  final String value;

  const StaticDataType(this.value);

  @override
  String toString() => value;
}
