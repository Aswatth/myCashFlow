import 'package:flutter/material.dart';
import 'package:my_cash_flow/helpers/globals.dart';
import 'package:my_cash_flow/pages/add-edit-account-page.dart';

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
    print("Id to select: $idToSelect");
    print("Id to deselect: $idToDeselect");
    await AccountDbHelper.instance.selectAccount(idToSelect, idToDeselect);
    await fetchData();
  }

  deleteAccount(int accountId) async {
    if (_selectedAccountId == accountId) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Cannot delete selected account\nSelect another account before deleting this"),
        duration: Duration(seconds: 2),
      ));
    } else {
      await AccountDbHelper.instance.deleteAccount(accountId);
      fetchData();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accounts"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditAccountsPage(),
                    ));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
        itemCount: _accountModelList.length,
        itemBuilder: (context, index) {
          AccountModel accountModel = _accountModelList[index];
          return GestureDetector(
            onTap: () {
              //Edit
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddEditAccountsPage(existingAccountModel: accountModel),
                  ));
            },
            onDoubleTap: () {
              if (_selectedAccountId != accountModel.id) {
                selectAccount(accountModel.id!, _selectedAccountId);
              }
            },
            onLongPress: () {
              //Delete account
              deleteAccount(accountModel.id!);
            },
            child: ListTile(
                title: Text(accountModel.accountName),
                subtitle: Text(
                    "${accountModel.currency} ${NumberFormatter.format(accountModel.currentBalance)}"),
                trailing: accountModel.isSelected
                    ? Chip(
                        label: Text("SELECTED"),
                        labelStyle: TextStyle(color: Colors.white),
                        backgroundColor: const Color(0xFF1C2536),
                      )
                    : Container(
                        width: 1,
                        height: 1,
                      )),
          );
        },
      ),
    );
  }
}
