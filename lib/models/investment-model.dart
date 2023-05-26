import 'package:sqflite/sqflite.dart';

import '../helpers/database-helper.dart';
import 'account-model.dart';

class InvestmentDbHelper{
  final String tableName = "Investment";

  final String _id = "id"; //Column name
  final String _investmentName = "investmentName";
  final String _amountInvested = "amountInvested";
  final String _accountId = "accountId";

  static final InvestmentDbHelper instance = InvestmentDbHelper._privateConstructor();

  InvestmentDbHelper._privateConstructor() {
    _init();
  }

  _init() async {
    //Create table if not exists
    String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName(
    $_id INTEGER PRIMARY KEY AUTOINCREMENT,
    $_investmentName TEXT,
    $_amountInvested REAL,
    $_accountId INTEGER,
    FOREIGN KEY($_accountId) REFERENCES ${AccountDbHelper.instance.tableName}(${AccountDbHelper.instance.id}) ON UPDATE CASCADE ON DELETE NO ACTION
    )
    ''';

    Database db = await DatabaseHelper.instance.database;
    await db.execute(createTableQuery);
  }

  Future<void> save(InvestmentModel investmentModel) async{
    Database db = await DatabaseHelper.instance.database;
    if(investmentModel.id != null){
      await db.update(tableName, investmentModel.toJson(), where: "$_id = ? AND $_accountId = ?", whereArgs: [investmentModel.id, investmentModel.accountId]);
    }
    else{
      await db.insert(tableName, investmentModel.toJson());
    }
  }

  Future<List<InvestmentModel>> getAll(int accountId) async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(tableName, where: '$_accountId = ?', whereArgs: [accountId]);
    return data.map((e) => InvestmentModel.fromJson(e)).toList();
  }

  Future<void> delete(int savingsId) async{
    Database db = await DatabaseHelper.instance.database;
    await db.delete(tableName, where: '$_id = ?', whereArgs: [savingsId]);
  }
}

class InvestmentModel{
  int? id;
  String investmentName = "";
  double amountInvested = 0;
  int? accountId;

  InvestmentModel();

  InvestmentModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    investmentName = json['investmentName'];
    amountInvested = json['amountInvested'];
    accountId = json['accountId'];
  }

  Map<String,dynamic> toJson() => {
    'id': id,
    'investmentName': investmentName,
    'amountInvested': amountInvested,
    'accountId': accountId
  };
}