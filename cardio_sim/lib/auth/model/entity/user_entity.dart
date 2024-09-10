import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity {
  final String email;
  final String name;
  final bool isAble;
  final String affiliation;
  final String position;
  final String s3Path;

  UserEntity({
    required this.email,
    required this.name,
    required this.isAble,
    required this.affiliation,
    required this.position,
    required this.s3Path,
  });

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
