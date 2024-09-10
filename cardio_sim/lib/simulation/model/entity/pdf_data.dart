import 'package:cardio_sim/simulation/model/entity/output_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pdf_data.g.dart';

@JsonSerializable()
class PDFData extends OutputData {
  @override
  String title;
  String fileName;
  List<int> fileContent;

  PDFData(this.title, this.fileName, this.fileContent) : super(title: title);

  @override
  Map<String, dynamic> toJson() => _$PDFDataToJson(this);

  factory PDFData.fromJson(Map<String, dynamic> json) =>
      _$PDFDataFromJson(json);
}