import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user_model.dart';

class DatabaseHelper {
  static final _databaseName = "agenda_user.db";
  static final _databaseVersion = 1;
  static final table = 'users';

  static final columnId = '_id';
  static final columnFirstName = 'firstName';
  static final columnLastName = 'lastName';
  static final columnEmail = 'email';
  static final columnPassword = 'password';
  static final columnGender = 'gender';
  static final columnBirthdate = 'birthdate';

  // make this a singleton class
  // DatabaseHelper._privateConstructor();
  // static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    // print("$table");
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    try {
      _database = await openDatabase(
        join(await getDatabasesPath(), _databaseName),
        onCreate: (db, version) {
          print("creating a new one");
          db.execute('''
           INSERT INTO $table (
             $columnId INTEGER PRIMARY KEY,
             $columnFirstName TEXT,
             $columnLastName TEXT,
             $columnEmail TEXT,
             $columnPassword TEXT,
             $columnGender INTEGER,
             $columnBirthdate TEXT
           )
         ''');
        },
        version: _databaseVersion,
      );
    } catch (e) {
      print(e);
    }
    // print(_database);
    return _database!;
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  static Future<int> insertUser(UserModel? userModel) async {
    return await _database?.insert(
          table,
          userModel!.toMap(),
        ) ??
        1;
  }

  Future<UserModel?> getLoginUser(String email, String password) async {
    print(_database);
    var dbClient = await database;
    print(dbClient);
    var res = await dbClient.rawQuery("SELECT * FROM users WHERE "
        "$columnEmail = '$email' AND "
        "$columnPassword = '$password'");

    if (res.length > 0) {
      return UserModel.fromMap(res.first);
    }

    return null;
  }

  Future<int> saveData(UserModel user) async {
    var dbClient = await database;
    var res = await dbClient.insert(table, user.toMap());
    return res;
  }
  // Future<void> insertUser(UserModel userModel) async {
  //   print("insert function called");
  //    await _database!.insert(table, userModel.toMap(),
  //        conflictAlgorithm: ConflictAlgorithm.replace);
  //  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  // Future<List<Map<String, dynamic>>> queryAllRows() async {
  //   Database db = await instance.database;
  //   return await db.query(table);
  // }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query: ");
    return await _database!.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  // Future<int?> queryRowCount() async {
  //   Database db = await instance.database;
  //   return Sqflite.firstIntValue(
  //       await db.rawQuery('SELECT COUNT(*) FROM $table'));
  // }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  // Future<int> update(Map<String, dynamic> row) async {
  //   Database db = await instance.database;
  //   int id = row[columnId];
  //   return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  // }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  // Future<int> delete(int id) async {
  //   Database db = await instance.database;
  //   return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  // }
}
