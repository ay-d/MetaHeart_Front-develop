import 'package:cardio_sim/common/component/container/accordion_container.dart';

class InputDeckContainer extends AccordionContainer {
  InputDeckContainer({
    super.key,
    required super.title,
    required super.controller,
    super.closedDecoration,
    super.openDecoration,
    required super.children,
  });
}
