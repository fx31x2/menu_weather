import 'package:flutter/material.dart';

class ChatForm extends StatefulWidget {
  const ChatForm({
    super.key,
    required this.textController,
    required this.labelText,
  });

  final TextEditingController textController;
  final String labelText;

  @override
  State<ChatForm> createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,

      decoration: InputDecoration(
        fillColor: Colors.grey[100],
        filled: true,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(128),
        ),

        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
        )
      ),
    );
  }
}