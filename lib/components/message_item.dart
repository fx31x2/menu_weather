import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:jumping_dot/jumping_dot.dart';
import 'package:menu_weather/Provider/IsSent.dart';

Widget messageItem(String message, User user, WidgetRef ref) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),

    child: Row(
      mainAxisAlignment: (user.id == 'user') ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: (user.id == 'user') ? Colors.blue : Colors.grey[200]
            ),
            child: Text(
              message,
              style: TextStyle(
                color: (user.id == 'user') ? Colors.white : Colors.black
              ),
            )
          )
        )
      ],
    ),
  );
}