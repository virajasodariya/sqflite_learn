import 'dart:developer';

import 'package:sqflite/sqflite.dart';

class SqFLiteServiceAdvance {
  static const dbName = "myDatabase.db";
  static const dbVersion = 1;
  static const dbTable = "items";
  static const id = "id";
  static const title = "title";
  static const description = "description";

  static Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE $dbTable (
    $id INTEGER PRIMARY KEY,
    $title TEXT,
    $description TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  static Future<Database> db() async {
    return openDatabase(
      dbTable,
      version: dbVersion,
      onCreate: (Database database, int version) async {
        await createTable(database);
      },
    );
  }

  static Future<int> createData(String title, String? description) async {
    final db = await SqFLiteServiceAdvance.db();

    final data = {
      "title": title,
      "description": description,
    };

    final id = await db.insert(
      dbTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  static Future<List<Map<String, dynamic>>> readData() async {
    final db = await SqFLiteServiceAdvance.db();

    return db.query(dbTable, orderBy: id);
  }

  static Future<List<Map<String, dynamic>>> readOneData() async {
    final db = await SqFLiteServiceAdvance.db();

    return db.query(
      dbTable,
      where: "$id = ?",
      whereArgs: [id],
      limit: 1,
    );
  }

  static Future<int> updateData(int currentId, String title, String? description) async {
    final db = await SqFLiteServiceAdvance.db();

    final data = {
      "title": title,
      "description": description,
      "createdAt": DateTime.now().toString()
    };

    final result = db.update(
      dbTable,
      data,
      where: "$id = ?",
      whereArgs: [currentId],
    );

    return result;
  }

  static Future<void> deleteData(int currentId) async {
    final db = await SqFLiteServiceAdvance.db();
    try {
      await db.delete(
        dbTable,
        where: "$id = ?",
        whereArgs: [currentId],
      );
    } catch (e) {
      log("Something went wrong when trying to delete data $e");
    }
  }
}
