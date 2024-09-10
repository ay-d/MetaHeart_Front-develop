import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/value_state/state/value_state.dart';
import 'package:flutter/material.dart';

import '../value_state_notifier_widget.dart';

class ValueStateLoadingWidget<T> extends StatelessWidget
    implements ValueStateNotifierWidget {
  @override
  final ValueStateNotifier<T> state;

  ValueStateLoadingWidget(this.state, {Key? key})
      : assert(state.isLoading),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: kMainColor,
      ),
    );
  }
}
