import 'package:cardio_sim/common/value_state/component/default/value_state_none_widget.dart';
import 'package:cardio_sim/common/value_state/state/value_state.dart';
import 'package:flutter/material.dart';

import 'default/value_state_error_widget.dart';
import 'default/value_state_loading_widget.dart';
import 'value_state_notifier_widget.dart';

typedef ValueStateListenerBuilder<T> = Widget Function(
  BuildContext context,
  ValueStateNotifier<T> state,
);

class ValueStateListener<T> extends StatefulWidget
    implements ValueStateNotifierWidget {
  @override
  final ValueStateNotifier<T> state;

  final ValueStateListenerBuilder<T>? defaultBuilder;
  final ValueStateListenerBuilder<T>? noneBuilder;
  final ValueStateListenerBuilder<T>? loadingBuilder;
  final ValueStateListenerBuilder<T>? successBuilder;
  final ValueStateListenerBuilder<T>? errorBuilder;

  const ValueStateListener({
    Key? key,
    required this.state,
    this.defaultBuilder,
    this.noneBuilder,
    this.loadingBuilder,
    this.successBuilder,
    this.errorBuilder,
  }) : super(key: key);

  @override
  State<ValueStateListener> createState() => _ValueStateListenerState<T>();
}

class _ValueStateListenerState<T> extends State<ValueStateListener<T>> {
  @override
  Widget build(BuildContext context) {
    if (widget.state.isSuccess) {
      return stateOrDefault(widget.successBuilder) ??
          ValueStateNoneWidget(widget.state);
    }
    if (widget.state.isLoading) {
      return stateOrDefault(widget.loadingBuilder) ??
          ValueStateLoadingWidget(widget.state);
    }
    if (widget.state.isError) {
      return stateOrDefault(widget.errorBuilder) ??
          ValueStateErrorWidget(widget.state);
    }
    return stateOrDefault(widget.noneBuilder) ??
        ValueStateNoneWidget(widget.state);
  }

  @override
  void initState() {
    widget.state.addListener(_setState);
    super.initState();
  }

  @override
  void dispose() {
    widget.state.removeListener(_setState);
    super.dispose();
  }

  Widget? stateOrDefault(ValueStateListenerBuilder<T>? builder) {
    return builder?.call(context, widget.state) ??
        widget.defaultBuilder?.call(context, widget.state);
  }

  void _setState() => setState(() {});
}
