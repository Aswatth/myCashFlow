import 'package:my_cash_flow/helpers/database-helper.dart';
import 'package:sqflite/sqflite.dart';

class PasswordDbHelper{
  final String tableName = "Password";

  final String _password = "password";//Column name

  static final PasswordDbHelper instance = PasswordDbHelper._privateConstructor();

  PasswordDbHelper._privateConstructor() {
    _init();
  }

  _init() async {
    //Create table if not exists
    String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName(
    $_password VARCHAR(16)
    )
    ''';

    Database db = await DatabaseHelper.instance.database;
    await db.execute(createTableQuery);
  }
  
  Future<String> getPassword()async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(tableName,);

    try{
      return PasswordModel.fromJson(data.first).password;
    }
    catch(exception){
      return "NO ELEMENT";
    }
  }

  Future<void> setPassword(String password) async{
    Database db = await DatabaseHelper.instance.database;
    PasswordModel passwordModel = PasswordModel(password: password);

    bool isNewUser = await checkIfNewUser();
    if(isNewUser){
      await db.update(tableName, passwordModel.toJson());
    }
    else{
      await db.update(tableName, passwordModel.toJson());
    }
  }

  Future<bool> checkIfNewUser()async{
    String storedPassword = await getPassword();
    if(storedPassword == "NO ELEMENT") {
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> validatePassword(String password)async{
    String storedPassword = await getPassword();
    if(password == storedPassword) {
      return true;
    }
    else{
      return false;
    }
  }
}

class PasswordModel{
  String password = "";

  PasswordModel({required this.password});

  PasswordModel.fromJson(Map<String, dynamic> json){
    password = json['password'];
  }

  Map<String,dynamic> toJson() => {
    'password': password
  };

}