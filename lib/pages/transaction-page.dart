import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_cash_flow/helpers/transaction-filter-service.dart';
import 'package:my_cash_flow/models/transaction-model.dart';
import 'package:my_cash_flow/models/transaction-filter-model.dart';
import 'package:my_cash_flow/models/transactionTypeEnum.dart';
import 'package:my_cash_flow/pages/add-edit-transaction-page.dart';

import '../helpers/enums.dart';
import '../helpers/globals.dart';
import '../models/account-model.dart';
import '../models/transaction-category.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<TransactionModel> transactionList = [];

  String currency = "";

  bool _filterFlag = false;
  bool hasFilters = false;
  List<bool> _isSelected = [];

  TransactionType? _selectedTransactionType;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  TextEditingController minAmountController = TextEditingController();
  TextEditingController maxAmountController = TextEditingController();

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

  TransactionFilterModel transactionFilterModel = TransactionFilterModel();

  getTransactions() async {
    AccountModel? selectedAccount =
        await AccountDbHelper.instance.getSelectedAccount();

    List<TransactionModel>? filterData;

    if (selectedAccount != null) {
      transactionList =
          await TransactionDbHelper.instance.getAll(selectedAccount.id!);

      setState(() {
        currency = selectedAccount.currency;
      });
    }
  }

  deleteTransaction(TransactionModel transactionModel) async {
    if (transactionModel.id != null) {
      if (transactionModel.transactionType == TransactionType.CREDIT) {
        await AccountDbHelper.instance
            .updateCurrentBalance(-transactionModel.amount!);
      } else {
        await AccountDbHelper.instance
            .updateCurrentBalance(transactionModel.amount!);
      }
    }
    await TransactionDbHelper.instance.delete(transactionModel.id!);
    await getTransactions();
  }

  applyFilters() async {
    if (startDateController.text.isNotEmpty) {
      transactionFilterModel.startDate =
          DateTime.parse(startDateController.text);
    }
    if (endDateController.text.isNotEmpty) {
      transactionFilterModel.endDate = DateTime.parse(endDateController.text);
    }
    transactionFilterModel.selectedCategories = categoryList
        .where((element) => _isSelected[categoryList.indexOf(element)])
        .map((e) => e.name)
        .toList();
    transactionFilterModel.transactionType = _selectedTransactionType;

    int accountId = await AccountDbHelper.instance.getSelectedAccountId();
    transactionList = await TransactionFilterService.instance
        .filterData(accountId, transactionFilterModel);

    setState(() {
      _filterFlag = false;
      hasFilters = true;
    });
  }

  clearFilters() {
    setState(() {
      transactionFilterModel.startDate = null;
      transactionFilterModel.endDate = null;
      transactionFilterModel.minAmount = null;
      transactionFilterModel.maxAmount = null;
      transactionFilterModel.selectedCategories = [];
      transactionFilterModel.transactionType = null;

      _selectedTransactionType = null;
      startDateController.text = "";
      endDateController.text = "";

      minAmountController.text = "";
      maxAmountController.text = "";

      _isSelected = List.generate(categoryList.length, (index) => false);
    });

    getTransactions();
  }

  Widget filterWidget() {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          _filterFlag = !_filterFlag;
        });
      },
      children: [
        ExpansionPanel(
            headerBuilder: (context, isExpanded) {
              return ListTile(
                leading: hasFilters
                    ? Icon(
                        Icons.filter_alt,
                        color: const Color(0xFF1C2536),
                      )
                    : Icon(Icons.filter_alt_off),
                title: Text("Filter"),
              );
            },
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DateTimePicker(
                  controller: startDateController,
                  decoration: const InputDecoration(
                    hintText: "Start date",
                    label: Text("Start date"),
                    labelStyle: TextStyle(
                      color: Color(0xFF1C2536),
                    ),
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: Color(0xFF1C2536),
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
                  firstDate: DateTime(1990),
                  lastDate: DateTime(2100),
                  onChanged: (String? _) {
                    setState(() {
                      startDateController.text = _!;
                    });
                  },
                ),
                DateTimePicker(
                  controller: endDateController,
                  decoration: const InputDecoration(
                    hintText: "End date",
                    label: Text("End date"),
                    labelStyle: TextStyle(
                      color: Color(0xFF1C2536),
                    ),
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: Color(0xFF1C2536),
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
                  firstDate: DateTime(1990),
                  lastDate: DateTime(2100),
                  onChanged: (String? _) {
                    setState(() {
                      endDateController.text = _!;
                    });
                  },
                ),
                TextFormField(
                  //key: _formKey,
                  controller: minAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Minimum amount",
                    label: Text("Minimum amount"),
                    labelStyle: TextStyle(
                      color: const Color(0xFF1C2536),
                    ),
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
                    minAmountController.text = _ == ""
                        ? ""
                        : NumberFormatter.format(
                            double.parse(_.replaceAll(",", "")));
                    minAmountController.selection = TextSelection.collapsed(
                        offset: minAmountController.text.length);
                  },
                ),
                TextFormField(
                  //key: _formKey,
                  controller: maxAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Maximum amount",
                    label: Text("Maximum amount"),
                    labelStyle: TextStyle(
                      color: const Color(0xFF1C2536),
                    ),
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
                    maxAmountController.text = _ == ""
                        ? ""
                        : NumberFormatter.format(
                            double.parse(_.replaceAll(",", "")));
                    maxAmountController.selection = TextSelection.collapsed(
                        offset: maxAmountController.text.length);
                  },
                ),
                ListTile(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(20.0)),
                  title: Text("Categories"),
                  subtitle: GridView.count(
                    crossAxisCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 2,
                    children: categoryList
                        .map((e) => FilterChip(
                              label: Text(e.name),
                              showCheckmark: false,
                              labelStyle: TextStyle(
                                  color: _isSelected[categoryList.indexOf(e)]
                                      ? Colors.white
                                      : Colors.black),
                              selected: _isSelected[categoryList.indexOf(e)],
                              selectedColor: const Color(0xFF1C2536),
                              onSelected: (bool value) {
                                setState(() {
                                  int index = categoryList.indexOf(e);
                                  _isSelected[index] = !_isSelected[index];
                                });
                              },
                            ))
                        .toList(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Transaction type"),
                      Checkbox(
                          value: _selectedTransactionType ==
                              TransactionType.CREDIT,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value!) {
                                _selectedTransactionType =
                                    TransactionType.CREDIT;
                              } else {
                                _selectedTransactionType = null;
                              }
                            });
                          }),
                      const Text("CREDIT"),
                      Checkbox(
                          value:
                              _selectedTransactionType == TransactionType.DEBIT,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value!) {
                                _selectedTransactionType =
                                    TransactionType.DEBIT;
                              } else {
                                _selectedTransactionType = null;
                              }
                            });
                          }),
                      Text("DEBIT"),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2, 0, 2, 5),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFF1C2536),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: TextButton(
                            onPressed: () {
                              clearFilters();
                            },
                            child: Text(
                              "Clear",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2, 0, 2, 5),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFF1C2536),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: TextButton(
                            onPressed: () {
                              applyFilters();
                            },
                            child: Text(
                              "Apply",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ]
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: e,
                      ))
                  .toList(),
            ),
            isExpanded: _filterFlag)
      ],
    );
  }

  Widget transactionWidget(TransactionModel transactionModel) {
    //TransactionModel transactionModel = transactionList[0];
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Transform.scale(
                scale: 1.5,
                child:
                    transactionModel.transactionType == TransactionType.CREDIT
                        ? Icon(
                            Icons.arrow_circle_up,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.arrow_circle_down,
                            color: Colors.red,
                          ),
              ),
              title: Text(transactionModel.comments),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormatter.format(transactionModel.transactionDate!)
                        .toString(),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    transactionModel.category,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              trailing: Chip(
                label: Text(
                  "$currency ${NumberFormatter.format(transactionModel.amount!)}",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color(0xFF1C2536),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Add_EditTransactionPage(
                        existingTransactionModel: transactionModel,
                      ),
                    ));
              },
              onLongPress: () {
                deleteTransaction(transactionModel);
              },
            ),
          ]
              .map((e) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: e,
                  ))
              .toList(),
        ));
  }

  getWidgets() {
    List<Widget> widgetList = [];
    for (var element in transactionList) {
      widgetList.add(transactionWidget(element));
    }

    widgetList.insert(0, filterWidget());

    return widgetList;
  }

  @override
  void initState() {
    super.initState();

    transactionFilterModel = TransactionFilterModel();

    getTransactions();
    _isSelected = List.generate(categoryList.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Transactions"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  AccountDbHelper.instance.getSelectedAccountId().then((value) {
                    if (value == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("No account found!"),
                      ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Add_EditTransactionPage(
                              existingTransactionModel: null,
                            ),
                          ));
                    }
                  });
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        body: ListView(children: getWidgets()));
  }
}
