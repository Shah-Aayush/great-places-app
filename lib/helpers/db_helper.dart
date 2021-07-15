import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath =
        await sql.getDatabasesPath(); //get the database path if stored.
    return sql.openDatabase(
      path.join(
          dbPath, 'places.db'), //go to file in path named as places.db file.
      //if places.db is not created then it will create one!
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)'); //REAL is like a DOUBLE for SQL!
      }, //if database is not present then we can run this function!
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm
          .replace, //if the id is already present then we will override/replace  the exisitng data.
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table); //returns list of maps.
  }
}
