import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RadioButton<T> extends ConsumerWidget {
  late final ChangeNotifierProvider<RadioButtonController<T>> _controller;
  final String title;
  late final TextStyle textStyle;
  final double itemHeight;
  final BoxDecoration? decoration;

  RadioButton(
    RadioButtonController<T> controller, {
    Key? key,
    required this.title,
    this.itemHeight = 48.0,
    this.decoration,
    TextStyle? textStyle,
  }) : super(key: key) {
    _controller = ChangeNotifierProvider((ref) => controller);
    this.textStyle =
        textStyle ?? kTextMainStyle.copyWith(fontSize: kTextMiddleSize);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(_controller);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textStyle),
        ...controller.items
            .map(
              (e) => InkWell(
                onTap: () => controller.onChanged(e),
                child: SizedBox(
                  height: itemHeight,
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: itemHeight / 48,
                        child: Radio<T>(
                          value: e,
                          groupValue: controller.value,
                          onChanged: null,
                          fillColor: MaterialStateProperty.resolveWith(
                                (_) => textStyle.color,
                          ),
                          visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity,
                          ),
                          splashRadius: 0.0,
                        ),
                      ),
                      SizedBox(width: kPaddingSmallSize),
                      Text(e.toString(), style: textStyle),
                    ],
                  ),
                ),/*ListTile(
                  contentPadding: const EdgeInsets.all(0.0),
                  horizontalTitleGap: kPaddingMiddleSize,
                  minVerticalPadding: 0.0,
                  dense: true,
                  leading: Transform.scale(
                    scale: itemHeight / 36,
                    child: Radio<T>(
                      value: e,
                      groupValue: controller.value,
                      onChanged: null,
                      fillColor: MaterialStateProperty.resolveWith(
                        (_) => textStyle.color,
                      ),
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                    ),
                  ),
                  title: Text(e.toString(), style: textStyle),
                )*/
              ), /*RadioListTile<T>(
                  value: e,
                  contentPadding: const EdgeInsets.all(0.0),
                  groupValue: controller.value,
                  onChanged: controller.onChanged,
                  activeColor: textStyle.color,
                  title: Text(e.toString(), style: textStyle),
                )*/
            )
            .toList()
      ],
    );
  }
}

class RadioButtonController<T> extends ValueNotifier<T> {
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

  RadioButtonController(
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
