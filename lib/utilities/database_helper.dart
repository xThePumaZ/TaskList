import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_list/models/tasks_model.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'task_list.db');
    return await openDatabase(
      path,
      version: 1, // Start with version 1
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Optional: for database migrations
      // onDowngrade: onDatabaseDowngradeDelete, // Optional
    );
  }

  // Called when the database is created for the first time.
  Future<void> _onCreate(Database db, int version) async {
    // Define your table creation statements here
    await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            isDone INTEGER NOT NULL DEFAULT 0,
            created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');
  }

  // Optional: Called if the database version on disk is lower than the version requested by openDatabase.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema migrations here if you change your table structure in future versions.
    // For example:
    // if (oldVersion < 2) {
    //   await db.execute("ALTER TABLE tasks ADD COLUMN dueDate TEXT;");
    // }
    // if (oldVersion < 3) {
    //   await db.execute("ALTER TABLE tasks ADD COLUMN priority INTEGER;");
    // }
    // Be careful with migrations to preserve user data.
  }

  // --- Your CRUD (Create, Read, Update, Delete) methods will go here ---
  // Example:
  Future<int> insertTask(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('tasks', row);
  }

  Future<List<Map<String, dynamic>>> queryAllTasks() async {
    Database db = await database;
    return await db.query('tasks');
  }

  Future<int> updateTask(Map<String, dynamic> row) async {
    throw ();
  }

  Future<int> deleteTask(int id) async {
    throw ();
  }

}