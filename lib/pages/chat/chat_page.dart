import 'package:flutter/material.dart';
import 'package:menu_weather/components/chat_form.dart';
import 'package:menu_weather/utils/utils.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController _chatController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
        child: SizedBox(
          width: screenWidth(context) * 0.95,
          height: 30,
          
          child: Column(
            children: [
              ChatForm(
                textController: _chatController,
                labelText: 'メッセージを入力してください',
              )
            ],
          ),
        )
      ),
    );
  }
}