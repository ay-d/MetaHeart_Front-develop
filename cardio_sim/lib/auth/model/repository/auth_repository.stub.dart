import 'package:cardio_sim/auth/model/dto/login_request_dto.dart';
import 'package:cardio_sim/auth/model/dto/signup_request_dto.dart';
import 'package:cardio_sim/auth/model/repository/auth_repository.dart';
import 'package:cardio_sim/common/local_storage/local_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRepositoryStub implements AuthRepository {
  final LocalStorage storage = LocalStorage();
  final String accessToken = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFrZmxka3NrZ29ybkBnbWFpbC5jb20iLCJzdWIiOiI1NjY1ZTE0MS01MTRlLTQ5YzYtYjk4Mi02NGE3ZDdkMmY2NDQiLCJpYXQiOjE3MDM1OTkwMjcsImV4cCI6MTcwMzY4NTQyN30.E7cggxnF9nInbcHYWR5MorLf_0n6GeilE3vEoqeWnX0";
  final String refreshToken = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFrZmxka3NrZ29ybkBnbWFpbC5jb20iLCJzdWIiOiI1NjY1ZTE0MS01MTRlLTQ5YzYtYjk4Mi02NGE3ZDdkMmY2NDQiLCJpYXQiOjE3MDM1OTkwMjcsImV4cCI6MTcwMzU5OTc0N30.YVpUIpbhswZ5ofLDU3zDNyqY20CYN9sQuubAwglk8xY";

  @override
  Future login(LoginRequestDto loginRequestDto) async {
    Future.wait([
      storage.write(
        key: dotenv.get('ACCESS_TOKEN_KEY'),
        value: accessToken.replaceFirst("Bearer ", ""),
      ),
      storage.write(
        key: dotenv.get('REFRESH_TOKEN_KEY'),
        value: refreshToken.replaceFirst("Bearer ", ""),
      ),
    ]);
  }

  @override
  Future signup(SignupRequestDto dto) async {}

  @override
  Future checkToken() async {}
}
