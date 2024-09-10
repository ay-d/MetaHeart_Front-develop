// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogData _$LogDataFromJson(Map<String, dynamic> json) => LogData(
      json['logName'] as String,
      (json['outputName'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$LogDataToJson(LogData instance) => <String, dynamic>{
      'logName': instance.logName,
      'outputName': instance.outputName,
    };
