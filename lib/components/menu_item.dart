import 'package:flutter/material.dart';
import 'package:menu_weather/utils/utils.dart';

Widget buildMenuItem(BuildContext context, String title, Function onTap) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10),
    width: screenWidth(context) * 0.3,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide()
      )
    ),
    child: ListTile(
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        )
      ),
      onTap: () {
        onTap();
      },
    ),
  );
}