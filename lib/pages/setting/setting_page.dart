import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menu_weather/components/navigation_button.dart';
import 'package:menu_weather/utils/utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

// DB用インポート
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:menu_weather/database/database_service.dart';
import 'package:sqflite/utils/utils.dart';
import 'allergy.dart';
import 'leftovers.dart';


// import 'package:menu_weather/components/chat_form.dart';











class SettingPage extends HookWidget {
  const SettingPage({super.key});


  Future<void> _addLeftover(String name, String amount) async {
    if (name.isEmpty || amount.isEmpty) return;
    await DatabaseService.instance.insertLeftover(
      Leftover(name: name, amount: amount),
    );
  }

  Future<void> _addAllergy(String name) async {
    if (name.isEmpty) return;
    await DatabaseService.instance.insertAllergy(
      Allergy(name: name),
    );
  }



  


  @override
  Widget build(BuildContext context) {


    late Future<List<Leftover>> _leftovers;
    _leftovers = DatabaseService.instance.getLeftovers();

    
    final leftovers = TextEditingController();

    final allergycontroller = TextEditingController();

    final leftnamecontroller = useTextEditingController();
    final leftamoutcontroller = useTextEditingController();
    final allcontroller = useTextEditingController();



    List<String> allergy = [
      'えび',
      'かに',
      'くるみ',
      '小麦',
      'そば',
      '卵',
      '乳',
      '落花生',
      'その他',
    ];

    final dropdownvalue = useState<String>(allergy.first);


    useEffect((){
      print('値変わったで');
    },[leftovers.value]);
  
    useEffect(() {
      if(dropdownvalue.value != 'その他'){

        print('${dropdownvalue.value}がアレルギーなんやな！');
      }
    },[dropdownvalue.value]);

    useEffect(() {
      print('${allergycontroller.text}がアレルギーなんやな');
    },[allergycontroller.text]);


    return Scaffold(

      backgroundColor: Colors.grey[200],

      // 画面全体
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: IconButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     icon: Icon(
              //       Icons.arrow_back_ios_new,
              //       size: 30,
              //     )
              //   ),
              // ),
              NavigationButton(
                func: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 30,
                )
              ),
              // 余りもの登録
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,       
                  children: [
                    Text('余りもの登録',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.8 : 768,
                      height: screenHeight(context) * 0.45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 余りものの名前を入力
                              SizedBox(
                                width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.6 : 650,
                                height: 30,
                                child: TextFormField(
                                  controller: leftnamecontroller,
                                  decoration: InputDecoration(
                                    hintText: '余りものの名前を入力してください',
                                    hintStyle: const TextStyle(fontSize: 12, color: Colors.blue),
                                    fillColor: Colors.blue[100],
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.blue[200]!,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  
                                ),
                              ),
                              Container( padding: EdgeInsets.only(top: 10)),                              
                              // 余りものの量を入力
                              SizedBox(
                                width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.6 : 650,
                                height: 30,
                                child: TextFormField(
                                  controller: leftamoutcontroller,
                                  decoration: InputDecoration(
                                    hintText: '余りものの量を入力してください',
                                    hintStyle: const TextStyle(fontSize: 12, color: Colors.blue),
                                    fillColor: Colors.blue[100],
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.blue[200]!,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  
                                ),
                              ),
                              Container( padding: EdgeInsets.only(top: 10)),                              
                              ElevatedButton(
                                onPressed: () async {
                                  
                                  final exists = await DatabaseService.instance.leftoverExists(
                                    leftnamecontroller.text,
                                  );
                                  // 重複確認
                                  if (exists) {
                                    // すでに存在する場合はメッセージ表示
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("同じ名前の余りものが既に存在します")),
                                    );
                                    return;
                                  }

                                  // 存在してない場合は追加
                                  final leftover = Leftover(
                                    name: leftnamecontroller.text,
                                    amount: leftamoutcontroller.text,
                                  );
                                  print('データ登録開始');
                                  await
                                  DatabaseService.instance.insertLeftover(leftover);
                                  print('データ登録完了');

                                  leftnamecontroller.clear();
                                  leftamoutcontroller.clear();
                                },
                                child: const Text("余りものを登録"),
                              ),
                              const Divider(),
                              Container(width: 10),
                            ],
                          ),
                          FutureBuilder<List<Leftover>>(
                            future: _leftovers,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              final leftovers = snapshot.data!;
                              if (leftovers.isEmpty) {
                                return const Center(child: Text("登録なし",
                                  style: TextStyle(fontSize: 25),
                                ));
                              }
                              return ListView.builder(
                                itemCount: leftovers.length,
                                itemBuilder: (context, index) {
                                  final item = leftovers[index];
                                  return SingleChildScrollView(
                                    child: 
                                    ListTile(
                                      title: Text(item.name,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      subtitle: Text("量: ${item.amount}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.blue),
                                        onPressed: () async {
                                          await DatabaseService.instance.deleteLeftover(item.id!);
                                          _leftovers = DatabaseService.instance.getLeftovers(); // リロード
                                        },
                                      ),

                                    )
                                  );
                                },
                              );
                            },
                          ),
                          
                        ],
                      )

                    )
                  ],
                )
              ),

              Container(
                height: 30,
              ),

              // アレルギー登録
              SingleChildScrollView(
                child: Column(
                  children: [
                    Text('アレルギー登録',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 50),
                      width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.8 : 768,
                      height: screenHeight(context) * 0.45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DropdownButton(
                                dropdownColor: Colors.blue[100],
                                value: dropdownvalue.value,
                                items: allergy.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  dropdownvalue.value = value!;
                                },
                                menuMaxHeight: 245,
                              ),
                              Container(height: 10,),
                              dropdownvalue.value != 'その他' ? 
                              ElevatedButton(
                                onPressed: () async {

                                  final exists = await DatabaseService.instance.AllergyExists(
                                    dropdownvalue.value,
                                  );
                                  // 重複確認
                                  if (exists) {
                                    // すでに存在する場合はメッセージ表示
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("同じ名前のアレルギーが既に存在します")),
                                    );
                                    return;
                                  }

                                  // 存在しない場合は追加
                                  final allergy = Allergy(
                                    name: dropdownvalue.value,
                                  );
                                  print('データ登録開始');
                                  await
                                  DatabaseService.instance.insertAllergy(allergy);
                                  print('データ登録完了');
                                  
                                },
                                child: const Text("アレルギーを登録"),
                              ) :
                                
                                // その他を選択すれば登録ボタンを変更
                                Container(),
                            ]
                          ),
                          // その他を選択したら入力フォーム
                          dropdownvalue.value == 'その他' ?
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.6 : 650,
                                height: 30,
                                child: TextFormField(
                                  controller: allergycontroller,
                                  decoration: InputDecoration(
                                    hintText: 'アレルギーの食品を入力してください',
                                    hintStyle: const TextStyle(fontSize: 12, color: Colors.blue),
                                    fillColor: Colors.blue[100],
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.blue[200]!,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  
                                ),
                              ),
                              Container(height: 10,),
                              ElevatedButton(
                                onPressed: () async {

                                  final exists = await DatabaseService.instance.AllergyExists(
                                    allergycontroller.text,
                                  );
                                  // 重複確認
                                  if (exists) {
                                    // すでに存在する場合はメッセージ表示
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("同じ名前のアレルギーが既に存在します")),
                                    );
                                    return;
                                  }

                                  // 存在しない場合は追加
                                  final allergy = Allergy(
                                    name: allergycontroller.text,
                                  );
                                  print('データ登録開始');
                                  await
                                  DatabaseService.instance.insertAllergy(allergy);
                                  print('データ登録完了');

                                  allergycontroller.clear();
                                },
                                child: const Text("アレルギーを登録"),
                              ),
                            ],
                          ) : Container(),
                          const Divider(),
                          Container(width: 10),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AllergyListPage()),
                              );
                            },
                            child: Text('アレルギーリスト'),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ),
              Container(
                height: 30,
              )
              // // AIの口調
              // SingleChildScrollView(
              //   child: Column(
              //     children: [
              //       Text('AIの口調',
              //         style: TextStyle(
              //           fontSize: 30,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       Container(
              //         width: screenWidth(context)*0.8 < 768 ? screenWidth(context) * 0.8 : 768,
              //         height: screenHeight(context) * 0.45,
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(20)
              //         ),
              //       )
              //     ],
              //   )
              // ),
            ]
          )
        ),
      )
      
    );
  }
}