import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:menu_weather/Provider/Message_Provider.dart';
import 'package:menu_weather/utils/utils.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';


class RecipePage extends HookConsumerWidget {
  const RecipePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // riverpodを使ってリアルタイムで値（レシピ）を受け取り
    final messageState = ref.watch(messageProvider);

  


    return Scaffold(

      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: screenWidth(context)*0.1,
                    bottom: 15
                  ),
                  width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.8 : 768,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                      messageState['dishname'] ?? '',
                      // textAlign: TextAlign.left,
                      style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  // レシピリスト
                  width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.8 : 768,
                  height: screenHeight(context)*0.8,
                  padding: EdgeInsets.fromLTRB(45.0, 30.0, 30.0, 30.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: ListView.builder(
                    itemCount: List<Map<String, dynamic>>.from(messageState['recipes'] ?? []).length,
                    itemBuilder: (context, index){
                      final item = Map<String, dynamic>.from(messageState['recipes'][index]);

                      String text = '\n';
                      item.forEach((String key, dynamic value){
                        if(key != 'name'){
                          text = text + value.toString() + '\n\n\n';
                        }
                      });
                      return Column(
                        children: [
                          // レシピタイトルを表示したい場合はコメント解除
                          // Padding(
                          //   padding: EdgeInsets.only(bottom: 20),
                          //   child: Text(item['name'] ?? '',
                          //     style: TextStyle(
                          //       fontSize: 25,
                          //       fontWeight: FontWeight.bold
                          //     ),
                          //   ),
                          // ),
                          Text(
                            text,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      );
                    },
                  ),
                )
              ],
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
        ]
      ),
      
    );
  }
}
