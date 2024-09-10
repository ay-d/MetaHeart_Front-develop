import 'package:flutter/material.dart';

class PulseViewer extends StatefulWidget {
  final String path;
  final PulseViewerController controller;
  final double? height;

  const PulseViewer({
    super.key,
    this.path = "",
    required this.controller,
    this.height,
  });

  @override
  State<PulseViewer> createState() => _PulseViewerState();
}

class _PulseViewerState extends State<PulseViewer> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "${widget.path}/${widget.controller.value}",
      height: widget.height,
    );
  }
}

class PulseViewerController<T> extends ValueNotifier<PulseType> {
  ValueNotifier<T>? notifier;

  PulseViewerController(super.value);

  void setNotifier(
    ValueNotifier<T> notifier,
    PulseType Function(T value) mapper,
  ) {
    notifier.addListener(() {
      value = mapper(notifier.value);
      notifyListeners();
    });
    this.notifier = notifier;
    notifyListeners();
  }
}

enum PulseType {
  single("single_pulse.png"),
  double("double_pulse.png"),
  triple("triple_pulse.png");

  final String value;

  const PulseType(this.value);

  @override
  String toString() => value;
}
