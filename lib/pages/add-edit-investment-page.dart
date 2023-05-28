import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_cash_flow/helpers/globals.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/models/investment-model.dart';
import 'package:my_cash_flow/pages/base-page.dart';

class AddEditInvestmentPage extends StatefulWidget {

  InvestmentModel? existingInvestmentModel;

  AddEditInvestmentPage({Key? key, this.existingInvestmentModel}) : super(key: key);

  @override
  _AddEditInvestmentPageState createState() => _AddEditInvestmentPageState();
}

class _AddEditInvestmentPageState extends State<AddEditInvestmentPage> {
  InvestmentModel investmentModel = InvestmentModel();

  final TextEditingController _investmentNameController = TextEditingController();
  final TextEditingController _investmentAmountController = TextEditingController();
  final TextEditingController _investmentDateController = TextEditingController();
  final TextEditingController _investmentCommentsController = TextEditingController();

  save() async{
    investmentModel.investmentName = _investmentNameController.text;
    investmentModel.amountInvested = double.parse(_investmentAmountController.text.replaceAll(",", ""));
    investmentModel.date = DateTime.parse(_investmentDateController.text);
    investmentModel.comments = _investmentCommentsController.text;

    int accountId = await AccountDbHelper.instance.getSelectedAccountId();
    investmentModel.accountId = accountId;

    InvestmentDbHelper.instance.save(investmentModel).then((value) {
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

    if(widget.existingInvestmentModel != null){
     investmentModel = widget.existingInvestmentModel!;

     _investmentNameController.text = investmentModel.investmentName;
     _investmentAmountController.text = NumberFormatter.format(investmentModel.amountInvested);
     _investmentDateController.text = investmentModel.date!.toString();
    _investmentCommentsController.text = investmentModel.comments;
    }
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
            controller: _investmentNameController,
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
                _investmentNameController.text = value;
                _investmentNameController.selection = TextSelection.collapsed(offset: _investmentNameController.text.length);
              });
            },
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: _investmentAmountController,
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
                _investmentAmountController.text = NumberFormatter.format(double.parse(value!.replaceAll(",", "")));
                _investmentAmountController.selection = TextSelection.collapsed(offset: _investmentAmountController.text.length);
              });
            },
          ),
          DateTimePicker(
            controller: _investmentDateController,
            decoration: const InputDecoration(
              hintText: "Next investment/ Invested date",
              prefixIcon: Icon(
                Icons.calendar_today,
                color: const Color(0xFF1C2536),
              ),
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
                _investmentDateController.text = _!;
              });
            },
          ),
          TextFormField(
            //key: _formKey,
            controller: _investmentCommentsController,
            keyboardType: TextInputType.text,
            maxLength: 25,
            decoration: const InputDecoration(
              hintText: "Comments",
              prefixIcon: Icon(
                Icons.text_snippet,
                color: const Color(0xFF1C2536),
              ),
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
              _investmentCommentsController.text = _;
              _investmentCommentsController.selection = TextSelection.collapsed(offset: _investmentCommentsController.text.length);
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