import 'package:cardio_sim/auth/model/dto/login_request_dto.dart';
import 'package:cardio_sim/auth/model/dto/signup_request_dto.dart';
import 'package:cardio_sim/auth/model/repository/auth_repository.stub.dart';
import 'package:cardio_sim/common/dio/dio.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_repository.g.dart';

final authRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
 // return AuthRepositoryStub();
  return AuthRepository(dio);
});

@RestApi()
abstract class AuthRepository {
  factory AuthRepository(Dio dio, {String baseUrl}) = _AuthRepository;

  @POST('/auth')
  Future login(@Body() LoginRequestDto dto);

  @POST('/auth/signup')
  Future signup(@Body() SignupRequestDto dto);

  @GET('/auth/token')
  @Headers({'accessToken' : 'true'})
  Future checkToken();
}
