import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/pages/accounts-page.dart';
import 'package:my_cash_flow/pages/base-page.dart';

class AccountCreationPage extends StatefulWidget {
  bool isNewUser = false;
  AccountCreationPage({Key? key,required this.isNewUser}) : super(key: key);

  @override
  _AccountCreationPageState createState() => _AccountCreationPageState();
}

class _AccountCreationPageState extends State<AccountCreationPage> {
  List<String> currencyList = ["INR", "USD"];

  AccountModel accountModel = AccountModel();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController currentBalanceController = TextEditingController();

  saveAccount() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AccountDbHelper.instance.insertAccount(accountModel).then((_) {
        if(widget.isNewUser) {
          //Clearing navigation stack and navigating to home page
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => BasePage(pageIndex: 0,)), (route)=>false);
        }
        else{
          //Navigation stack .... -> older Accounts Page -> Account creation page
          Navigator.pop(context); //Popping account creation page from stack
          Navigator.pop(context); //Popping older accounts page from stack

          //Navigation stack ..... -> newer Accounts Page
          Navigator.push(context, MaterialPageRoute(builder: (_) => AccountPage()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create new account"),
      ),
      body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: accountNameController,
                  decoration: const InputDecoration(
                      hintText: "Enter account name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Account name cannot be empty";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      accountModel.accountName = value!;
                    });
                  },
                ),
                TextFormField(
                  controller: currentBalanceController,
                  keyboardType: TextInputType.number,
                  decoration:
                  const InputDecoration(hintText: "Enter current balance"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Current balance cannot be empty";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      accountModel.currentBalance = double.parse(value!);
                    });
                  },
                ),
                DropdownButton(
                    value: accountModel.currency,
                    items:
                    currencyList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        accountModel.currency = value!;
                      });
                    }),
                TextButton(
                    onPressed: () {
                      saveAccount();
                    },
                    child: Text("Save"))
              ],
            ),
          )),
    );
  }
}
