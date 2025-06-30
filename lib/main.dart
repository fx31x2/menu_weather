import 'package:flutter/material.dart';
import 'package:menu_weather/pages/chat/chat_page.dart';
import 'package:menu_weather/pages/buy_list/list_page.dart';

void main() {
  runApp(const MyApp());  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListPage()
      // ChatPage(),
    );
  }
}