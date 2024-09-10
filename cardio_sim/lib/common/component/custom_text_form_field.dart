import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cardio_sim/common/styles/colors.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? headText;
  final Widget? tail;

  final IconData? prefixIcon;

  final TextInputType keyboardType;

  final void Function(String?)? onChange;
  final String? Function(String?)? validator;
  final TextEditingController? textController;

  final TextStyle? textStyle;
  final TextStyle? decorationStyle;
  late final EdgeInsetsGeometry contentPadding;
  final Color? backgroundColor;
  final Color? fieldColor;

  final bool? enabled;

  final List<FilteringTextInputFormatter>? inputFormatters;

  late final InputBorder inputBorder;

  CustomTextFormField({
    Key? key,
    this.labelText,
    this.hintText,
    this.headText,
    this.tail,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.onChange,
    this.validator,
    this.textController,
    this.textStyle,
    this.decorationStyle,
    this.inputFormatters,
    this.enabled,
    InputBorder? inputBorder,
    EdgeInsetsGeometry? contentPadding,
    this.backgroundColor,
    this.fieldColor,
  }) : super(key: key) {
    this.contentPadding = contentPadding ??
        EdgeInsets.symmetric(
          vertical: kPaddingMiddleSize,
          horizontal: 0,
        );
    this.inputBorder = inputBorder ??
        UnderlineInputBorder(borderSide: BorderSide(width: 1.0.w));
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = kTextMiddleSize;
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? kBackgroundMainColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(
                  prefixIcon,
                  size: kIconSmallSize,
                  color: decorationStyle?.color,
                ),
                SizedBox(width: kPaddingSmallSize),
              ],
              if (labelText != null)
                Text(
                  labelText!,
                  style: decorationStyle,
                ),
            ],
          ),
          SizedBox(height: kPaddingMiniSize),
          Row(
            children: [
              if (headText != null) ...[
                Expanded(
                  child: Text(
                    headText!,
                    style: decorationStyle ??
                        kTextMainStyle.copyWith(fontSize: fontSize),
                    maxLines: 3,
                  ),
                ),
                SizedBox(width: kPaddingSmallSize),
              ],
              Expanded(
                child: TextFormField(
                  enabled: enabled,
                  controller: textController,
                  validator: validator,
                  cursorColor: kTextMainColor,
                  keyboardType: keyboardType,
                  obscureText: keyboardType == TextInputType.visiblePassword,
                  style: GoogleFonts.notoSerif(
                    textStyle: textStyle ??
                        kTextMainStyle.copyWith(fontSize: fontSize),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')), // 공백 입력 방지
                    ...?inputFormatters,
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: contentPadding,
                    hintText: hintText,
                    border: inputBorder,
                    disabledBorder: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    hintStyle: GoogleFonts.notoSerif(
                      textStyle: textStyle?.copyWith(
                            color: kTextMainColor.withOpacity(0.5),
                          ) ??
                          kTextMainStyle.copyWith(
                            fontSize: fontSize,
                            color: kTextMainColor.withOpacity(0.5),
                          ),
                    ),
                    filled: true,
                    fillColor: fieldColor ?? kBackgroundMainColor,
                    errorStyle: kTextMainStyle.copyWith(
                      color: kPointColor,
                      fontSize: kTextMiniSize,
                    ),
                  ),
                  onChanged: onChange,
                ),
              ),
              if (tail != null) ...[
                SizedBox(width: kPaddingSmallSize),
                tail!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
