import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/models/savings-model.dart';
import 'package:my_cash_flow/pages/base-page.dart';

class AddSavingsPage extends StatefulWidget {
  const AddSavingsPage({Key? key}) : super(key: key);

  @override
  _AddSavingsPageState createState() => _AddSavingsPageState();
}

class _AddSavingsPageState extends State<AddSavingsPage> {
  SavingsModel savingsModel = new SavingsModel();
  double _percentageToSave = 0;

  Future<void> saveToDb() async {
    int accountId = await AccountDbHelper.instance.getSelectedAccountId();

    savingsModel.accountId = accountId;

    SavingsDbHelper.instance.insert(savingsModel);
  }

  save(){
    saveToDb().then((value){
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
          title: Text("Add saving"),
        ),
        body: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Saving name",
                prefixIcon: Icon(Icons.savings,color: const Color(0xFF1C2536),),
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
                  savingsModel.savingName = value!;
                });
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Target amount",
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
              onChanged: (String value) {
                setState(() {
                  savingsModel.targetAmount = double.parse(value);
                });
              },
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(20.0)),
              //leading: Icon(Icons.percent),
              title: Text("% to save of current balance"),
              subtitle: Slider(
                activeColor: const Color(0xFF1C2536),
                value: _percentageToSave,
                onChanged: (double value) {
                setState(() {
                  _percentageToSave = value;
                  savingsModel.percentage = (_percentageToSave*100).toInt();
                });
              },),
              trailing: Text("${savingsModel.percentage}%"),
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
          ].map((e) => Padding(padding: const EdgeInsets.all(20.0),child: e,)).toList(),
        ),);
  }
}
