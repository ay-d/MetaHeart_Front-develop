import 'package:cardio_sim/auth/model/entity/user_entity.dart';
import 'package:cardio_sim/auth/model/repository/member_repository.dart';

class MemberRepositoryStub implements MemberRepository {
  UserEntity user = UserEntity(
    email: "email",
    name: "name",
    isAble: true,
    affiliation: "affiliation",
    position: "position",
    s3Path: "s3Path"
  );

  @override
  Future<UserEntity> getUserInfo() async {
    return user;
  }

  @override
  Future setPayment() async {
    user = UserEntity(
      email: "email",
      name: "name",
      isAble: true,
      affiliation: "affiliation",
      position: "position",
      s3Path: "s3Path",
    );
  }
}
