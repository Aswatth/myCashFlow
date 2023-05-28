import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/models/transaction-model.dart';
import 'package:my_cash_flow/models/transactionTypeEnum.dart';
import 'package:my_cash_flow/pages/expense-chart.dart';

import '../helpers/globalData.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AccountModel account = AccountModel();

  double creditedAmount = 0;
  double debitedAmount = 0;

  getData() async {
    AccountModel? selectedAccount =
        await AccountDbHelper.instance.getSelectedAccount();

    if (selectedAccount != null) {
      account = selectedAccount;

      List<TransactionModel> transactions =
          await TransactionDbHelper.instance.getAll(account.id!);

      print("Transactions: ${transactions.length}");

      transactions.forEach((e) {
        if (e.transactionType == TransactionType.CREDIT) {
          creditedAmount += e.amount!;
        } else {
          debitedAmount += e.amount!;
        }
      });

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            color: const Color(0xFF1C2536),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total balance:",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "${account.currency} ${NumberFormatter.format(account.currentBalance)}",
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_circle_up,
                            color: Colors.greenAccent,
                          ),
                          Text(
                            "${account.currency} ${NumberFormatter.format(creditedAmount)}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_circle_down,
                            color: Colors.redAccent,
                          ),
                          Text(
                            "${account.currency} ${NumberFormatter.format(debitedAmount)}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: e,
                        ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              color: Color(0xFF1C2536),
              child: Center(
                child: Stack(
                    alignment: Alignment.center,
                    children: [Text("Expenses",style: TextStyle(color: Colors.white),), ExpenseChart()]),
              ),
            ),
          )
        ], //.map((e) => Padding(padding: const EdgeInsets.all(10.0),child: e,)).toList(),
      ),
    );
  }
}
