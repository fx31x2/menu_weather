import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:menu_weather/components/navigation_button.dart';
import 'package:menu_weather/utils/utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

// DB用インポート
import 'package:menu_weather/database/database_service.dart';


// import 'package:menu_weather/components/chat_form.dart';











class SettingPage extends HookConsumerWidget {
  SettingPage({super.key});


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


  final _scrollLeftController = ScrollController();
  final _scrollAllController = ScrollController();


  int leftcount = 1;
  int allcount = 1;



  @override
  Widget build(BuildContext context, WidgetRef ref) {


    late Future<List<Leftover>> _leftovers;
    _leftovers = DatabaseService.instance.getLeftovers();

    late Future<List<Allergy>> _allergy;
    _allergy = DatabaseService.instance.getAllergy();

    final leftoversFuture = useState<Future<List<Leftover>>>(
      DatabaseService.instance.getLeftovers()
    );

    final allergyFuture = useState<Future<List<Allergy>>>(
      DatabaseService.instance.getAllergy()
    );

  final ValueNotifier<String?> selectedValue = ValueNotifier<String?>(null);



  

    final dropdowncontroller = TextEditingController();
    final focusNode = useFocusNode();

    final leftovers = TextEditingController();

    final allergies = TextEditingController();

    final allergycontroller = TextEditingController();

    final leftnamecontroller = useTextEditingController();
    final leftamoutcontroller = useTextEditingController();
    final allcontroller = useTextEditingController();

    final leftclick = useState<bool>(false);
    final allclick = useState<bool>(false);

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


    // useEffect(() {},[_leftovers]);

    useEffect(() {},[_leftovers]);
    useEffect(() {},[_allergy]);

    useEffect(() {},[dropdowncontroller]);

    useEffect(() {},[leftclick.value]);
    useEffect(() {},[allclick.value]);

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
                    // Text('余りもの登録',
                    //   style: TextStyle(
                    //     fontSize: 35,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    leftclick.value == true ?
                    GestureDetector(
                      onTap: () {
                        leftclick.value = false;
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                        width: screenWidth(context)*0.9 < 768 ? screenWidth(context) * 0.9 : 768,
                        height: screenHeight(context) * 0.45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('余りもの登録・確認',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Icon(Icons.expand_more),
                                  ],
                                ),
                                Container(height: 20,),
                                // 余りものの名前を入力
                                Row(
                                  children: [
                                    SizedBox(
                                      width: screenWidth(context)*0.36< 768 ? screenWidth(context) * 0.36 : 650,
                                      height: 30,
                                      child: TextFormField(
                                        controller: leftnamecontroller,
                                        decoration: InputDecoration(
                                          hintText: '余りものの名前を入力してください',
                                          hintStyle: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                                          fillColor: Colors.grey[100],
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              width: 2.0,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Colors.grey[200]!,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                      
                                      ),
                                    ),
                                    Container(width: 10,),
                                    // 余りものの量を入力
                                    SizedBox(
                                      width: screenWidth(context)*0.36 < 768 ? screenWidth(context) * 0.36 : 650,
                                      height: 30,
                                      child: TextFormField(
                                        controller: leftamoutcontroller,
                                        decoration: InputDecoration(
                                          hintText: '余りものの量を入力してください',
                                          hintStyle: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                                          fillColor: Colors.grey[100],
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              width: 2.0,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Colors.grey[200]!,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                      
                                      ),
                                    ),
                                  ], 
                                ),
                                Container( padding: EdgeInsets.only(top: 15)),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: ElevatedButton(
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
                                          leftoversFuture.value = DatabaseService.instance.getLeftovers();
                                          print('データ登録完了');

                                          sendMessage('${leftover.name}が${leftover.amount}余っているので優先的に材料に追加してください。', ref);
                                                            
                                          leftnamecontroller.clear();
                                          leftamoutcontroller.clear();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          )
                                        ),
                                        child: const Text("追加",
                                          style: TextStyle(
                                            color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(height: 10, width: 10),
                              ],
                            ),
                            FutureBuilder<List<Leftover>>(
                              
                              future: leftoversFuture.value,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                final leftover = snapshot.data!;
                                leftcount = leftover.length;
                                if (leftover.isEmpty) {
                                  return const Center(child: Text("登録なし",
                                    style: TextStyle(fontSize: 25),
                                    textAlign: TextAlign.center,
                                  ));
                                }
                      
                      
                      
                                return Container(
                                  height: screenHeight(context) * 0.225,
                                  width:  screenWidth(context) * 0.8,

                                  child: Scrollbar(
                                    
                                    controller: _scrollLeftController,
                                    thumbVisibility: true,
                      
                                    radius: Radius.circular(15),
                                    child: ListView.builder(
                                      
                                      controller: _scrollLeftController,
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemCount:  leftover.length,
                                      itemBuilder: (context, index) {
                                        final item = leftover[index];
                                        return Container(
                                  
                                          child: ListTile(
                                            dense: true,
                                            // タイトル
                                            title: Text(item.name,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                                                
                                            // 詳細
                                            subtitle: Text(item.amount,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15
                                              ),
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.blue),
                                              onPressed: () async {
                                                await DatabaseService.instance.deleteLeftover(item.id!);
                                                leftoversFuture.value = DatabaseService.instance.getLeftovers(); // リロード
                                              },
                                            ),
                                                                
                                          ),
                                        );
                      
                                      }
                                    ), // },
                      
                                  ),
                                // ListView.builder(
                                //   itemCount: leftover.length,
                                //   itemBuilder: (context, index) {
                                //     final item = leftover[index];
                                //     return SingleChildScrollView(
                                //       child:
                                //       ListTile(
                                //         title: Text(item.name,
                                //           textAlign: TextAlign.left,
                                //           style: TextStyle(
                                //             fontSize: 15,
                                //             fontWeight: FontWeight.bold
                                //           ),
                                //         ),
                                //         subtitle: Text("量: ${item.amount}",
                                //           textAlign: TextAlign.left,
                                //           style: TextStyle(
                                //             fontSize: 15,
                                //             fontWeight: FontWeight.bold
                                //           ),
                                //         ),
                                //         trailing: IconButton(
                                //           icon: const Icon(Icons.delete, color: Colors.blue),
                                //           onPressed: () async {
                                //             await DatabaseService.instance.deleteLeftover(item.id!);
                                //             // _leftovers = DatabaseService.instance.getLeftovers(); // リロード
                                //           },
                                //         ),
                      
                                //       )
                                //     );
                                //   },
                                );
                              },
                            ),
                      
                          ],
                        )
                      
                      ),
                    ) :
                    GestureDetector(
                      onTap: () {
                        leftclick.value = true;
                      },
                      child: Column(
                        children: [
                          Container(
                            width: screenWidth(context)*0.9 < 768 ? screenWidth(context) * 0.9 : 768,
                            height: screenHeight(context) * 0.085,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Column(
                              children: [
                                Container(height: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('余りもの登録・確認',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Icon(Icons.expand_more),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
              
                    allclick.value == true ?
                    
                    GestureDetector(
                      onTap: () {
                        allclick.value = false;
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                        width: screenWidth(context)*0.9 < 768 ? screenWidth(context) * 0.9 : 768,
                        height: screenHeight(context) * 0.5,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('アレルギー登録・確認',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Icon(Icons.expand_more),
                                  ],
                                ),
                                // Expanded(
                                //   child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: 
                                        // RawAutocomplete<String>(
                                        //   optionsBuilder: (TextEditingValue textEditingValue) {
                                        //     // 入力値が空なら全候補を返す
                                        //     if (textEditingValue.text.isEmpty) {
                                        //       return allergy;
                                        //     }
                                        //     // 入力にマッチする候補のみ返す
                                        //     return allergy.where((String option) {
                                        //       return option.contains(textEditingValue.text);
                                        //     });
                                        //   },
                                        //   onSelected: (String selection) {
                                        //     selectedValue.value = selection;
                                        //   },
                                        //   fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                                        //     // 入力欄の見た目をカスタマイズ
                                        //     return TextField(
                                        //       controller: dropdowncontroller,
                                        //       focusNode: focusNode,
                                        //       onTap: () {
                                        //         // 空欄クリック時にも候補を表示させる
                                        //         dropdowncontroller.value = dropdowncontroller.value.copyWith(text: dropdowncontroller.text);
                                    
                                        //         // if (dropdowncontroller.text.isEmpty) {
                                        //         //   dropdowncontroller.text = ''; // 状態更新をトリガー
                                        //         // }
                                        //       },
                                        //       onSubmitted: (value) {
                                        //         selectedValue.value = value;
                                        //       },
                                        //       decoration: InputDecoration(
                                        //         hintText: 'アレルギーを入力',
                                        //         border: OutlineInputBorder(),
                                        //         filled: true,
                                        //         fillColor: Colors.white
                                        //       ),
                                        //     );
                                        //   },
                                        //   optionsViewBuilder: (context, onSelected, options) {
                                        //     // 候補リストのUIをカスタマイズ
                                        //     return Align(
                                        //       alignment: Alignment.topLeft,
                                        //       child: Material(
                                        //         elevation: 3,
                                        //         child: SizedBox(
                                        //           height: 200, // DropdownのmenuMaxHeight相当
                                        //           child: ListView.builder(
                                        //             padding: EdgeInsets.zero,
                                        //             itemCount: options.length,
                                        //             itemBuilder: (BuildContext context, int index) {
                                        //               final String option = options.elementAt(index);
                                        //               return ListTile(
                                        //                 title: Text(option),
                                        //                 onTap: () {
                                        //                   onSelected(option);
                                        //                 },
                                        //               );
                                        //             },
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     );
                                        //   },
                                        // )
                                        DropdownButton(
                                          isExpanded: true,
                                          dropdownColor: Colors.grey[100],
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
                                      ),
                                      Container(width: 10,),
                                      dropdownvalue.value != 'その他' ?
                                      SizedBox(
                                        height: 30,
                                        width: 77,
                                        child: ElevatedButton(
                                          
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
                                            allergyFuture.value = DatabaseService.instance.getAllergy();
                                            print('データ登録完了');
                                        
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            )
                                          ),
                                          child: const Text("追加",
                                            style: TextStyle(
                                              color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ) :
                                    
                                      // その他を選択すれば登録ボタンを変更
                                      Container(),
                                    ],
                                  ),
                                  Container(height: 10)
                                // )
                                    
                              ],
                            ),
                            // Container(height: 10,),
                                    
                                    
                            // その他を選択したら入力フォーム
                            dropdownvalue.value == 'その他' ?
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: screenWidth(context)*0.5 < 768 ? screenWidth(context) * 0.5 : 650,
                                      height: 30,
                                      child: TextFormField(
                                        controller: allergycontroller,
                                        decoration: InputDecoration(
                                          hintText: 'アレルギーの食品を入力してください',
                                          hintStyle: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                                          fillColor: Colors.grey[100],
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                              width: 2.0,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: Colors.grey[200]!,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                                  
                                      ),
                                    ),
                      
                                    Container(width: screenWidth(context) * 0.05,),
                                    SizedBox(
                                      height: 30,
                                      child: ElevatedButton(
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
                                          allergyFuture.value = DatabaseService.instance.getAllergy();
                                        
                                          print('データ登録完了');

                                          sendMessage('${allergy.name}がアレルギーなので、材料に加えないでください。', ref);
                                                        
                                          allergycontroller.clear();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          )
                                        ),
                                        child: const Text("追加",
                                          style: TextStyle(
                                            color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ) : Container(),
                            Container(height: 20),
                                    
                            FutureBuilder<List<Allergy>>(
                              future: allergyFuture.value,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                final allergy = snapshot.data!;
                                allcount = allergy.length;
                                if (allergy.isEmpty) {
                                  return const Center(child: Text("登録なし",
                                    style: TextStyle(fontSize: 25),
                                  ));
                                }
                                    
                                    
                                    
                                return Container(
                                  height: dropdownvalue.value == 'その他' ? screenHeight(context) * 0.275 : screenHeight(context) * 0.31,
                                  width:  screenWidth(context) * 0.8,
                                    
                                  child: Scrollbar(
                                    controller: _scrollAllController,
                                    thumbVisibility: true,
                                    
                                    radius: Radius.circular(15),
                                    child: ListView.builder(
                                      controller: _scrollAllController,
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemCount:  allergy.length,
                                      itemBuilder: (context, index) {
                                        final item = allergy[index];
                                        return Container(
                                            child: ListTile(
                                              dense: true,
                                              // タイトル
                                              title: Text(item.name,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                    
                                              trailing: IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.blue),
                                                onPressed: () async {
                                                  await DatabaseService.instance.deleteAllergy(item.id!);
                                                  allergyFuture.value = DatabaseService.instance.getAllergy(); // リロード
                                                },
                                              ),
                                    
                                            ),
                                    
                                        );
                                    
                                      }
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ) :
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            allclick.value = true;
                          },
                          child: Container(
                            width: screenWidth(context)*0.9 < 768 ? screenWidth(context) * 0.9 : 768,
                            height: screenHeight(context) * 0.085,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Column(
                              children: [
                                Container(height: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('アレルギー登録・確認',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Icon(Icons.expand_more),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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