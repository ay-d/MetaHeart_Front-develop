import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDropdownButton<T> extends ConsumerWidget {
  late final ChangeNotifierProvider<CustomDropdownButtonController<T>>
      _controller;
  final Color buttonColor;
  final Color boarderColor;
  late final TextStyle textStyle;
  final IconData? leading;
  final IconData? action;
  final double itemHeight;

  CustomDropdownButton(
    CustomDropdownButtonController<T> controller, {
    Key? key,
    this.itemHeight = 48.0,
    this.buttonColor = kBackgroundMainColor,
    this.boarderColor = kBackgroundMainColor,
    TextStyle? textStyle,
    this.leading,
    this.action = Icons.arrow_drop_down,
  }) : super(key: key) {
    _controller = ChangeNotifierProvider((ref) => controller);
    this.textStyle =
        textStyle ?? kTextMainStyle.copyWith(fontSize: kTextMiddleSize);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(_controller);
    return DropdownButton<T>(
      itemHeight: itemHeight,
      isExpanded: true,
      dropdownColor: buttonColor,
      icon: const SizedBox.shrink(),
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
      selectedItemBuilder: (context) => controller.items
          .map((e) => CustomDropdownButtonItem(
                e.toString(),
                buttonColor: buttonColor,
                boarderColor: boarderColor,
                textStyle: textStyle,
                leading: leading,
                action: action,
                itemHeight: itemHeight,
              ))
          .toList(),
    );
  }
}

class CustomDropdownButtonItem extends StatelessWidget {
  final Color buttonColor;
  final Color boarderColor;
  late final TextStyle textStyle;
  final IconData? leading;
  final IconData? action;
  final double itemHeight;
  final String text;

  CustomDropdownButtonItem(
    this.text, {
    Key? key,
    this.buttonColor = kBackgroundMainColor,
    this.boarderColor = kBackgroundMainColor,
    TextStyle? textStyle,
    this.itemHeight = 48.0,
    this.leading,
    this.action,
  }) : super(key: key) {
    this.textStyle =
        textStyle ?? kTextMainStyle.copyWith(fontSize: kTextMiddleSize);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: itemHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadiusSize),
        border: Border.all(color: boarderColor, width: 3.0),
        color: buttonColor,
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            Icon(leading, color: textStyle.color, size: kIconMiddleSize),
            SizedBox(width: kPaddingSmallSize),
          ],
          Expanded(child: Text(text, style: textStyle)),
          SizedBox(width: kPaddingSmallSize),
          if (action != null)
            Icon(action, color: textStyle.color, size: kIconMiddleSize),
        ],
      ),
    );
  }
}

class CustomDropdownButtonController<T> extends ValueNotifier<T> {
  List<T> _items;

  List<T> get items => _items;

  set items(List<T> items) {
    _items = items;
    _value = _items[0];
    notifyListeners();
  }

  late final void Function(T? value) onChanged;

  late T _value;

  @override
  T get value => _value;

  CustomDropdownButtonController(
    this._items, {
    int initIndex = 0,
    Function(T value)? onChanged,
  })  : assert(initIndex < _items.length && initIndex >= 0),
        super(_items[0]) {
    _value = _items[initIndex];
    this.onChanged = (T? value) {
      if (value == null) return;
      _value = value;
      notifyListeners();
      if (onChanged != null) onChanged(value);
    };
  }
}
