// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PDFData _$PDFDataFromJson(Map<String, dynamic> json) => PDFData(
      json['title'] as String,
      json['fileName'] as String,
      (json['fileContent'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$PDFDataToJson(PDFData instance) => <String, dynamic>{
      'title': instance.title,
      'fileName': instance.fileName,
      'fileContent': instance.fileContent,
    };
