import 'package:flutter/material.dart';

class AppDialog {
  static Future<void> show(BuildContext context, {required Widget child}) async {
    await showDialog(context: context, builder: (_) => Dialog(child: child));
  }
}
