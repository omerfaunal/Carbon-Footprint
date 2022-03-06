import 'package:karbon_ayak_izi/models/product.dart';
import 'package:sqflite/sqflite.dart';

class ProductDatabase {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      print("Creating new db");
      String _path = await getDatabasesPath() + "$_tableName.db";
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        print("Created a new db");
        return db.execute(
          "CREATE TABLE $_tableName("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "category STRING, date STRING"
          "emission REAL)",
        );
      });
    } catch (error) {
      throw error;
    }
  }

  static Future<int> insert(Product product) async {
    return await _db!.insert(_tableName, product.toJson());
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static delete(Product product) async {
    return await _db!
        .delete(_tableName, where: 'id=?', whereArgs: [product.id]);
  }

  static deleteAll() async {
    return await _db!.rawDelete("DELETE FROM $_tableName");
  }
}
