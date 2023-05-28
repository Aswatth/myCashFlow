import 'dart:math';

import 'package:my_cash_flow/helpers/database-helper.dart';
import 'package:sqflite/sqflite.dart';

class AccountDbHelper {
  final String tableName = "Account";

  final String id = "id"; //Column name
  final String _accountName = "accountName";
  final String _currentBalance = "currentBalance";
  final String _currency = "currency";
  final String _isSelected = "isSelected";

  static final AccountDbHelper instance = AccountDbHelper._privateConstructor();

  AccountDbHelper._privateConstructor() {
    _init();
  }

  _init() async {
    //Create table if not exists
    String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName(
    $id INTEGER PRIMARY KEY AUTOINCREMENT,
    $_accountName TEXT,
    $_currentBalance REAL,
    $_currency TEXT,
    $_isSelected INTEGER
    )
    ''';

    Database db = await DatabaseHelper.instance.database;
    await db.execute(createTableQuery);
  }

  save(AccountModel accountModel) async {
    Database db = await DatabaseHelper.instance.database;

    List<AccountModel> existingAccountList = await getAllAccounts();
    if(existingAccountList.isEmpty) {
      //If there are no accounts select the newly created account
      accountModel.isSelected = true;
    }
    if(accountModel.id != null){
      await db.update(tableName, accountModel.toJson(), where: "$id = ?", whereArgs: [accountModel.id]);
    }
    else{
      await db.insert(tableName, accountModel.toJson());
    }
  }

  Future<AccountModel?> getAccount(int accountId) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> data = await db.query(
        tableName, where: '$id = ?', whereArgs: [accountId]);
    if (data.isNotEmpty) {
      return AccountModel.fromJson(data.first);
    }
    return null;
  }

  Future<int> getSelectedAccountId()async{
    AccountModel? account = await getSelectedAccount();
    if(account != null) {
      return account.id!;
    }
    return 0;
  }

  Future<AccountModel?> getSelectedAccount()async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> data = await db.query(tableName, where: '$_isSelected = ?', whereArgs: [1]);
    if(data.isNotEmpty){
      return AccountModel.fromJson(data.first);
    }
    return null;
  }
  
  Future<List<AccountModel>> getAllAccounts() async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> data = await db.query(tableName);
    return data.map((e) => AccountModel.fromJson(e)).toList();
  }

  selectAccount (int accountIdToSelect, int accountIdToDeselect) async{
    Database db = await DatabaseHelper.instance.database;

    AccountModel? accountModelToSelect = await getAccount(accountIdToSelect);
    AccountModel? accountModelToDeselect = await getAccount(accountIdToDeselect);

    if(accountModelToSelect != null && accountModelToDeselect != null){
      accountModelToSelect.isSelected = true;
      accountModelToDeselect.isSelected = false;

      await db.update(tableName, accountModelToSelect.toJson() ,where: '$id = ?', whereArgs: [accountIdToSelect]);
      await db.update(tableName, accountModelToDeselect.toJson() ,where: '$id = ?', whereArgs: [accountIdToDeselect]);
    }
  }

  deleteAccount (int accountId)async{
    Database db = await DatabaseHelper.instance.database;
    await db.delete(tableName, where: "$id = ?", whereArgs: [accountId]);
  }

}
class AccountModel {
  int? id;
  String accountName = "";
  double currentBalance = 0;
  String currency = "INR";
  bool isSelected = false;

  AccountModel();

  AccountModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    accountName = json['accountName'];
    currentBalance = json['currentBalance'];
    currency = json['currency'];
    isSelected = json['isSelected'] == 0 ? false : true;
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'accountName': accountName,
        'currentBalance': currentBalance,
        'currency': currency,
        'isSelected': isSelected ? 1 : 0
      };
}