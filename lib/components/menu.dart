import 'package:flutter/material.dart';
import 'package:menu_weather/components/menu_item.dart';
import 'package:menu_weather/pages/buy_list/list_page.dart';
import 'package:menu_weather/pages/recipe/recipe_page.dart';
import 'package:menu_weather/pages/setting/setting_page.dart';
import 'package:menu_weather/utils/utils.dart';

class Menu extends StatefulWidget {
  const Menu({
    super.key,
  });

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
      },
      child: Container(
        height: screenHeight(context) * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          color: Colors.blue[400]
        ),
        child: ListView(
          children: [
            buildMenuItem(
              context,
              '買い物リスト', 
              () {
                movePage(context, ListPage());
              }
            ),
            buildMenuItem(
              context,
              'レシピ', 
              () {
                movePage(context, RecipePage());
              }
            ),
            buildMenuItem(context,
              '設定',
              () {
                movePage(context, SettingPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}