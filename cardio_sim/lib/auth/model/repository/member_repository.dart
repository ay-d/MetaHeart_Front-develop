import 'package:cardio_sim/auth/model/entity/user_entity.dart';
import 'package:cardio_sim/auth/model/repository/member_repository.stub.dart';
import 'package:cardio_sim/common/dio/dio.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'member_repository.g.dart';

final memberRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
 // return MemberRepositoryStub();
  return MemberRepository(dio);
});

@RestApi()
abstract class MemberRepository {
  factory MemberRepository(Dio dio, {String baseUrl}) = _MemberRepository;

  @GET('/user')
  @Headers({'accessToken' : 'true'})
  Future<UserEntity> getUserInfo();

  @PATCH('/auth')
  @Headers({'accessToken' : 'true'})
  Future setPayment();
}