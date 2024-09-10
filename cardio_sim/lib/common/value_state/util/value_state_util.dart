import 'package:cardio_sim/common/entity/response_entity.dart';
import 'package:cardio_sim/common/value_state/state/value_state.dart';
import 'package:flutter/material.dart';

extension ValueStateWithResponse<T> on ValueStateNotifier<T> {
  void withResponse(Future<ResponseEntity<T>> response) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loading();
      response.then((value) {
        if (value.isSuccess) {
          if (value.entity == null) return none(message: value.message);
          success(value: value.entity, message: value.message);
        } else {
          error(value: value.entity, message: value.message);
        }
      });
    });
  }
}
