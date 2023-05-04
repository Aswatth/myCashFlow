import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/models/transaction-model.dart';
import 'package:my_cash_flow/models/transactionTypeEnum.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AccountModel account = AccountModel();

  double creditedAmount = 0;
  double debitedAmount = 0;

  NumberFormat formatter = NumberFormat("#,##,###");

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
                    "${account.currency} ${account.currentBalance.toStringAsFixed(2)}",
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
                              "${account.currency} ${formatter.format(creditedAmount)}", style: TextStyle(color: Colors.white),),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_circle_down,
                            color: Colors.redAccent,
                          ),
                          Text(
                              "${account.currency} ${formatter.format(debitedAmount)}", style: TextStyle(color: Colors.white),),
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
          const Expanded(
            flex: 2,
            child: Card(
              color: Color(0xFF1C2536),
              child: Center(child: Text("Graph here")),
            ),
          )
        ], //.map((e) => Padding(padding: const EdgeInsets.all(10.0),child: e,)).toList(),
      ),
    );
  }
}
