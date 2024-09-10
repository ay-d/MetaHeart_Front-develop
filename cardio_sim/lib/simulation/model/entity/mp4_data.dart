import 'package:cardio_sim/simulation/model/entity/output_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mp4_data.g.dart';

@JsonSerializable()
class MP4Data extends OutputData {
  @override
  String title;
  String fileName;

  MP4Data(this.title, this.fileName) : super(title: title);

  @override
  Map<String, dynamic> toJson() => _$MP4DataToJson(this);

  factory MP4Data.fromJson(Map<String, dynamic> json) =>
      _$MP4DataFromJson(json);
}
