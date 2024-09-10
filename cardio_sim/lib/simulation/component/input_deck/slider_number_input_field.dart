import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/simulation/component/input_deck/basic_number_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SliderNumberInputField extends BasicNumberInputField {
  final SliderController sliderController;

  SliderNumberInputField({
    super.key,
    super.labelText,
    super.headText,
    super.backgroundColor,
    super.validator,
    super.inputBorder,
    super.textStyle,
    super.decorationStyle,
    required this.sliderController,
  }) : super(
          textController: sliderController.textController,
          onChange: sliderController.onTextChange,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d?')),
          ],
          tail: ValueListenableBuilder(
            valueListenable: sliderController,
            builder: (context, double value, __) => Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackShape: const RectangularSliderTrackShape(),
                  trackHeight: ResponsiveSize.S(4.0),
                  thumbColor: Colors.blueAccent,
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: ResponsiveSize.S(12.0),
                  ),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                ),
                child: Slider(
                  min: sliderController.min,
                  max: sliderController.max,
                  divisions: sliderController.divisions,
                  value: value,
                  onChanged: sliderController.onChange,
                  thumbColor: decorationStyle?.color,
                  activeColor: decorationStyle?.color,
                  inactiveColor: decorationStyle?.color?.withOpacity(0.5),
                ),
              ),
            ),
          ),
        );
}

class SliderController extends ValueNotifier<double> {
  final double min;
  final int? divisions;
  final double max;
  late final TextEditingController textController;
  final NumberFormat format = NumberFormat('#0.0');

  SliderController(
    super._value, {
    this.min = 0,
    this.max = 1,
    this.divisions,
    TextEditingController? textController,
  }) {
    this.textController =
        textController ?? TextEditingController(text: format.format(value));
  }

  void onChange(double value) {
    this.value = value;
    textController.text = format.format(this.value);
  }

  void onTextChange(String? value) {
    if (value != null) {
      double temp = double.tryParse(value) ?? 0;
      if (temp < min) {
        textController.text = format.format(min);
      } else if (temp > max) {
        textController.text = format.format(max);
      }
      this.value = temp > max
          ? max
          : temp < min
              ? min
              : temp;
    }
  }
}
