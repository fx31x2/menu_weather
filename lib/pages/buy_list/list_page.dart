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
                margin: EdgeInsets.only(left:screenWidth(context)*0.1,
                  bottom: 15
                ),
                width: screenWidth(context)*0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)                  
                ),
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
              padding: EdgeInsets.fromLTRB(45.0, 30.0, 30.0, 30.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
              ),
              
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth(context)*0.3,
                    child: Text(map['ingredients'][0]['name'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                  Container(
                    width: screenWidth(context)*0.3,
                    child: Text((map['ingredients'][0]['price']).toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                  Container(
                    width: screenWidth(context)*0.1,
                    child: Checkbox(value: map['ingredients'][0]['checkbox'],
                     onChanged: (value){
                      setState(() {
                        map['ingredients'][0]['checkbox'] = value!;
                        print(map['ingredients'][0]['checkbox']);
                      });
                     }),
                  )
                ],
                
              )

            ),
          ]
        ),
      )
      

    );
  }
}