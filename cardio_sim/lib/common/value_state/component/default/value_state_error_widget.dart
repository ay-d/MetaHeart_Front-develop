import 'package:cardio_sim/common/value_state/state/value_state.dart';
import 'package:flutter/material.dart';

import '../value_state_notifier_widget.dart';

class ValueStateErrorWidget<T> extends StatelessWidget
    implements ValueStateNotifierWidget {
  @override
  final ValueStateNotifier<T> state;

  ValueStateErrorWidget(this.state, {Key? key})
      : assert(state.isError),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
