import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/models/savings-model.dart';
import 'package:my_cash_flow/pages/home-page.dart';

class AddSavingsPage extends StatefulWidget {
  const AddSavingsPage({Key? key}) : super(key: key);

  @override
  _AddSavingsPageState createState() => _AddSavingsPageState();
}

class _AddSavingsPageState extends State<AddSavingsPage> {
  SavingsModel savingsModel = new SavingsModel();
  double _percentageToSave = 0;

  Future<void> saveToDb() async {
    int accountId = await AccountDbHelper.instance.getSelectedAccount();

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
        appBar: AppBar(),
        body: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Enter saving name"),
              onChanged: (String? value) {
                setState(() {
                  savingsModel.savingName = value!;
                });
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter target amount"),
              onChanged: (String value) {
                setState(() {
                  savingsModel.targetAmount = double.parse(value);
                });
              },
            ),
            ListTile(
              leading: Text("${savingsModel.percentage}%"),
              title: Slider(
                value: _percentageToSave, onChanged: (double value) {
                setState(() {
                  _percentageToSave = value;
                  savingsModel.percentage = (value*100).toInt();
                });
              },),
            ),
            TextButton(
                onPressed: () {
                  save();
                },
                child: Text("Save"))
          ],
        ));
  }
}
