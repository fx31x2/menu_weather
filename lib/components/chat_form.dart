import 'package:flutter/material.dart';
import 'package:menu_weather/utils/utils.dart';

class ChatForm extends StatefulWidget {
  const ChatForm({
    super.key,
    required this.textController,
    required this.hintText,
    required this.onSubmitted,
  });

  final TextEditingController textController;
  final String hintText;
  final Function(String) onSubmitted;

  @override
  State<ChatForm> createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  void handleSubmit(String value) {
    if(value != '') {
      widget.onSubmitted(value);
      widget.textController.clear();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: screenWidth(context) * 0.95,
      child: TextField(
        controller: widget.textController,
        
        decoration: InputDecoration(
          fillColor: Colors.grey[100],
          filled: true,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(128),
            borderSide: BorderSide.none
          ),

          hintText: widget.hintText,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),

          suffixIcon: IconButton(
            onPressed: () {
              handleSubmit(widget.textController.text);
            },
            icon: Icon(
              Icons.send
            )
          ),
        ),

        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.send,
        onSubmitted: (value) {
          if(value != '') {
            handleSubmit(value);
          }
        }
      ),
    );
  }
}