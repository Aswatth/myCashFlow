import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  AccountModel account = AccountModel();

  getAccount() async {
    AccountModel? selectedAccount = await AccountDbHelper.instance.getSelectedAccount();
    if(selectedAccount != null){
      setState(() {
        account = selectedAccount;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Center(
          child: Text("Current balance: ${account.currency} ${account.currentBalance}"),
        ),
      ),
    );
  }
}
