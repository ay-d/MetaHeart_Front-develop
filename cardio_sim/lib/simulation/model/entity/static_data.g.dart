// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'static_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaticData _$StaticDataFromJson(Map<String, dynamic> json) => StaticData(
      type: StaticDataType.fromJson(json['type'] as String),
      title: json['title'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$StaticDataToJson(StaticData instance) =>
    <String, dynamic>{
      'type': _$StaticDataTypeEnumMap[instance.type]!,
      'title': instance.title,
      'value': instance.value,
    };

const _$StaticDataTypeEnumMap = {
  StaticDataType.max: 'max',
  StaticDataType.min: 'min',
  StaticDataType.avg: 'avg',
};
