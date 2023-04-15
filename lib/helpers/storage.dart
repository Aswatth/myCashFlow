import 'dart:io';

import 'package:path_provider/path_provider.dart';

class StorageHelper{

  static final StorageHelper _storageHelper = StorageHelper._internal();

  factory StorageHelper()
  {
    return _storageHelper;
  }

  StorageHelper._internal();

  Future<String> get localPath async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> save(String dataToSave) async{
    String path = await localPath;
    try{
      File storedFile = File("$path/mycashflow.txt");
      await storedFile.writeAsString(dataToSave);
      return true;
    }
    catch(e){
      //Do thing
      return false;
    }
  }

  Future<String> readFile() async {
    String path = await localPath;
    try{
      File storedFile = File("$path/mycashflow.txt");
      return await storedFile.readAsString();
    }
    catch(e)
    {
      return "NOT-FOUND";
    }
  }
}
