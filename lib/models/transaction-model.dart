
import 'package:intl/intl.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/models/transactionTypeEnum.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/database-helper.dart';

class TransactionDbHelper{
  final String tableName = "TransactionTable";

  final String _id = "id"; //Column name
  final String _transactionDate = "transactionDate";
  final String _amount = "amount";
  final String _comments = "comments";
  final String _category = "category";
  final String _transactionType = "transactionType";
  final String _accountId = "accountId";

  static final TransactionDbHelper instance = TransactionDbHelper._privateConstructor();

  TransactionDbHelper._privateConstructor() {
    _init();
  }

  _init() async {
    //Create table if not exists
    String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName(
    $_id INTEGER PRIMARY KEY AUTOINCREMENT,
    $_transactionDate TEXT,
    $_amount REAL,
    $_comments TEXT,
    $_category TEXT,
    $_transactionType INTEGER,
    $_accountId INTEGER,
    FOREIGN KEY($_accountId) REFERENCES ${AccountDbHelper.instance.tableName}(${AccountDbHelper.instance.id}) ON UPDATE CASCADE ON DELETE NO ACTION
    )
    ''';

    Database db = await DatabaseHelper.instance.database;
    await db.execute(createTableQuery);
  }

  Future<void> insert(TransactionModel transactionModel) async {
    Database db = await DatabaseHelper.instance.database;
    await db.insert(tableName, transactionModel.toJson());
  }

  Future<List<TransactionModel>> getAll(int accountId) async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(tableName, where: '$_accountId = ?', whereArgs: [accountId]);
    return data.map((e) => TransactionModel.fromJson(e)).toList();
  }

  Future<List<TransactionModel>> getDebitTransactions(int accountId) async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(tableName, where: '$_accountId = ? AND $_transactionType = ?', whereArgs: [accountId,0]);
    return data.map((e) => TransactionModel.fromJson(e)).toList();
  }

  Future<List<Map<String,dynamic>>> getCategorizedTransactions(int accountId)async{

    List<Map<String,double>> categorizedAmounts = [];

    Database db = await DatabaseHelper.instance.database;
    return await db.rawQuery("SELECT ${_category}, SUM(${_amount}) AS AMOUNT FROM ${tableName} WHERE ${_transactionType} = 0 GROUP BY ${_category}");
  }

  Future<void> delete(int transactionId) async{
    Database db = await DatabaseHelper.instance.database;
    await db.delete(tableName, where: '$_id = ?', whereArgs: [transactionId]);
  }
}

class TransactionModel{
  int? id;
  DateTime? transactionDate;
  double? amount;
  String category = "";
  String comments = "";
  TransactionType? transactionType;
  int? accountId;

  TransactionModel();

  TransactionModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    transactionDate = DateFormat('dd-MMM-yyy').parse(json['transactionDate']);
    amount = json['amount'];
    comments = json['comments'];
    category = json['category'];
    transactionType = json['transactionType'] == 1?TransactionType.CREDIT:TransactionType.DEBIT;
    accountId = json['accountId'];
  }

  Map<String,dynamic> toJson() => {
    'id': id,
    'transactionDate': DateFormat('dd-MMM-yyyy').format(transactionDate!).toString(),
    'amount': amount,
    'comments': comments,
    'category': category,
    'transactionType': transactionType == TransactionType.CREDIT?1:0,
    'accountId': accountId
  };
}