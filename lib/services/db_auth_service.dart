import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tugas_harian_app/model/user_model.dart';

class DBAuthService {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<void> initializeDB() async {
    await db;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'login.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  Future<int> registerUser(UserModel user) async {
    var dbClient = await db;
    return await dbClient.insert('users', user.toMap());
  }

  Future<UserModel?> loginUser(String email, String password) async {
    var dbClient = await db;
    var result = await dbClient.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }

    return null;
  }
}
