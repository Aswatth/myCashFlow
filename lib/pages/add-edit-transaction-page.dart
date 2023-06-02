import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';
import 'package:my_cash_flow/models/transaction-model.dart';
import 'package:my_cash_flow/models/transactionTypeEnum.dart';
import 'package:my_cash_flow/pages/base-page.dart';

import '../helpers/enums.dart';
import '../helpers/globals.dart';
import '../models/transaction-category.dart';

class Add_EditTransactionPage extends StatefulWidget {
  TransactionModel? existingTransactionModel;

  Add_EditTransactionPage({Key? key, required this.existingTransactionModel})
      : super(key: key);

  @override
  _Add_EditTransactionPageState createState() =>
      _Add_EditTransactionPageState();
}

class _Add_EditTransactionPageState extends State<Add_EditTransactionPage> {
  TransactionType _selectedTransactionType = TransactionType.CREDIT;

  TransactionModel transactionModel = TransactionModel();

  late GlobalKey<FormState> formKey;

  TextEditingController _transactionDateController = TextEditingController();
  TextEditingController _transactionAmountController = TextEditingController();
  TextEditingController _transactionCommentsController =
      TextEditingController();

  List<bool> _isSelectedList = [];

  int _prevSelectedIndex = -1;
  int _currentSelectedIndex = -1;

  String title = "Add transaction";

  saveTransaction() async {
    int selectedAccountId =
        await AccountDbHelper.instance.getSelectedAccountId();

    //Reverting old transaction changes to current balance
    if (transactionModel.id != null) {
      if (transactionModel.transactionType == TransactionType.CREDIT) {
        await AccountDbHelper.instance
            .updateCurrentBalance(-transactionModel.amount!);
      } else {
        await AccountDbHelper.instance
            .updateCurrentBalance(transactionModel.amount!);
      }
    }

    transactionModel.transactionType = _selectedTransactionType;

    transactionModel.category = _currentSelectedIndex != -1
        ? categoryList[_currentSelectedIndex].name
        : categoryList[categoryList.length - 1].name;
    transactionModel.accountId = selectedAccountId;

    //Updating current balance with new/updated transaction
    if (transactionModel.transactionType == TransactionType.CREDIT) {
      await AccountDbHelper.instance
          .updateCurrentBalance(transactionModel.amount!);
    } else {
      await AccountDbHelper.instance
          .updateCurrentBalance(-transactionModel.amount!);
    }

    //print(transactionModel.toJson());
    TransactionDbHelper.instance.save(transactionModel).then((value) {
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

  Widget tagWidget(String label, IconData iconData) {
    return Column(
      children: [Icon(iconData), Text(label)],
    );
  }

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormState>();

    _isSelectedList = List.generate(categoryList.length, (index) => false);

    if (widget.existingTransactionModel != null) {
      transactionModel = widget.existingTransactionModel!;

      _transactionDateController.text =
          transactionModel.transactionDate.toString();
      _transactionAmountController.text =
          NumberFormatter.format(transactionModel.amount);
      _transactionCommentsController.text = transactionModel.comments;

      _selectedTransactionType = transactionModel.transactionType!;

      for (int i = 0; i < categoryList.length; ++i) {
        if (categoryList[i].name == transactionModel.category) {
          _currentSelectedIndex = i;
          _prevSelectedIndex = i;
          _isSelectedList[_currentSelectedIndex] = true;
          break;
        }
      }

      title = "Edit transaction";
    } else {
      transactionModel = TransactionModel();
    }
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Icon(
          Icons.arrow_circle_up,
          color: Colors.green,
          size: 30,
        );
      }
      return const Icon(
        Icons.arrow_circle_down,
        color: Colors.red,
        size: 30,
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Form(
          key: formKey,
          child: ListView(
            children: [
              DateTimePicker(
                controller: _transactionDateController,
                decoration: const InputDecoration(
                  hintText: "Transaction date",
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
                    _transactionDateController.text = _!;
                  });
                },
                onSaved: (value){
                  transactionModel.transactionDate = DateTime.parse(_transactionDateController.text);
                },
              ),
              TextFormField(
                //key: _formKey,
                controller: _transactionAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Transaction amount",
                  prefixIcon: Icon(
                    Icons.currency_exchange,
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
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Amount cannot be empty";
                  }
                  return null;
                },
                onChanged: (_) {
                  _transactionAmountController.text = _ == ""
                      ? ""
                      : NumberFormatter.format(
                          double.parse(_.replaceAll(",", "")));
                  _transactionAmountController.selection =
                      TextSelection.collapsed(
                          offset: _transactionAmountController.text.length);
                },
                onSaved: (value){
                  transactionModel.amount = double.parse(_transactionAmountController.text.replaceAll(",", ""));
                },
              ),
              TextFormField(
                controller: _transactionCommentsController,
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
                  _transactionCommentsController.text = _;
                  _transactionCommentsController.selection =
                      TextSelection.collapsed(
                          offset: _transactionCommentsController.text.length);
                },
                onSaved: (value){
                  transactionModel.comments = _transactionCommentsController.text;
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(20.0)),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Category:"),
                    Text(
                      "If none is selected, Other will be selected by default",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
                subtitle: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  childAspectRatio: 1.5,
                  crossAxisCount: 3,
                  children: categoryList.map((e) {
                    int index = categoryList.indexOf(e);
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_prevSelectedIndex != -1) {
                              _isSelectedList[_prevSelectedIndex] =
                                  !_isSelectedList[_prevSelectedIndex];
                            }

                            //Select only one
                            _isSelectedList[index] = !_isSelectedList[index];

                            //Save the selected index
                            if (_isSelectedList[index]) {
                              _currentSelectedIndex = index;
                              _prevSelectedIndex = index;
                            }
                          });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              child: Icon(
                                categoryList[index].icon,
                                color: _isSelectedList[index]
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              backgroundColor: _isSelectedList[index]
                                  ? const Color(0xFF1C2536)
                                  : Colors.grey[300],
                            ),
                            Text(e.name),
                          ],
                        ));
                  }).toList(),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Debit"),
                    Transform.scale(
                      scale: 1.5,
                      child: Switch(
                          thumbIcon: thumbIcon,
                          value: _selectedTransactionType ==
                              TransactionType.CREDIT,
                          activeColor: Colors.white,
                          activeTrackColor: Colors.greenAccent,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.redAccent,
                          onChanged: (bool value) {
                            setState(() {
                              _selectedTransactionType = value
                                  ? TransactionType.CREDIT
                                  : TransactionType.DEBIT;
                            });
                          }),
                    ),
                    Text("Credit"),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xFF1C2536),
                    borderRadius: BorderRadius.circular(20.0)),
                child: TextButton(
                  onPressed: () {
                    if(formKey.currentState!.validate()){
                      formKey.currentState!.save();
                      saveTransaction();
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
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
