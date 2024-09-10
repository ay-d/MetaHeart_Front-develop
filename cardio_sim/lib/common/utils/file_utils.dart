import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class FileUtil {
  static Future<String?> getFile(List<String> allowedExtensions) async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    String? result;
    try {
      if (filePickerResult != null && filePickerResult.files.isNotEmpty) {
        Uint8List fileBytes = filePickerResult.files.first.bytes!;
        result = utf8.decode(fileBytes);
      }
    } catch (e) {
      if (filePickerResult != null && filePickerResult.files.isNotEmpty) {
        PlatformFile? file = filePickerResult.files.first;
        result = File(file.path!).readAsStringSync();
      }
    }
    return result;
  }
}
