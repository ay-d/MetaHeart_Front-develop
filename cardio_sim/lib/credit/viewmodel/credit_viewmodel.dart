import 'package:cardio_sim/auth/model/service/member_service.dart';
import 'package:cardio_sim/auth/model/state/member_state.dart';
import 'package:cardio_sim/common/value_state/util/value_state_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final creditViewModelProvider = Provider((ref) => CreditViewModel(ref));

class CreditViewModel {
  Ref ref;

  late final MemberService _memberService;
  final MemberState _memberState = MemberState();

  final creditCardFormKey = GlobalKey<FormState>();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';

  CreditViewModel(this.ref) {
    _memberService = ref.read(memberServiceProvider);
  }

  void setPayment() {
    _memberState.withResponse(_memberService.setPayment());
  }
}