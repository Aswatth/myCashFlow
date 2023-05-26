import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/pages/add-edit-investment-page.dart';
import 'package:my_cash_flow/pages/add-savings-page.dart';
import 'package:my_cash_flow/pages/investment-page.dart';
import 'package:my_cash_flow/pages/savings-page.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {

  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Budgets"),
          actions: [
            IconButton(onPressed: (){
              AccountDbHelper.instance.getSelectedAccountId().then((value) {
                if(value == 0){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No account found!"),));
                }
                else{
                  if(_selectedTabIndex == 0){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddSavingsPage(),));
                  }
                  else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditInvestmentPage(),));
                  }
                }
              });
            }, icon: Icon(Icons.add))
          ],
          bottom: TabBar(
            tabs: [
              Text("Savings"),
              Text("Investments"),
            ].map((e) => Padding(padding: const EdgeInsets.all(10.0),child: e,)).toList(),
            onTap: (index){
              setState(() {
                _selectedTabIndex = index;
              });
            },
          ),
        ),
        body: TabBarView(
          children: [
            SavingsPage(),
            InvestmentPage()
          ],
        ),
      ),
    );
  }
}
