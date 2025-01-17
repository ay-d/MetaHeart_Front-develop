import 'package:flutter/material.dart';
import 'package:cardio_sim/common/styles/colors.dart';

class SnackBarUtil {
  static GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static void showError(String message) {
    key.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(drawSnackBar(message, kPointColor));
  }

  static void showMessage(String message) {
    key.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(drawSnackBar(message, kMainColor3));
  }

  static void showSuccess(String message) {
    key.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(drawSnackBar(message, kAbleColor));
  }

  static SnackBar drawSnackBar(String message, Color color) {
    return SnackBar(
      backgroundColor: color,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center, softWrap: false),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20.0),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
