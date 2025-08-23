import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// ===== Leftovers Model =====
class Leftover {
  final int? id;
  final String name;
  final String amount;

  Leftover({this.id, required this.name, required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
    };
  }

  factory Leftover.fromMap(Map<String, dynamic> map) {
    return Leftover(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
    );
  }
}

// ===== Allergy Model =====
class Allergy {
  final int? id;
  final String name;

  Allergy({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Allergy.fromMap(Map<String, dynamic> map) {
    return Allergy(
      id: map['id'],
      name: map['name'],
    );
  }
}

// ===== Database Service =====
class DatabaseService {
  // ← これが必要！！
  static final DatabaseService instance = DatabaseService._init();

  static Database? _database;
  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("app.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE leftovers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        amount TEXT
      )
    ''');

    print('a\na\na\na\nLeftovers table created\na\na\na\na\na\na');

    await db.execute('''
      CREATE TABLE allergy(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    print('Allergy table created');
  }

  // ===== Leftovers CRUD =====

  // アイテムの追加
  Future<int> insertLeftover(Leftover leftover) async {
    final db = await instance.database;
    return await db.insert('leftovers', leftover.toMap());
  }

  // leftoverを入手
  Future<List<Leftover>> getLeftovers() async {
    final db = await instance.database;
    final result = await db.query('leftovers');
    return result.map((e) => Leftover.fromMap(e)).toList();
  }

  // leftovers の削除
  Future<int> deleteLeftover(int id) async {
    final db = await instance.database;
    return await db.delete(
      'leftovers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // leftovers に同じ名前が存在するか確認
  Future<bool> leftoverExists(String name) async {
    final db = await instance.database;
    final result = await db.query(
      'leftovers',
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

  // ===== Allergy CRUD =====

  // アイテムを追加
  Future<int> insertAllergy(Allergy allergy) async {
    final db = await instance.database;
    return await db.insert('allergy', allergy.toMap());
  }

  // Allergiesの情報を入手
  Future<List<Allergy>> getAllergy() async {
    final db = await instance.database;
    final result = await db.query('allergy');
    return result.map((e) => Allergy.fromMap(e)).toList();
  }

  // allergies の削除
  Future<int> deleteAllergy(int id) async {
    final db = await instance.database;
    return await db.delete(
      'allergy',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // leftovers に同じ名前が存在するか確認
  Future<bool> AllergyExists(String name) async {
    final db = await instance.database;
    final result = await db.query(
      'allergy',
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

}
