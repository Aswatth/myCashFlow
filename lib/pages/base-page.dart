import 'package:flutter/material.dart';
import 'package:my_cash_flow/pages/budget-page.dart';
import 'package:my_cash_flow/pages/home-page.dart';
import 'package:my_cash_flow/pages/profile-page.dart';
import 'package:my_cash_flow/pages/transaction-page.dart';

class BasePage extends StatefulWidget {
  int pageIndex = 0;

  BasePage({Key? key, required this.pageIndex}) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 0;

  List<Widget> _widgets = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
    //print(jsonEncode(widget.accountModel.toJson()));

    _widgets = <Widget>[
      HomePage(),
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
        backgroundColor: const Color(0xFF1C2536),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz), label: "Transactions"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.savings,
              ),
              label: "Budgets"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        selectedIconTheme: IconThemeData(
          color: const Color(0xFF1C2536),
        ),
        unselectedIconTheme: IconThemeData(
          color: const Color(0xFF1C2536),
        ),
        selectedItemColor: Color(0xFF1C2536),
        unselectedItemColor: Color(0xFF1C2536),
        onTap: (_) => setState(() {
          _selectedIndex = _;
        }),
      ),
    );
  }
}
