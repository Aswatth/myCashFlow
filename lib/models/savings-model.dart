
import 'package:sqflite/sqflite.dart';

import '../helpers/database-helper.dart';
import 'account-model.dart';

class SavingsDbHelper{
  final String tableName = "Savings";

  final String _id = "id"; //Column name
  final String _savingName = "savingName";
  final String _percentage = "percentage";
  final String _targetAmount = "targetAmount";
  final String _accountId = "accountId";

  static final SavingsDbHelper instance = SavingsDbHelper._privateConstructor();

  SavingsDbHelper._privateConstructor() {
    _init();
  }

  _init() async {
    //Create table if not exists
    String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName(
    $_id INTEGER PRIMARY KEY AUTOINCREMENT,
    $_savingName TEXT,
    $_percentage INT,
    $_targetAmount REAL,
    $_accountId INTEGER,
    FOREIGN KEY($_accountId) REFERENCES ${AccountDbHelper.instance.tableName}(${AccountDbHelper.instance.id}) ON UPDATE CASCADE ON DELETE NO ACTION
    )
    ''';

    Database db = await DatabaseHelper.instance.database;
    await db.execute(createTableQuery);
  }

  Future<void> insert(SavingsModel savingsModel) async{
    Database db = await DatabaseHelper.instance.database;
    await db.insert(tableName, savingsModel.toJson());
  }

  Future<List<SavingsModel>> getAll(int accountId) async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(tableName, where: '$_accountId = ?', whereArgs: [accountId]);
    return data.map((e) => SavingsModel.fromJson(e)).toList();
  }

  Future<void> delete(int savingsId) async{
    Database db = await DatabaseHelper.instance.database;
    await db.delete(tableName, where: '$_id = ?', whereArgs: [savingsId]);
  }
}

class SavingsModel{
  int? id;
  String savingName = "";
  int percentage = 0;
  double targetAmount = 0;
  int? accountId;

  SavingsModel();

  SavingsModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    savingName = json['savingName'];
    percentage = json['percentage'];
    targetAmount = json['targetAmount'];
    accountId = json['accountId'];
  }

  Map<String,dynamic> toJson() => {
    'id': id,
    'savingName': savingName,
    'percentage': percentage,
    'targetAmount': targetAmount,
    'accountId': accountId
  };
}