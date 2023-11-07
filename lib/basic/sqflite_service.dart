import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BasicSqFLiteService {
  static const dbName = "myDatabase.db";
  static const dbVersion = 1;
  static const dbTable = "myTable";
  static const columnId = "id";
  static const columnName = "name";

  static final BasicSqFLiteService sqFLiteService = BasicSqFLiteService();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await openDB();
    return _database;
  }

  Future<Database> openDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: onCreate,
    );
  }

  Future onCreate(Database db, int version) {
    return db.execute(
      ''' 
      CREATE TABLE $dbTable (
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL
      )
       ''',
    );
  }

  // create a new table
  insertData(Map<String, dynamic> data) async {
    Database? db = await sqFLiteService.database;
    return await db!.insert(dbTable, data);
  }

  // read a table
  Future<List<Map<String, dynamic>>> getData() async {
    Database? db = await sqFLiteService.database;
    return await db!.query(dbTable);
  }

  // update a table
  Future<int> updateData(Map<String, dynamic> data) async {
    Database? db = await sqFLiteService.database;
    int id = data[columnId];

    return await db!.update(
      dbTable,
      data,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // delete table
  Future<int> deleteData(int id) async {
    Database? db = await sqFLiteService.database;
    return await db!.delete(
      dbTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
