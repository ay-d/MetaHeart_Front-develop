import 'package:cardio_sim/auth/model/dto/login_request_dto.dart';
import 'package:cardio_sim/auth/model/dto/signup_request_dto.dart';
import 'package:cardio_sim/auth/model/repository/auth_repository.dart';
import 'package:cardio_sim/auth/model/repository/member_repository.dart';
import 'package:cardio_sim/common/entity/response_entity.dart';
import 'package:cardio_sim/common/local_storage/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final memberRepository = ref.watch(memberRepositoryProvider);
  final storage = ref.watch(localStorageProvider);
  return AuthService(authRepository, memberRepository, storage);
});

class AuthService {
  final AuthRepository authRepository;
  final MemberRepository memberRepository;
  final LocalStorage storage;

  AuthService(this.authRepository, this.memberRepository, this.storage);

  Future<ResponseEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      await authRepository.login(
        LoginRequestDto(email: email, password: password),
      );
      return ResponseEntity.success(entity: true);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return ResponseEntity.error(message: "존재하지 않는 사용자 입니다.");
      }
      if (e.response?.statusCode == 401) {
        return ResponseEntity.error(message: "비밀번호가 틀렸습니다.");
      }
      if (e.response?.statusCode == 200) {
        return ResponseEntity.error(message: e.message ?? "알 수 없는 에러가 발생했습니다.");
      }
      return ResponseEntity.error(message: "서버와 연결할 수 없습니다.");
    } catch (e) {
      return ResponseEntity.error(message: "알 수 없는 에러가 발생했습니다.");
    }
  }

  Future<ResponseEntity> signup({
    required String email,
    required String password,
    required String name,
    required String affiliation,
    required String position,
  }) async {
    SignupRequestDto dto = SignupRequestDto(
      email: email,
      password: password,
      name: name,
      affiliation: affiliation,
      position: position,
    );
    try {
      await authRepository.signup(dto);
      return ResponseEntity.success(message: "회원가입에 성공하였습니다.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return ResponseEntity.error(message: "회원가입에 실패하였습니다.");
      }
      if (e.response?.statusCode == 409) {
        return ResponseEntity.error(message: "이미 가입된 이메일입니다");
      }
      return ResponseEntity.error(message: "서버와 연결할 수 없습니다.");
    } catch (e) {
      return ResponseEntity.error(message: "알 수 없는 에러가 발생했습니다.");
    }
  }

  Future<ResponseEntity> logout() async {
    try {
      await _removeToken();
      return ResponseEntity.success();
    } catch (e) {
      return ResponseEntity.error(message: "로그아웃에 실패하였습니다.");
    }
  }

  Future _removeToken() async {
    Future.wait([
      storage.delete(key: dotenv.get('ACCESS_TOKEN_KEY')),
      storage.delete(key: dotenv.get('REFRESH_TOKEN_KEY')),
    ]);
  }

  Future<ResponseEntity> checkToken() async {
    final accessToken = await storage.read(key: dotenv.get('ACCESS_TOKEN_KEY'));
    final refreshToken = await storage.read(
      key: dotenv.get('REFRESH_TOKEN_KEY'),
    );

    if (accessToken == null || refreshToken == null) {
      return ResponseEntity.error();
    }

    try {
      await authRepository.checkToken();
      return ResponseEntity.success(entity: true);
    } catch (e) {
      return ResponseEntity.error(message: "토큰 정보가 만료되었습니다.");
    }
  }
}
