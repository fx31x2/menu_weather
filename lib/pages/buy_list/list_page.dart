import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  
  Map<String, dynamic>map={
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
      
      

    );
  }
}