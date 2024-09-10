import 'package:json_annotation/json_annotation.dart';

part 'login_request_dto.g.dart';

@JsonSerializable()
class LoginRequestDto {
    String email;
    String password;

    LoginRequestDto({required this.email, required this.password});

    Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);

    factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
        _$LoginRequestDtoFromJson(json);
}