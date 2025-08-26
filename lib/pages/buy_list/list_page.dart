import 'package:flutter/material.dart';
import 'package:menu_weather/Provider/Message_Provider.dart';
import 'package:menu_weather/utils/utils.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListPage extends HookConsumerWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageState = ref.watch(messageProvider);

    return Scaffold(
      
      // 背景色
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 料理名
                Container(
                  margin: EdgeInsets.only(left:screenWidth(context)*0.1,
                    bottom: 15
                  ),
                  width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.8 : 768,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(
                    messageState['dishname'] ?? '',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 買い物リスト
                Container(
                  width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.8 : 768,
                  height: screenHeight(context)*0.8,
                  padding: EdgeInsets.fromLTRB(45.0, 30.0, 30.0, 30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: 
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,                    
                        children: [
                          Container(
                            width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.2 : 241,
                            // margin: EdgeInsets.only(right: 30, bottom: 20),
                            height: 30,
                            child: Text(
                              '材料',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.2 : 241,
                            // margin: EdgeInsets.only(right: 30),                        
                            height: 30,
                            child: Text(
                              '量',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.1 : 100,
                            height: 30,
                            child: Text('　',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
          
                      Expanded(
                        child: ListView.builder(
                          itemCount: List<Map<String, dynamic>>.from(messageState['ingredients'] ?? []).length,
                          itemBuilder: (context, index){
                            final item = messageState['ingredients'][index];
                            return ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.2 : 300,
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      item['name'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ),
                                  Container(
                                    width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.2 : 300,
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      item['amount'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ),
                                  Checkbox(
                                    value: item['checkbox'],
                                    onChanged: (value){
                                      ref.read(messageProvider.notifier).setCheckBox(index, value ?? false);
                                    }
                                  )                     
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 30,
              )
            ),
          )
        ],
      )
    );
  }
}

// class JapaneseMlbPlayer {
//    String name;
//    String team;

//    JapaneseMlbPlayer(this.name, this.team);
// }

// class ListPage extends StatefulWidget {
//   const ListPage({
//     super.key,
//   });

//   @override
//   State<ListPage> createState() => _ListPageState();
// }

// class _ListPageState extends State<ListPage> {
//   Map<String, dynamic>map={
//     'ingredients' : [
//       {
//         'name' : 'じゃがいも',
//         // 'price' : 100,
//         'amount' : '中サイズ1個',
//         'checkbox' : false,
//       },
//       {
//         'name' : 'にんじん',
//         // 'price' : 120,
//         'amount' : '1/4本',
//         'checkbox' : false,
//       },
//       {
//         'name' : 'きゅうり',
//         // 'price' : 100,
//         'amount' : '1/4本',
//         'checkbox' : false,
//       },
//       {
//         'name' : 'ハム',
//         // 'price' : 150,
//         'amount' : '1~2枚',
//         'checkbox' : false,
//       },
//       {
//         'name' : 'マヨネーズ',
//         // 'price' : 200,
//         'amount' : '大さじ1~2',
//         'checkbox' : false,
//       },
//       {
//         'name' : '塩',
//         // 'price' : 150,
//         'amount' : '少々',
//         'checkbox' : false,
//       },
//       {
//         'name' : '胡椒',
//         // 'price' : 150,
//         'amount' : '少々',
//         'checkbox' : false,
//       }

//     ]
//   };

//   List<Map<String, dynamic>> list = [];

//   Map<String, dynamic> buy = {};

//   @override
//   void initState() {
//     list = List<Map<String, dynamic>>.from(buy['ingredients']);
    
//     super.initState();
//   }
  

//   @override
//   Widget build(BuildContext context) {
//     //list = List<Map<String, dynamic>>.from(map['ingredients']);

//     return Scaffold(
      
//       // 背景色
//       backgroundColor: Colors.grey,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // 料理名
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Container(
//                 margin: EdgeInsets.only(left:screenWidth(context)*0.1,
//                   bottom: 15
//                 ),
//                 width: screenWidth(context)*0.8,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20)
//                 ),
//                 child: Text('ポテトサラダ',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               )
//             ),
//             // 買い物リスト
//             Container(
//               width: screenWidth(context)*0.8,
//               height: screenHeight(context)*0.8,
//               padding: EdgeInsets.fromLTRB(45.0, 30.0, 30.0, 30.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20)
//               ),
//               child: 
//               Column(
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,                    
//                     children: [
//                       Container(
//                         width: screenWidth(context)*0.2,
//                         margin: EdgeInsets.only(right: 30, bottom: 20),
//                         height: 30,
//                         child: Text('材料',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: screenWidth(context)*0.2,
//                         margin: EdgeInsets.only(right: 30),                        
//                         height: 30,
//                         child: Text('量',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         height: 30,
//                         child: Text('　',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
                  
//                     //   Container(
//                     //     width: screenWidth(context)*0.25,
//                     //     height: screen,
//                     //     padding: EdgeInsets.only(top: 10),
//                     //   ),
//                     ],
//                   ),

//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: list.length,
//                       itemBuilder: (context, index){
//                         final item = list[index];
//                         return ListTile(
//                           title: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 width: screenWidth(context)*0.25,
//                                 padding: EdgeInsets.only(top: 10),
//                                 child: Text(item['name'],
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold
//                                   ),
//                                 )
//                               ),
//                               Container(
//                                 width: screenWidth(context)*0.25,
//                                 padding: EdgeInsets.only(top: 10),
//                                 child: Text(item['amount'],
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold
//                                   ),
//                                 )
//                               ),
//                               Checkbox(value: item['checkbox'],
//                                 onChanged: (value){
//                                   setState(() {
//                                     // map['ingredients'][index]['checkbox'] = value!;
//                                     // print('$index : ${item['checkbox']}');
//                                     item['checkbox'] = value!;
//                                   });
//                                 }
//                               )                     
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ]
//         ),
//       )
//     );
//   }
// }