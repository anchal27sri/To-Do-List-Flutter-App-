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
    _database = await initDB("Database");
    return _database;
  }

  initDB(String dbName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $dbName ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "color TEXT"
          ")");
    });
  }

  Future<List<Todolist>> getAllTables() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT id,name,color FROM Database ORDER BY id");
    // print(maps.length);
    if (maps.length > 0) {
      return List.generate(maps.length, (i) {
        // print(i);
        String nm = maps[i]['name'];
        // print(nm);
        return Todolist(id: maps[i]['id'], name: nm, color: maps[i]['color']);
      });
    } else {
      // print('bingo');
      return [];
    }
  }

  createList(String listName,int l) async {
    // print('bingo');
    final db = await database;
    // int rand = random.nextInt(1000);
    // print('generating random: $rand');
    Todolist temp =
        Todolist(id: l, name: listName, color: 'Blue');
    await db.insert("Database", temp.toMap());
    await db.execute("CREATE TABLE \"$listName\" ("
        "id INTEGER PRIMARY KEY,"
        "done INTEGER,"
        "title TEXT,"
        "description TEXT"
        ")");
  }

  updateList(Todolist list) async {
    final db = await database;
    await db.update("Database", list.toMap(),
        where: "id = ?", whereArgs: [list.id]);
  }

  Future<List<Item>> getAllItems(String listName) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query("\"$listName\"",orderBy: "id");
    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        done: maps[i]['done'],
        title: maps[i]['title'],
        description: maps[i]['description'],
      );
    });
  }

  newItem(String listName, Item newItem) async {
    final db = await database;
    await db.insert("\"$listName\"", newItem.toMap());
    // print('inserted successfully!');
    // return res;
  }

  updateItem(String listName, Item item) async {
    final db = await database;
    // print(item.title);
    await db.update("\"$listName\"", item.toMap(),
        where: "id = ?", whereArgs: [item.id]);
  }

  Future<void> deleteItem(String listName, int id) async {
    final db = await database;
    // print('deleted successfully');
    db.delete("\"$listName\"", where: "id = ?", whereArgs: [id]);
  }

  deleteAll(String listName) async {
    final db = await database;
    db.rawDelete("DELETE FROM \"$listName\"");
  }

  deleteList(String listName,int id) async {
    final db = await database;
    // print("deleting: $listName , id: $id");
    await db.delete("Database",where: "id = ?",whereArgs: [id]);
    // print('deleted $listName entry in Database');
    await db.execute("DROP TABLE \"$listName\"");
    // print('deleted the talbe $listName');
  }
}

//The entry in database are not in quotes
// But the names of the table are in quotes