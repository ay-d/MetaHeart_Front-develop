// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartData _$ChartDataFromJson(Map<String, dynamic> json) => ChartData(
      json['title'] as String,
      json['x'] as String,
      (json['xList'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      (json['data'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, (e as List<dynamic>).map((e) => (e as num).toDouble()).toList()),
      ),
    );

Map<String, dynamic> _$ChartDataToJson(ChartData instance) => <String, dynamic>{
      'title': instance.title,
      'x': instance.x,
      'xList': instance.xList,
      'data': instance.data,
    };
