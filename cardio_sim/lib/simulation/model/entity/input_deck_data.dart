import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'input_deck_data.g.dart';

@JsonSerializable()
class InputDeckData {
  String title;
  List<InputDeckItemData> items;

  InputDeckData({required this.title, required this.items});

  Map<String, dynamic> toJson() => _$InputDeckDataToJson(this);

  factory InputDeckData.fromJson(Map<String, dynamic> json) =>
      _$InputDeckDataFromJson(json);
}

@JsonSerializable()
class InputDeckItemData {
  String? title;
  InputDeckItemType type;
  String? name;
  List<InputDeckItemDataData>? data;
  String? unit;
  @JsonKey(name: 'default')
  Object? defaultValue;

  InputDeckItemData({
    this.title,
    required this.type,
    this.data,
    this.unit,
    this.name,
    this.defaultValue,
  }) : assert(type == InputDeckItemType.dropdown ? data != null : true);

  Map<String, dynamic> toJson() => _$InputDeckItemDataToJson(this);

  factory InputDeckItemData.fromJson(Map<String, dynamic> json) =>
      _$InputDeckItemDataFromJson(json);
}

enum InputDeckItemType {
  dropdown('dropdown'),
  number('number'),
  slider('slider'),
  file('file'),
  radio('radio'),
  text('text');

  final String value;

  const InputDeckItemType(this.value);

  factory InputDeckItemType.fromJson(String value) =>
      InputDeckItemType.values
          .firstWhereOrNull((element) => element.value == value) ??
      InputDeckItemType.number;

  @override
  String toString() => value;
}

@JsonSerializable()
class InputDeckItemDataData {
  String title;
  String value;

  InputDeckItemDataData(this.title, this.value);

  Map<String, dynamic> toJson() => _$InputDeckItemDataDataToJson(this);

  factory InputDeckItemDataData.fromJson(Map<String, dynamic> json) =>
      _$InputDeckItemDataDataFromJson(json);

  @override
  String toString() => title;
}
