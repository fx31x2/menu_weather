import 'package:flutter/material.dart';
import 'package:menu_weather/database/database_service.dart';
import 'package:menu_weather/utils/utils.dart';

class LeftoversListPage extends StatefulWidget {
  const LeftoversListPage({super.key});

  @override
  State<LeftoversListPage> createState() => _LeftoversListPageState();
}

class _LeftoversListPageState extends State<LeftoversListPage> {
  late Future<List<Leftover>> _leftovers;

  @override
  void initState() {
    super.initState();
    _leftovers = DatabaseService.instance.getLeftovers();
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
                Text('余りもの一覧',
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
                  child: FutureBuilder<List<Leftover>>(
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
                                  setState(() {
                                    _leftovers = DatabaseService.instance.getLeftovers(); // リロード
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