import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_cash_flow/models/transaction-model.dart';
import 'package:my_cash_flow/models/transactionTypeEnum.dart';
import 'package:my_cash_flow/pages/add-transaction-page.dart';

import '../models/account-model.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<TransactionModel> transactionList = [];

  String currency = "";

  NumberFormat formatter = NumberFormat("#,###,###");

  getTransactions() async {
    AccountModel? selectedAccount =
        await AccountDbHelper.instance.getSelectedAccount();

    if (selectedAccount != null) {
      transactionList =
          await TransactionDbHelper.instance.getAll(selectedAccount.id!);

      setState(() {
        currency = selectedAccount.currency;
      });
    }
  }

  deleteTransaction(int id) async {
    await TransactionDbHelper.instance.delete(id);
    await getTransactions();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTransactionPage(),
                    ));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
        itemCount: transactionList.length,
        itemBuilder: (context, index) {
          TransactionModel transactionModel = transactionList[index];
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Transform.scale(
                      scale: 1.5,
                      child: transactionModel.transactionType ==
                              TransactionType.CREDIT
                          ? Icon(
                              Icons.arrow_circle_up,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.arrow_circle_down,
                              color: Colors.red,
                            ),
                    ),
                    title: Text(transactionModel.comments),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "${DateFormat("dd-MMM-yyyy").format(transactionModel.transactionDate!).toString()}",style: TextStyle(fontWeight: FontWeight.w900),),
                        Text(transactionModel.categories.isNotEmpty
                            ? transactionModel.categories.join(', '):"",style: TextStyle(fontStyle: FontStyle.italic),),
                      ],
                    ),
                    trailing: Chip(label: Text("$currency ${formatter.format(transactionModel.amount!)}",style: TextStyle(color: Colors.white),),backgroundColor: const Color(0xFF1C2536),),
                    onLongPress: () {
                      deleteTransaction(transactionModel.id!);
                    },
                  ),
                ]
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: e,
                        ))
                    .toList(),
              ));
        },
      ),
    );
  }
}
