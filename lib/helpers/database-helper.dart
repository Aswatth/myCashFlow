import 'dart:io';

import 'package:my_cash_flow/models/password-model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  factory DatabaseHelper(){
    return instance;
  }
  DatabaseHelper._privateConstructor(){
    _initDB();
  }

  final String dbName = "myCashFlow.db";
  final _version = 1;

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory dbPath = await getApplicationDocumentsDirectory();
    final path = "${dbPath.path}/$dbName";

    Database db =  await openDatabase(path,version: _version,onCreate: _onCreate());
    await db.execute('PRAGMA foreign_keys = ON');
    return db;
  }
  _onCreate(){
    PasswordDbHelper.instance;// Instantiate password table
  }
}