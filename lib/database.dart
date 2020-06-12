import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Item.dart';
import 'todolist.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB("SampleList");
    return _database;
  }

  initDB(String listName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE \"$listName\" ("
          "id INTEGER PRIMARY KEY,"
          "done INTEGER,"
          "title TEXT,"
          "description TEXT"
          ")");
    });
  }

  newItem(String listName, Item newItem) async {
    final db = await database;
    var res = await db.insert("\"$listName\"", newItem.toMap());
    print('inserted successfully!');
    return res;
  }

  Future<List<Item>> getAllItems(String listName) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query("\"$listName\"");
    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        done: maps[i]['done'],
        title: maps[i]['title'],
        description: maps[i]['description'],
      );
    });
  }

  Future<List<Todolist>> getAllTables() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT name FROM sqlite_master WHERE type = 'table'");
    return List.generate(maps.length, (i) {
      return Todolist(name: maps[i]['name']);
    });
  }

  update(String listName, Item item) async {
    final db = await database;
    print(item.title);
    var res = await db.update("\"$listName\"", item.toMap(),
        where: "id = ?", whereArgs: [item.id]);
    return res;
  }

  Future<void> deleteItem(String listName, int id) async {
    final db = await database;
    print('deleted successfully');
    return db.delete("\"$listName\"", where: "id = ?", whereArgs: [id]);
  }

  deleteAll(String listName) async {
    final db = await database;
    db.rawDelete("DELETE FROM \"$listName\"");
  }

  createList(String listName) async {
    final db = await database;
    await db.execute("CREATE TABLE \"$listName\" ("
        "id INTEGER PRIMARY KEY,"
        "done INTEGER,"
        "title TEXT,"
        "description TEXT"
        ")");
  }

  deleteList(String listName) async {
    final db = await database;
    await db.execute("DROP TABLE \"$listName\"");
  }
}
