import 'package:flutter/material.dart';
import 'package:menu_weather/utils/utils.dart';

Widget buildMenuItem(BuildContext context, String title, Function onTap) {
  return Container(
    decoration: BoxDecoration(color: Colors.red),
    padding: EdgeInsets.only(top: 10, bottom: 5),
    width: screenWidth(context) * 0.3,
    child: Column(
      children: [
        ListTile(
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
        Divider(
          height: 5,
          color: Colors.white,
          indent: 70,
          endIndent: 70,
          thickness: 2,
        ),
      ],
    ),
  );
}