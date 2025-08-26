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
    Color color = Color.fromARGB(255, 81, 177, 255);
    double radius = 200;
    return GestureDetector(
      onTap: () {
        
      },
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: screenHeight(context) * 0.14,
                width: screenWidth(context) * 2,
                decoration: BoxDecoration(
                  color: color
                ),
              ),
              Container(
                height: screenHeight(context) * 0.3,
                width: screenWidth(context) * 1.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius)
                  ),
                  color: color
                ),
              ),
            ],
          ),
          ListView(
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
              buildMenuItem(
                context,
                '設定',
                () {
                  movePage(context, SettingPage());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}