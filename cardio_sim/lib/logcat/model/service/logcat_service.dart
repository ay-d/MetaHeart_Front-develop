import 'package:cardio_sim/logcat/model/entity/log_data.dart';
import 'package:cardio_sim/logcat/model/repository/logcat_repository.dart';
import 'package:cardio_sim/common/entity/response_entity.dart';
import 'package:cardio_sim/common/local_storage/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logcatServiceProvider = Provider((ref) {
  final logcatRepository = ref.watch(logcatRepositoryProvider);
  final storage = ref.watch(localStorageProvider);
  return LogcatService(logcatRepository, storage);
});

class LogcatService {
  final LogcatRepository logcatRepository;

  //TODO: storage 필요성 검토
  final LocalStorage storage;

  LogcatService(this.logcatRepository, this.storage);

  Future<ResponseEntity<List<LogData>>> getLogData() async {
    try {
      List<LogData> entity = await logcatRepository.getLogData();
      return ResponseEntity.success(entity: entity);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return ResponseEntity.error(message: "400");
      }
      if (e.response?.statusCode == 401) {
        return ResponseEntity.error(message: "401");
      }
      if (e.response?.statusCode == 200) {
        return ResponseEntity.error(message: e.message ?? "알 수 없는 에러가 발생했습니다.");
      }
      return ResponseEntity.error(message: "서버와 연결할 수 없습니다.");
    } catch (e) {
      return ResponseEntity.error(message: "알 수 없는 에러가 발생했습니다.");
    }
  }
}
