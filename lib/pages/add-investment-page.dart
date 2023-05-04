import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/models/investment-model.dart';
import 'package:my_cash_flow/pages/home-page.dart';

class AddInvestmentPage extends StatefulWidget {
  const AddInvestmentPage({Key? key}) : super(key: key);

  @override
  _AddInvestmentPageState createState() => _AddInvestmentPageState();
}

class _AddInvestmentPageState extends State<AddInvestmentPage> {
  InvestmentModel investmentModel = InvestmentModel();

  Future<void> saveToDb() async {
    int accountId = await AccountDbHelper.instance.getSelectedAccountId();

    investmentModel.accountId = accountId;

    InvestmentDbHelper.instance.insert(investmentModel);
  }

  save() {
    saveToDb().then((value) {
      Navigator.pop(context);
      Navigator.pop(context);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(pageIndex: 2),
          ));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add investment"),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: "Investment name"),
            onChanged: (String value) {
              setState(() {
                investmentModel.investmentName = value;
              });
            },
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Invested amount"),
            onChanged: (String? value) {
              setState(() {
                investmentModel.amountInvested =
                    value == null ? 0 : double.parse(value);
              });
            },
          ),
          TextButton(
              onPressed: () {
                save();
              },
              child: Text("Save"))
        ],
      ),
    );
  }
}