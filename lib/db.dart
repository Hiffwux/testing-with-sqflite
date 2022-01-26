import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_1/model/todo_model.dart';

class DB {

  static final DB instance = DB._init();
  static Database? _database;
  DB._init();

  //получение бд
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = await getDatabasesPath();
    return openDatabase(join(path, 'todos.db'), onCreate: (database,version) async {
      await database.execute('''
      CREATE TABLE $tableName(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      subtitle TEXT,
      desc TEXT NOT NULL
      )
      ''');
    },
    version: 1);
  }

  //добавление сохранение заметок
  Future<int> insertTodo(TodoModel todos) async{
    final db = await _initDB();
    return await db.insert(tableName, todos.toJson());
  }

  Future<List<TodoModel>> retrieveTodo() async{
    final db = await instance.database;
    final List<Map<String, Object?>> retrieveResult = await db.query(tableName);
    return retrieveResult.map((e) => TodoModel.fromJson(e)).toList();
  }

  Future<int> updateTodo(TodoModel todo) async{
    final db = await instance.database;
    return db.update(tableName, todo.toJson(),whereArgs: [todo.id], where: 'id = ?');
  }

  Future<int> deleteTodo(int id) async {
    final db = await instance.database;
    return db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future closeDB() async{
    final db = await instance.database;
    db.close();
  }

}