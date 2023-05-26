import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/pages/accounts-page.dart';
import 'package:my_cash_flow/pages/base-page.dart';

class AddEditAccountsPage extends StatefulWidget {
  AccountModel? existingAccountModel;
  AddEditAccountsPage({Key? key, this.existingAccountModel}) : super(key: key);

  @override
  _AddEditAccountsPageState createState() => _AddEditAccountsPageState();
}

class _AddEditAccountsPageState extends State<AddEditAccountsPage> {

  AccountModel accountModel = AccountModel();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _accountNameController = TextEditingController();
  TextEditingController _currentBalanceController = TextEditingController();
  TextEditingController _currencyController = TextEditingController();

  saveAccount() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AccountDbHelper.instance.save(accountModel).then((_) {
        if(widget.existingAccountModel != null){
          Navigator.pop(context); //Popping account creation page from stack
          Navigator.pop(context); //Popping older accounts page from stack

          //Navigation stack ..... -> newer Accounts Page
          Navigator.push(context, MaterialPageRoute(builder: (_) => AccountPage()));
        }
        else{
          //Clearing navigation stack and navigating to home page
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => BasePage(pageIndex: 0,)), (route)=>false);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if(widget.existingAccountModel != null){
      accountModel = widget.existingAccountModel!;
      _accountNameController.text = accountModel.accountName;
      _currentBalanceController.text = accountModel.currentBalance.toString();
      _currencyController.text = accountModel.currency;
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
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _accountNameController,
                  decoration: const InputDecoration(
                    hintText: "Enter account name",
                    prefixIcon: Icon(Icons.account_balance, color: Color(0xFF1C2536),),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(
                        color: Color(0xFF1C2536),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(
                        color: Color(0xFF1C2536),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Account name cannot be empty";
                    }
                    return null;
                  },
                  onChanged: (value){
                    setState(() {
                      _accountNameController.text = value;
                      _accountNameController.selection = TextSelection.collapsed(offset: _accountNameController.text.length);
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      accountModel.accountName = _accountNameController.text;
                    });
                  },
                ),
                TextFormField(
                  controller: _currentBalanceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Enter current balance",
                    prefixIcon: Icon(Icons.attach_money,color: Color(0xFF1C2536),),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(
                        color: Color(0xFF1C2536),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(
                        color: Color(0xFF1C2536),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Current balance cannot be empty";
                    }
                    return null;
                  },
                  onChanged: (value){
                    setState(() {
                      _currentBalanceController.text = value;
                      _currentBalanceController.selection = TextSelection.collapsed(offset: _currentBalanceController.text.length);
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      accountModel.currentBalance = double.parse(_currentBalanceController.text);
                    });
                  },
                ),
                TextFormField(
                  controller: _currencyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Enter currency to use",
                    prefixIcon: Icon(Icons.currency_exchange,color: Color(0xFF1C2536),),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(
                        color: Color(0xFF1C2536),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(
                        color: Color(0xFF1C2536),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Currency cannot be empty";
                    }
                    return null;
                  },
                  onChanged: (value){
                    setState(() {
                      _currencyController.text = value.toUpperCase();
                      _currencyController.selection = TextSelection.collapsed(offset: _currencyController.text.length);
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      accountModel.currency = _currencyController.text;
                    });
                  },
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color(0xFF1C2536),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: TextButton(
                    onPressed: () {
                      saveAccount();
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ].map((e) => Padding(padding: const EdgeInsets.all(10.0),child: e,)).toList(),
            ),
          )),
    );
  }
}
