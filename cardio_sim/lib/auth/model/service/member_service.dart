import 'package:cardio_sim/auth/model/entity/user_entity.dart';
import 'package:cardio_sim/auth/model/repository/member_repository.dart';
import 'package:cardio_sim/common/entity/response_entity.dart';
import 'package:cardio_sim/common/local_storage/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final memberServiceProvider = Provider((ref) {
  final memberRepository = ref.read(memberRepositoryProvider);
  return MemberService(memberRepository);
});

class MemberService {
  final MemberRepository memberRepository;
  final LocalStorage storage = LocalStorage();
  MemberService(this.memberRepository);

  Future<ResponseEntity<UserEntity>> getUserInfo() async {
    try {
      final value = await memberRepository.getUserInfo();
      await storage.write(key: "userId", value: value.name);
      return ResponseEntity.success(entity: value);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        return ResponseEntity.error(
          message: e.response!.data["message"][0] ?? "알 수 없는 에러가 발생했습니다.",
        );
      }
      return ResponseEntity.error(message: "사용자 정보를 가져올 수 없습니다.");
    } catch (e) {
      return ResponseEntity.error(message: "알 수 없는 에러가 발생했습니다.");
    }
  }

  Future<ResponseEntity<UserEntity>> setPayment() async {
    try {
      await memberRepository.setPayment();
      return getUserInfo();
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        return ResponseEntity.error(
          message: e.response!.data["message"][0] ?? "알 수 없는 에러가 발생했습니다.",
        );
      }
      return ResponseEntity.error(message: "결제 정보 등록에 실패하였습니다.");
    } catch (e) {
      return ResponseEntity.error(message: "알 수 없는 에러가 발생했습니다.");
    }
  }
}
