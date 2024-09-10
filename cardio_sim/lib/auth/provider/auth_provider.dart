import 'package:cardio_sim/auth/model/service/auth_service.dart';
import 'package:cardio_sim/auth/model/service/member_service.dart';
import 'package:cardio_sim/auth/model/state/auth_state.dart';
import 'package:cardio_sim/auth/model/state/member_state.dart';
import 'package:cardio_sim/common/value_state/util/value_state_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = Provider<AuthProvider>((ref) => AuthProvider(ref: ref));

class AuthProvider {
  final Ref ref;

  late AuthService _authService;
  late MemberService _memberService;

  AuthState authState = AuthState();
  MemberState memberState = MemberState();

  AuthProvider({required this.ref}) {
    _authService = ref.read(authServiceProvider);
    _memberService = ref.read(memberServiceProvider);

    authState.addListener(() {
      if (authState.isSuccess && !memberState.isSuccess) {
        return memberState.withResponse(_memberService.getUserInfo());
      }
      memberState.none();
    });

    // TODO : 토큰 정보 확인 중 splash view가 출력되도록 수정

    authState.withResponse(_authService.checkToken());
  }

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final isLoginScreen = state.location.contains('/auth');
    final isCreditScreen = state.location.contains('/credit');

    if (memberState.isNone) {
      return isLoginScreen ? null : '/auth';
    }

    if (memberState.isSuccess) {
      if (memberState.value?.isAble == true) {
        return isLoginScreen || state.location == '/splash' ? '/' : null;
      }
      return isCreditScreen ? null : '/auth/credit';
    }

    if (memberState.isError) {
      return !isLoginScreen ? '/auth' : null;
    }

    return null;
  }

  void logout() => authState.withResponse(_authService.logout());
}
