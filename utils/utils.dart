import 'package:flutter/material.dart';

void shouErrorSnackBar(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    )
  );
}

void movePage(BuildContext context, Widget widget) {
  Navigator.push(
    context, MaterialPageRoute(builder: (context) => widget)
  );
}