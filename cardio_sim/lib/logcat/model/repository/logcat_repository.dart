import 'package:cardio_sim/common/dio/dio.dart';
import 'package:cardio_sim/logcat/model/entity/log_data.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

part 'logcat_repository.g.dart';

final logcatRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  //return logcatRepositoryStub();
  return LogcatRepository(dio);
});

@RestApi()
abstract class LogcatRepository {
  factory LogcatRepository(Dio dio, {String baseUrl}) =
  _LogcatRepository;

  @GET('/user/logcat')
  @Headers({'accessToken': 'true'})
  Future<List<LogData>> getLogData();
}
