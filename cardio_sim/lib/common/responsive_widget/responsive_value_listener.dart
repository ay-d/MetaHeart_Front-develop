import 'package:cardio_sim/common/responsive_widget/util/responsive_container_util.dart';
import 'package:flutter/material.dart';

typedef ResponsiveChangeListenerBuilder<T extends ChangeNotifier> = Widget
    Function(
  BuildContext context,
  T notifier,
  Widget? child,
);

class ResponsiveChangeListener<T extends ChangeNotifier>
    extends StatefulWidget {
  final T notifier;
  final ResponsiveChangeListenerBuilder<T> builder;
  final Widget? child;
  final bool reverse;

  const ResponsiveChangeListener({
    Key? key,
    required this.notifier,
    required this.builder,
    this.child,
    this.reverse = false,
  }) : super(key: key);

  @override
  State<ResponsiveChangeListener<T>> createState() =>
      _ResponsiveChangeListenerState();
}

class _ResponsiveChangeListenerState<T extends ChangeNotifier>
    extends State<ResponsiveChangeListener<T>> {
  @override
  Widget build(BuildContext context) {
    return convert(
      widget.builder(context, widget.notifier, widget.child),
      widget.reverse,
    );
  }

  void _setState() => setState(() {});

  @override
  void initState() {
    super.initState();
    widget.notifier.addListener(_setState);
  }

  @override
  void dispose() {
    super.dispose();
    widget.notifier.removeListener(_setState);
  }
}
