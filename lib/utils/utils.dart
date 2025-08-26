import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:menu_weather/Provider/gemini_model.dart';

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

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// WidgetRef から共有の ChatSession を取得して送信する
Future<void> sendMessage(String text, WidgetRef ref) async {
  final session = ref.read(chatSessionProvider);
  if (session == null) return;
  await session.sendMessage(Content.text(text));
}