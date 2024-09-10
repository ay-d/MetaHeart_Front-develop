import 'package:cardio_sim/common/value_state/state/value_state.dart';

class AuthState extends ValueStateNotifier {
  static AuthState? _instance;

  AuthState._();

  factory AuthState() => _instance ??= AuthState._();
}
