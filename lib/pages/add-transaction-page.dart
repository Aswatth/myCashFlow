import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
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
    int selectedAccountId =
        await AccountDbHelper.instance.getSelectedAccountId();
    transactionModel.transactionType = _selectedTransactionType;
    transactionModel.accountId = selectedAccountId;

    //print(transactionModel.toJson());
    TransactionDbHelper.instance.insert(transactionModel).then((value) {
      Navigator.pop(context); //Popping add transaction page
      Navigator.pop(context); //Popping old transaction page

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BasePage(pageIndex: 1),
          ));
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
        title: const Text("Add transaction"),
      ),
      body: Form(
          child: ListView(
        children: [
          DateTimePicker(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.calendar_today),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(
                    color: Color(0xFF1C2536),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(
                    color: Color(0xFF1C2536),
                  )),
            ),
            //key: _formKey,
            type: DateTimePickerType.date,
            dateMask: "dd-MMM-yyyy",
            firstDate: DateTime(1999),
            lastDate: DateTime(2100),
            validator: (value) {
              if (value == null || value.isEmpty) {
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
          ),
          TextFormField(
            //key: _formKey,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Transaction amount",
              prefixIcon: Icon(Icons.currency_exchange),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(
                    color: Color(0xFF1C2536),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(
                    color: Color(0xFF1C2536),
                  )),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Amount cannot be empty";
              }
              return null;
            },
            onChanged: (_) {
              transactionModel.amount = double.parse(_);
            },
          ),
          TextFormField(
            //key: _formKey,
            keyboardType: TextInputType.text,
            maxLength: 25,
            decoration: const InputDecoration(
              hintText: "Transaction name",
              prefixIcon: Icon(Icons.text_snippet),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Comments cannot be empty";
              }
              return null;
            },
            onChanged: (_) {
              transactionModel.comments = _;
            },
          ),
          ListTile(
            shape: RoundedRectangleBorder(
                side: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(20.0)),
            title: Text("Transaction type"),
            trailing: LiteRollingSwitch(
              value: _selectedTransactionType == TransactionType.CREDIT,
              textOn: "Credit",
              textOff: "Debit",
              colorOn: Colors.greenAccent,
              colorOff: Colors.redAccent,
              iconOn: Icons.arrow_circle_up,
              iconOff: Icons.arrow_circle_down,
              onChanged: (bool value) {
                setState(() {
                  _selectedTransactionType =
                      value ? TransactionType.CREDIT : TransactionType.DEBIT;
                });
              },
              onSwipe: () {},
              onTap: () {},
              onDoubleTap: () {},
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1C2536),
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: TextButton(
              onPressed: () {
                saveTransaction();
              },
              child: Text("Save", style: TextStyle(color: Colors.white),),
            ),
          )
        ]
            .map((e) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: e,
                ))
            .toList(),
      )),
    );
  }
}
