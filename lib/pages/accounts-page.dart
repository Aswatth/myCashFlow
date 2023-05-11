import 'package:flutter/material.dart';
import 'package:my_cash_flow/pages/account-creation-page.dart';

import '../models/account-model.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _selectedAccountId = 0;
  List<AccountModel> _accountModelList = [];

  fetchData() async {
    _accountModelList = await AccountDbHelper.instance.getAllAccounts();
    _selectedAccountId = await AccountDbHelper.instance.getSelectedAccountId();
    setState(() {});
  }

  selectAccount(int idToSelect, int idToDeselect) async {
    await AccountDbHelper.instance.selectAccount(idToSelect, idToDeselect);
    fetchData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accounts"),
      ),
      body: ListView.builder(
        itemCount: _accountModelList.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(_accountModelList[index].accountName),
              subtitle: Text(
                  "${_accountModelList[index].currency} ${_accountModelList[index].currentBalance}"),
              onTap: () {
                if (_selectedAccountId != (index + 1)) {
                  selectAccount(index + 1,_selectedAccountId);
                }
              },
              trailing: _accountModelList[index].isSelected
                  ? Chip(
                      label: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      backgroundColor: Colors.greenAccent,
                    )
                  : Container(
                      width: 1,
                      height: 1,
                    ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1C2536),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountCreationPage(
                  isNewUser: false,
                ),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
