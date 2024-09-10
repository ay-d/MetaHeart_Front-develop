import 'dart:typed_data';

import 'package:cardio_sim/common/component/custom_icon_button.dart';
import 'package:cardio_sim/common/component/custom_text_form_field.dart';
import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/styles/text_styles.dart';
// import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileSelector extends CustomTextFormField {
  final FileSelectController fileController;

  FileSelector({
    super.key,
    super.labelText,
    super.headText,
    super.backgroundColor,
    super.validator,
    super.onChange,
    super.inputFormatters,
    super.inputBorder,
    super.decorationStyle,
    required this.fileController,
  }) : super(
          keyboardType: TextInputType.text,
          textStyle: kTextMainStyle.copyWith(
            fontSize: kTextMiddleSize,
            fontWeight: FontWeight.w400,
          ),
          textController: fileController.textController,
          enabled: false,
          contentPadding: EdgeInsets.symmetric(
            vertical: kPaddingMiddleSize,
            horizontal: kPaddingSmallSize,
          ),
          tail: CustomIconButton(
            onPressed: fileController.selectFile,
            icon: Icons.more_horiz,
            iconColor: decorationStyle?.color,
          ),
        );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: super.build(context)),
        SizedBox(width: kPaddingSmallSize),
      ],
    );
  }
}

class FileSelectController extends ValueNotifier<Uint8List?> {
  final String title;
  late final TextEditingController textController;
  List<String>? allowedExtensions;
  FilePickerResult? file;

  FileSelectController(
    super._value, {
    required this.title,
    TextEditingController? textController,
    this.allowedExtensions,
  }) {
    this.textController = textController ?? TextEditingController();
  }

  void selectFile() async {
    try {
      file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );
    } catch (e) {
      // file = await FilePickerWeb.platform.pickFiles(
      //   type: FileType.custom,
      //   allowedExtensions: allowedExtensions,
      // );
    }
    if (file != null) {
      textController.text = file!.files.single.name;
      value = file!.files.single.bytes!;
    }
  }

  String get fileName => textController.text;
}
