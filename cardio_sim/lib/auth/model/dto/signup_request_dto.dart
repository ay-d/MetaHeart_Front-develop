import 'package:json_annotation/json_annotation.dart';

part 'signup_request_dto.g.dart';

@JsonSerializable()
class SignupRequestDto {
  String email;
  String password;
  String name;
  String affiliation;
  String position;

  SignupRequestDto({
    required this.email,
    required this.password,
    required this.name,
    required this.affiliation,
    required this.position,
  });

  Map<String, dynamic> toJson() => _$SignupRequestDtoToJson(this);

  factory SignupRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestDtoFromJson(json);
}
