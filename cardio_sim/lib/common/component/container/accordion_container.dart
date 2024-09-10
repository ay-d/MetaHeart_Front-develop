import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccordionContainer extends ConsumerStatefulWidget {
  final String title;
  late final ChangeNotifierProvider<AccordionController> provider;
  final List<Widget> children;

  final BoxDecoration? closedDecoration;
  final BoxDecoration? openDecoration;
  final Color? textColor;

  AccordionContainer({
    Key? key,
    required this.title,
    AccordionController? controller,
    this.textColor,
    this.openDecoration,
    this.closedDecoration,
    required this.children,
  }) : super(key: key) {
    controller ??= AccordionController();
    provider = ChangeNotifierProvider((ref) => controller!);
  }

  @override
  ConsumerState<AccordionContainer> createState() => _AccordionContainerState();
}

class _AccordionContainerState extends ConsumerState<AccordionContainer> {
  late AccordionController controller;

  @override
  Widget build(BuildContext context) {
    controller = ref.watch(widget.provider);
    BoxDecoration? decoration =
        controller.isOpen ? widget.openDecoration : widget.closedDecoration;
    return Container(
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            InkWell(
              onTap: controller.isOpen ? controller.close : controller.open,
              borderRadius: decoration?.borderRadius as BorderRadius?,
              child: Container(
                padding: EdgeInsets.all(kPaddingMiddleSize),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: kTextMainStyle.copyWith(
                          fontSize: kTextMiddleSize,
                          color: widget.textColor,
                        ),
                      ),
                    ),
                    Icon(
                      controller.isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: kIconMiddleSize,
                      color: widget.textColor,
                    ),
                  ],
                ),
              ),
            ),
            if (controller.isOpen)
              Container(
                padding: EdgeInsets.all(kPaddingMiddleSize),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.children,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AccordionController extends ChangeNotifier {
  late bool isOpen;
  final VoidCallback? onChange;

  AccordionController({bool initState = false, this.onChange}) {
    isOpen = initState;
  }

  void close() {
    isOpen = false;
    if (onChange != null) onChange!();
    notifyListeners();
  }

  void open() {
    isOpen = true;
    if (onChange != null) onChange!();
    notifyListeners();
  }
}
