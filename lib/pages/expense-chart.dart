import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/models/transaction-category.dart';
import 'package:my_cash_flow/models/transaction-model.dart';

class ExpenseChart extends StatefulWidget {
  const ExpenseChart({Key? key}) : super(key: key);

  @override
  _ExpenseChartState createState() => _ExpenseChartState();
}

class _ExpenseChartState extends State<ExpenseChart> {
  
  List<PieChartSectionData> _pieChartData = [];
  
  initChart() async {
    int selectedAccountId = await AccountDbHelper.instance.getSelectedAccountId();

    List<Map<String,dynamic>> categorizedAmounts = await TransactionDbHelper.instance.getCategorizedTransactions(selectedAccountId);

    setState(() {
      double expenseSum = 0;
      for (var element in categorizedAmounts) {
        expenseSum += element['AMOUNT'];
      }

      for (var element in categorizedAmounts) {
        _pieChartData.add(PieChartSectionData(
            radius: 100,
            color: categoryList.where((w) => w.name == element['category']).first.color,
            badgeWidget: Icon(categoryList.where((w) => w.name == element['category']).first.icon,color: Colors.white,),
            badgePositionPercentageOffset: 0.7,
            titleStyle: TextStyle(color: Colors.white),
            value: (element['AMOUNT']/ expenseSum) * 100,
            title: "${element['category']} ${((element['AMOUNT']/ expenseSum) * 100).toStringAsFixed(0)}%"
        ));
      }
    });
  }
  
  @override
  void initState() {
    super.initState();
    initChart();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: PieChart(
          PieChartData(
              sections: _pieChartData
          )
      ),
    );
  }
}
