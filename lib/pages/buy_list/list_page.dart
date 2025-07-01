import 'package:flutter/material.dart';
import 'package:menu_weather/utils/utils.dart';
import 'package:menu_weather/main.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  
  Map<String?, dynamic>map={
    'ingredients' : [
      {
        'name' : 'potato',
        'price' : 100,
        'amount' : '中サイズ1個',
        'checkbox' : false,
      },
      {
        'name' : 'carrot',
        'price' : 120,
        'amount' : '1/4本',
        'checkbox' : false,
      },
      {
        'name' : 'cucumber',
        'price' : 100,
        'amount' : '1/4本',
        'checkbox' : false,
      },
      {
        'name' : 'ham',
        'price' : 150,
        'amount' : '1~2枚',
        'checkbox' : false,
      },
      {
        'name' : 'mayonnaise',
        'price' : 200,
        'amount' : '大さじ1~2',
        'checkbox' : false,
      },
      {
        'name' : 'salt',
        'price' : 150,
        'amount' : '少々',
        'checkbox' : false,
      },
      {
        'name' : 'pepper',
        'price' : 150,
        'amount' : '少々',
        'checkbox' : false,
      }
    ]
  };
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 背景色
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 料理名
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                // decoration: BoxDecoration(
                //   color: Colors.grey
                // ),
                margin: EdgeInsets.only(left:screenWidth(context)*0.1,
                  bottom: 15
                ),
                width: screenWidth(context)*0.8,
                // height: screenHeight(context)*0.8,
                child: Text('ポテトサラダ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ),
            // 買い物リスト
            Container(
              width: screenWidth(context)*0.8,
              height: screenHeight(context)*0.8,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(map['ingredients'][0]['name']),
            
            ),
          ]
        ),
      )
      

    );
  }
}