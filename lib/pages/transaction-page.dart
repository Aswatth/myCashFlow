import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  getTransactions() async {
    int selectedAccountId = await AccountDbHelper.instance.getSelectedAccount();
    List<TransactionModel> data =
        await TransactionDbHelper.instance.getAll(selectedAccountId);

    setState(() {
      transactionList = data;
    });
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
          return Slidable(
            endActionPane: ActionPane(
              motion: const BehindMotion(),
              children: [
                SlidableAction(
                    icon: Icons.delete,
                    backgroundColor: Colors.redAccent,
                    onPressed: (_) {
                      deleteTransaction(transactionList[index].id!);
                    }),
              ],
            ),
            child: ListTile(
              title: Text(transactionModel.amount.toString()),
              subtitle: Text(transactionModel.transactionDate.toString()),
              trailing:
                  transactionModel.transactionType == TransactionType.CREDIT
                      ? const Text("CREDIT")
                      : const Text("DEBIT"),
            ),
          );
        },
      ),
    );
  }
}
