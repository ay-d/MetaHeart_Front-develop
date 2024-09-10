// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_deck_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputDeckData _$InputDeckDataFromJson(Map<String, dynamic> json) =>
    InputDeckData(
      title: json['title'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => InputDeckItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InputDeckDataToJson(InputDeckData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'items': instance.items,
    };

InputDeckItemData _$InputDeckItemDataFromJson(Map<String, dynamic> json) =>
    InputDeckItemData(
      title: json['title'] as String?,
      type: InputDeckItemType.fromJson(json['type'] as String),
      data: (json['data'] as List<dynamic>?)
          ?.map(
              (e) => InputDeckItemDataData.fromJson(e as Map<String, dynamic>))
          .toList(),
      unit: json['unit'] as String?,
      name: json['name'] as String?,
      defaultValue: json['default'],
    );

Map<String, dynamic> _$InputDeckItemDataToJson(InputDeckItemData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': _$InputDeckItemTypeEnumMap[instance.type]!,
      'name': instance.name,
      'data': instance.data,
      'unit': instance.unit,
      'default': instance.defaultValue,
    };

const _$InputDeckItemTypeEnumMap = {
  InputDeckItemType.dropdown: 'dropdown',
  InputDeckItemType.number: 'number',
  InputDeckItemType.slider: 'slider',
  InputDeckItemType.file: 'file',
  InputDeckItemType.radio: 'radio',
  InputDeckItemType.text: 'text',
};

InputDeckItemDataData _$InputDeckItemDataDataFromJson(
        Map<String, dynamic> json) =>
    InputDeckItemDataData(
      json['title'] as String,
      json['value'] as String,
    );

Map<String, dynamic> _$InputDeckItemDataDataToJson(
        InputDeckItemDataData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'value': instance.value,
    };
