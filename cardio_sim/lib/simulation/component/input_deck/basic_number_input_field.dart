import 'package:cardio_sim/common/component/custom_text_form_field.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:flutter/material.dart';

class BasicNumberInputField extends CustomTextFormField {
  BasicNumberInputField({
    super.key,
    super.labelText,
    super.headText,
    super.tail,
    super.textController,
    super.backgroundColor,
    super.validator,
    super.inputBorder,
    super.onChange,
    super.inputFormatters,
    super.textStyle,
    super.decorationStyle,
    super.enabled,
  }) : super(
          keyboardType: TextInputType.number,
          contentPadding: EdgeInsets.symmetric(
            vertical: kPaddingMiddleSize,
            horizontal: kPaddingSmallSize,
          ),
        );
}