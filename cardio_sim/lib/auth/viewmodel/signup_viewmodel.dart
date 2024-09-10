import 'package:cardio_sim/auth/model/service/auth_service.dart';
import 'package:cardio_sim/auth/model/state/auth_state.dart';
import 'package:cardio_sim/common/value_state/util/value_state_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signupViewModelProvider = Provider((ref) => SignupViewModel(ref));

class SignupViewModel {
  final Ref ref;
  late final AuthService _authService;

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final checkPasswordTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final affiliationTextController = TextEditingController();
  final positionTextController = TextEditingController();

  final signupKey = GlobalKey<FormState>();
  final AuthState authState = AuthState();

  SignupViewModel(this.ref) {
    _authService = ref.read(authServiceProvider);
  }

  bool signup() {
    if (!(signupKey.currentState?.validate() ?? false)) return false;
    if (passwordTextController.text != checkPasswordTextController.text) return false;
    authState.withResponse(_authService.signup(
      email: emailTextController.text,
      password: passwordTextController.text,
      name: nameTextController.text,
      affiliation: affiliationTextController.text,
      position: positionTextController.text,
    ));
    return true;
  }
}
