import 'package:cardio_sim/auth/model/entity/user_entity.dart';
import 'package:cardio_sim/common/value_state/state/value_state.dart';

class MemberState extends ValueStateNotifier<UserEntity> {
  static MemberState? _instance;

  MemberState._();

  factory MemberState() => _instance ??= MemberState._();
}
