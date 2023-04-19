import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/pages/budget-page.dart';
import 'package:my_cash_flow/pages/profile-page.dart';
import 'package:my_cash_flow/pages/transaction-page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  List<Widget> _widgets = [];

  @override
  void initState() {
    super.initState();

    //print(jsonEncode(widget.accountModel.toJson()));

    _widgets = <Widget>[
      Center(child: Text("This is a home page ")),
      TransactionPage(),
      BudgetPage(),
      ProfilePage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgets[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Transactions"),
          BottomNavigationBarItem(icon: Icon(Icons.savings), label: "Budgets"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (_)=>setState(() {
          _selectedIndex = _;
        }),
      ),
    );
  }
}
