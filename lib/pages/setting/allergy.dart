import 'package:flutter/material.dart';
import 'package:menu_weather/database/database_service.dart';
import 'package:menu_weather/utils/utils.dart';

class AllergyListPage extends StatefulWidget {
  const AllergyListPage({super.key});

  @override
  State<AllergyListPage> createState() => _AllergyListPageState();
}

class _AllergyListPageState extends State<AllergyListPage> {
  late Future<List<Allergy>> _allergy;

  @override
  void initState() {
    super.initState();
    _allergy = DatabaseService.instance.getAllergy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('アレルギー一覧',
                  style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                ),
                Container(
                  width: screenWidth(context) * 0.8,
                  height: screenHeight(context) * 0.8,
                  padding: EdgeInsets.fromLTRB(30.0, 15.0, 15.0, 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20) 
                  ),           
                  child: FutureBuilder<List<Allergy>>(
                    future: _allergy,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final Allergy = snapshot.data!;
                      if (Allergy.isEmpty) {
                        return const Center(child: Text("登録なし",
                          style: TextStyle(fontSize: 25),
                        ));
                      }
                      return ListView.builder(
                        itemCount: Allergy.length,
                        itemBuilder: (context, index) {
                          final item = Allergy[index];
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
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.blue),
                                onPressed: () async {
                                  await DatabaseService.instance.deleteAllergy(item.id!);
                                  setState(() {
                                    _allergy = DatabaseService.instance.getAllergy(); // リロード
                                  });
                                },
                              ),
                            )
                          );
                        },
                      );
                    },
                  ),
                ),
                
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