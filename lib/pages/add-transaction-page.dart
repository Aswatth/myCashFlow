import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/models/transaction-model.dart';
import 'package:my_cash_flow/models/transactionTypeEnum.dart';
import 'package:my_cash_flow/pages/base-page.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  TransactionType _selectedTransactionType = TransactionType.CREDIT;

  TransactionModel transactionModel = TransactionModel();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  saveTransaction() async {
    int selectedAccountId = await AccountDbHelper.instance.getSelectedAccountId();
    transactionModel.transactionType = _selectedTransactionType;
    transactionModel.accountId = selectedAccountId;

    //print(transactionModel.toJson());
    TransactionDbHelper.instance.insert(transactionModel).then((value){
      Navigator.pop(context); //Popping add transaction page
      Navigator.pop(context); //Popping old transaction page

      Navigator.push(context, MaterialPageRoute(builder: (context) => BasePage(pageIndex: 1),));
    });
    /*if(_formKey.currentState!.validate()){

    }*/
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add transaction"),
      ),
      body: Column(
        children: [
          Form(child:
            Column(
              children: [
                ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: DateTimePicker(
                      //key: _formKey,
                      type: DateTimePickerType.dateTime,
                      dateMask: "dd-MMM-yyyy",
                      firstDate: DateTime(1999),
                      lastDate: DateTime(2100),
                      validator: (value){
                        if(value == null || value.isEmpty) {
                          return "Date cannot be empty";
                        }
                        return null;
                      },
                      onChanged: (String? _) {
                        setState(() {
                          transactionModel.transactionDate = DateTime.parse(_!);
                          print(transactionModel.transactionDate);
                        });
                      },
                    )),
                ListTile(
                  leading: Icon(Icons.currency_exchange),
                  title: TextFormField(
                    //key: _formKey,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "Amount"),
                    validator: (String? value){
                      if(value == null || value.isEmpty) {
                        return "Amount cannot be empty";
                      }
                      return null;
                    },
                    onChanged: (_) {
                      transactionModel.amount = double.parse(_);
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.comment),
                  title: TextFormField(
                    //key: _formKey,
                    keyboardType: TextInputType.text,
                    maxLength: 25,
                    decoration: InputDecoration(hintText: "Comments"),
                    onChanged: (_) {
                      transactionModel.comments = _;
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.account_balance),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionChip(
                        label: Text("Credit"),
                        onPressed: () {
                          setState(() {
                            _selectedTransactionType = TransactionType.CREDIT;
                          });
                        },
                        backgroundColor:
                        _selectedTransactionType == TransactionType.CREDIT
                            ? Colors.greenAccent
                            : Colors.grey,
                      ),
                      ActionChip(
                        label: Text("Debit"),
                        onPressed: () {
                          setState(() {
                            _selectedTransactionType = TransactionType.DEBIT;
                          });
                        },
                        backgroundColor:
                        _selectedTransactionType == TransactionType.DEBIT
                            ? Colors.greenAccent
                            : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ),
          TextButton(
              onPressed: () {
                saveTransaction();
              },
              child: Text("Save"))
        ],
      ),
    );
  }
}
