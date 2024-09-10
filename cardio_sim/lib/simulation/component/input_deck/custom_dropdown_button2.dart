import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:cardio_sim/simulation/component/input_deck/custom_dropdown_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDropdownButton2<T> extends ConsumerWidget {
  late final ChangeNotifierProvider<CustomDropdownButtonController<T>>
      _controller;
  late final TextStyle textStyle;
  final IconData action;
  final double itemHeight;
  final BoxDecoration? decoration;
  final String? headText;

  CustomDropdownButton2(
    CustomDropdownButtonController<T> controller, {
    Key? key,
    this.headText,
    this.itemHeight = 48.0,
    this.decoration,
    TextStyle? textStyle,
    this.action = Icons.arrow_drop_down,
  }) : super(key: key) {
    _controller = ChangeNotifierProvider((ref) => controller);
    this.textStyle =
        textStyle ?? kTextMainStyle.copyWith(fontSize: kTextMiddleSize);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(_controller);
    return Row(
      children: [
        if (headText != null)
          Row(
            children: [
              Text(
                headText!,
                style: textStyle.copyWith(color: kTextReverseColor),
              ),
              SizedBox(width: kPaddingSmallSize),
            ],
          ),
        Expanded(
          child: DropdownButton2<T>(
            isExpanded: true,
            iconStyleData:
                IconStyleData(icon: Icon(action, size: kIconMiddleSize)),
            menuItemStyleData: MenuItemStyleData(
              height: itemHeight,
              padding: EdgeInsets.symmetric(horizontal: kPaddingSmallSize),
            ),
            buttonStyleData: ButtonStyleData(decoration: decoration),
            underline: const SizedBox.shrink(),
            items: controller.items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.toString(), style: textStyle),
                  ),
                )
                .toList(),
            onChanged: controller.onChanged,
            value: controller.value,
          ),
        )
      ],
    );
  }
}
