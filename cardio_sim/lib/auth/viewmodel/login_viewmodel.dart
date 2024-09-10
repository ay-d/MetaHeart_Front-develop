import 'package:cardio_sim/auth/model/service/auth_service.dart';
import 'package:cardio_sim/auth/model/state/auth_state.dart';
import 'package:cardio_sim/common/value_state/util/value_state_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewModelProvider = Provider((ref) => LoginViewModel(ref));

class LoginViewModel {
  final Ref ref;
  late final AuthService _authService;

  final AuthState authState = AuthState();

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final loginKey = GlobalKey<FormState>();

  LoginViewModel(this.ref) {
    _authService = ref.read(authServiceProvider);
  }

  Future login() async {
    if (!(loginKey.currentState?.validate() ?? false)) return;
    authState.withResponse(_authService.login(
      email: emailTextController.text,
      password: passwordTextController.text,
    ));
  }
}
