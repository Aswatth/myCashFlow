import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/models/investment-model.dart';
import 'package:my_cash_flow/pages/base-page.dart';

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
            builder: (context) => BasePage(pageIndex: 2),
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
      body: ListView(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "Investment name",
              prefixIcon: Icon(Icons.savings, color: const Color(0xFF1C2536),),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(
                  color: Color(0xFF1C2536),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(
                  color: Color(0xFF1C2536),
                ),
              ),
            ),
            onChanged: (String value) {
              setState(() {
                investmentModel.investmentName = value;
              });
            },
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Invested amount",
              prefixIcon: Icon(Icons.attach_money, color: const Color(0xFF1C2536),),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(
                  color: Color(0xFF1C2536),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(
                  color: Color(0xFF1C2536),
                ),
              ),
            ),
            onChanged: (String? value) {
              setState(() {
                investmentModel.amountInvested =
                    value == null ? 0 : double.parse(value);
              });
            },
          ),
          Container(
            decoration: BoxDecoration(
                color: const Color(0xFF1C2536),
                borderRadius: BorderRadius.circular(20.0)),
            child: TextButton(
              onPressed: () {
                save();
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ].map((e) => Padding(padding: const EdgeInsets.all(10.0),child: e,)).toList(),
      ),
    );
  }
}