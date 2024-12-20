import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fitme_main/data/models/clothes_item.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'clothes.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE clothes(id INTEGER PRIMARY KEY, name TEXT, category TEXT, imagePath TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertClothesItem(ClothesItem item) async {
    final db = await DBHelper.database();
    await db.insert('clothes', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<ClothesItem>> getClothesItems() async {
    final db = await DBHelper.database();
    final List<Map<String, dynamic>> maps = await db.query('clothes');
    return List.generate(maps.length, (i) {
      return ClothesItem(
        id: maps[i]['id'],
        name: maps[i]['name'],
        category: maps[i]['category'],
        imagePath: maps[i]['imagePath'],
      );
    });
  }
}
