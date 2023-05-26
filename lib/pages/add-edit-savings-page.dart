import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/models/savings-model.dart';
import 'package:my_cash_flow/pages/base-page.dart';

class AddEditSavingsPage extends StatefulWidget {
  SavingsModel? existingSavingsModel;
  AddEditSavingsPage({Key? key, this.existingSavingsModel}) : super(key: key);

  @override
  _AddEditSavingsPageState createState() => _AddEditSavingsPageState();
}

class _AddEditSavingsPageState extends State<AddEditSavingsPage> {
  SavingsModel savingsModel = SavingsModel();
  
  TextEditingController _savingNameController = TextEditingController();
  int _percentageToSave = 0;
  TextEditingController _savingTargetAmountController = TextEditingController();
  
  save()async{
    int accountId = await AccountDbHelper.instance.getSelectedAccountId();

    savingsModel.savingName = _savingNameController.text;
    savingsModel.targetAmount = double.parse(_savingTargetAmountController.text);
    savingsModel.percentage = _percentageToSave;
    
    savingsModel.accountId = accountId;
    
    SavingsDbHelper.instance.save(savingsModel).then((value){
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
    
    if(widget.existingSavingsModel != null){
      savingsModel = widget.existingSavingsModel!;
      
      _savingNameController.text = savingsModel.savingName;
      _percentageToSave = savingsModel.percentage;
      _savingTargetAmountController.text = savingsModel.targetAmount.toString();
    }
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
              controller: _savingNameController,
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
                  _savingNameController.text = value ?? "";
                  _savingNameController.selection = TextSelection.collapsed(offset: _savingNameController.text.length);
                });
              },
            ),
            TextField(
              controller: _savingTargetAmountController,
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
                  _savingTargetAmountController.text = value ?? "";
                  _savingTargetAmountController.selection = TextSelection.collapsed(offset: _savingTargetAmountController.text.length);
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
                value: (_percentageToSave/100).toDouble(),
                onChanged: (double value) {
                setState(() {
                  _percentageToSave = (value*100).toInt();
                });
              },),
              trailing: Text("$_percentageToSave%"),
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