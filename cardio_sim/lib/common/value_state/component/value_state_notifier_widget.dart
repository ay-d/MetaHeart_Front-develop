import 'package:flutter/material.dart';

import '../state/value_state.dart';

abstract class ValueStateNotifierWidget<T> extends Widget {
  final ValueStateNotifier<T> state;

  const ValueStateNotifierWidget(this.state, {super.key});
}
