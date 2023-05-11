import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  static void successToast(String message) {
    Fluttertoast.showToast(msg: message);
  }

  static void errorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
    );
  }
}
