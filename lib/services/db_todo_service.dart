import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tugas_harian_app/model/todo_model.dart';

class TodoDBService {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        scheduledTime TEXT
      )
    ''');
  }

  Future clearAllTodos() async {
    var dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM todos');
  }

  Future<int> insertTodo(TodoModel todo) async {
    var dbClient = await db;
    return await dbClient.insert('todos', todo.toMap());
  }

  Future<List<TodoModel>> getTodos() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('todos');
    return List.generate(maps.length, (i) {
      return TodoModel.fromMap(maps[i]);
    });
  }

  Future<int> updateTodo(TodoModel todo) async {
    var dbClient = await db;
    return await dbClient.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> deleteTodo(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
