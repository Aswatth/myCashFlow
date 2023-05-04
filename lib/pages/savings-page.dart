import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';

import '../models/savings-model.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({Key? key}) : super(key: key);

  @override
  _SavingsPageState createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  List<SavingsModel> savingsModelList = [];

  double currentBalance = 0;

  getAll() async {
    int accountId = await AccountDbHelper.instance.getSelectedAccount();

    AccountModel? accountModel = await AccountDbHelper.instance.getAccount(accountId);
    if(accountModel != null){
      currentBalance = accountModel.currentBalance;
    }

    savingsModelList = await SavingsDbHelper.instance.getAll(accountId);
    setState(() {});
  }

  delete(int savingsId) async {
    await SavingsDbHelper.instance.delete(savingsId);
    getAll();
  }

  @override
  void initState() {
    super.initState();
    getAll();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: savingsModelList.length,
      itemBuilder: (context, index) {
        SavingsModel savingsModel = savingsModelList[index];
        return GestureDetector(
          onLongPress: (){
            delete(savingsModel.id!);
          },
          child: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text("Saving name:"),
                  trailing: Text("${savingsModel.savingName}"),
                ),
                ListTile(
                  title: Text("Percentage to save:"),
                  trailing: Text("${savingsModel.percentage}"),
                ),
                ListTile(
                  title: Text("Amount saved so far"),
                  trailing: Text("${currentBalance * (savingsModel.percentage / 100)}"),
                ),
                ListTile(
                  title: Text("Target amount:"),
                  trailing: Text("${savingsModel.targetAmount}"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
