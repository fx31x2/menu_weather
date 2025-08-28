import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:menu_weather/components/jumping_dots.dart';

import 'package:menu_weather/Provider/IsSent.dart';

Widget messageItem(String message, User user, WidgetRef ref) {
  final isSent = ref.watch(isSentProvider);
  final bool isLoadingDots = (isSent && user.id != 'user' && message == '');
  return Container(
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),

    child: Row(
      mainAxisAlignment: (user.id == 'user') ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Flexible(
          child: Container(
            constraints: isLoadingDots
                ? BoxConstraints(
                    maxWidth: 60,
                    minWidth: 24,
                  )
                : null,
            padding: EdgeInsets.symmetric(
              vertical: isLoadingDots ? 8 : 10,
              horizontal: isLoadingDots ? 8 : 14,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: (user.id == 'user') ? Colors.blue : Colors.grey[200]
            ),
            child: isLoadingDots ? 
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 48,
                minWidth: 20,
                minHeight: 14,
              ),
              child: Center(
                child: MiniJumpingDots(
                  dotCount: 3,
                  dotSize: 7.0,
                  dotSpacing: 2.0,
                  amplitude: 2.5,
                  duration: Duration(milliseconds: 900),
                  color: Colors.black54,
                ),
              ),
            ) : 
            Text(
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