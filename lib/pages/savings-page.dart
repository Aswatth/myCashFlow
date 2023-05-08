import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';

import '../models/savings-model.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({Key? key}) : super(key: key);

  @override
  _SavingsPageState createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  List<SavingsModel> savingsModelList = [];

  double currentBalance = 0;
  String currency = "";

  getAll() async {
    AccountModel? accountModel =
        await AccountDbHelper.instance.getSelectedAccount();

    if (accountModel != null) {
      currentBalance = accountModel.currentBalance;

      currency = accountModel.currency;

      savingsModelList =
          await SavingsDbHelper.instance.getAll(accountModel.id!);

      setState(() {});
    }
  }

  delete(int savingsId) async {
    await SavingsDbHelper.instance.delete(savingsId);
    getAll();
  }

  double getCurrentAmount(int percentage) {
    return (percentage / 100) * currentBalance;
  }

  double normalizeValue(double currentValue, double targetValue) {
    return currentValue / targetValue;
  }

  Color getValueColor(double value) {
    if (value >= 1) return Colors.greenAccent;
    if (value >= 0.5) return Colors.blueAccent;
    return Colors.redAccent;
  }

  @override
  void initState() {
    super.initState();
    getAll();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: savingsModelList.length,
      itemBuilder: (context, index) {
        SavingsModel savingsModel = savingsModelList[index];
        return GestureDetector(
          onLongPress: () {
            delete(savingsModel.id!);
          },
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${savingsModel.savingName}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text("${savingsModel.percentage}% of ${currency} ${currentBalance.toStringAsFixed(2)}")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${currency} ${getCurrentAmount(savingsModel.percentage).toStringAsFixed(2)}",
                        style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Target: ${currency} ${savingsModel.targetAmount.toStringAsFixed(2)}",
                        style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  LinearProgressIndicator(
                    value: normalizeValue(
                        getCurrentAmount(savingsModel.percentage),
                        savingsModel.targetAmount),
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(getValueColor(
                        normalizeValue(
                            getCurrentAmount(savingsModel.percentage),
                            savingsModel.targetAmount))),
                  )
                ]
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: e,
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
