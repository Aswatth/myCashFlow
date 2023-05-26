import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_cash_flow/helpers/transaction-filter-service.dart';
import 'package:my_cash_flow/models/transaction-model.dart';
import 'package:my_cash_flow/models/transactionFilter-model.dart';
import 'package:my_cash_flow/models/transactionTypeEnum.dart';
import 'package:my_cash_flow/pages/add-edit-transaction-page.dart';

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

  NumberFormat formatter = NumberFormat("#,###,###");

  bool _filterFlag = false;
  bool hasFilters = false;
  List<bool> _isSelected = [];

  final List<String> _months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  String? _selectedStartMonth;
  String? _selectedEndMonth;

  TransactionType? _selectedTransactionType;

  TextEditingController startDateController = TextEditingController();
  TextEditingController startYearController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController endYearController = TextEditingController();

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

  deleteTransaction(int id) async {
    await TransactionDbHelper.instance.delete(id);
    await getTransactions();
  }

  applyFilters() async {
    if (startDateController.text.isNotEmpty &&
        _selectedStartMonth != null &&
        startYearController.text.isNotEmpty) {
      transactionFilterModel.startDate =
          "${startDateController.text}-$_selectedStartMonth-${startYearController.text}";
    }
    if (endDateController.text.isNotEmpty && _selectedEndMonth != null && endYearController.text.isNotEmpty) {
      transactionFilterModel.endDate = "${endDateController.text}-$_selectedEndMonth-${endYearController.text}";
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
      _selectedStartMonth = null;
      _selectedEndMonth = null;
      startDateController.text = "";
      startYearController.text = "";
      endDateController.text = "";
      endYearController.text = "";

      minAmountController.text = "";
      maxAmountController.text = "";

      _isSelected = List.generate(categoryList.length, (index) => false);

      hasFilters = false;
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
                leading: hasFilters?Icon(Icons.filter_alt,color: Colors.greenAccent,):Icon(Icons.filter_alt_off),
                title: Text("Filter"),
              );
            },
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  leading: Text("Start date"),
                  title: Row(children: [
                    Expanded(
                      child: TextField(
                        controller: startDateController,
                        decoration: InputDecoration(
                            label: Center(child: Text("Day")), hintText: "DD"),
                        onSubmitted: (value){
                          setState(() {
                            startDateController.text = value;
                          });
                        },
                      ),
                    ),
                    Text("/"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        value: _selectedStartMonth,
                        hint: Text("Month"),
                        items: _months.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStartMonth = value as String?;
                          });
                        },
                      ),
                    ),
                    Text("/"),
                    Expanded(
                      child: TextField(
                        controller: startYearController,
                        decoration: InputDecoration(
                            label: Center(child: Text("Year")),
                            hintText: "YYYY"),
                        onSubmitted: (value) {
                          setState(() {
                            startYearController.text = value;
                          });
                        },
                      ),
                    ),
                  ]),
                ),
                ListTile(
                  leading: Text("End date"),
                  title: Row(children: [
                    Expanded(
                      child: TextField(
                        controller: endDateController,
                        decoration: InputDecoration(
                            label: Center(child: Text("Day")), hintText: "DD"),
                        onSubmitted: (value) {
                          setState(() {
                            endDateController.text = value;
                          });
                        },
                      ),
                    ),
                    Text("/"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        value: _selectedEndMonth,
                        hint: Text("Month"),
                        items: _months.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedEndMonth = value as String?;
                          });
                        },
                      ),
                    ),
                    Text("/"),
                    Expanded(
                      child: TextField(
                        controller: endYearController,
                        decoration: InputDecoration(
                            label: Center(child: Text("Year")),
                            hintText: "YYYY"),
                        onSubmitted: (value) {
                          setState(() {
                            endYearController.text = value;
                          });
                        },
                      ),
                    ),
                  ]),
                ),
                ListTile(
                  leading: Text("Min. Amount"),
                  title: TextField(
                    controller: minAmountController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        minAmountController.text = value;
                        minAmountController.selection = TextSelection.collapsed(offset: minAmountController.text.length);

                        transactionFilterModel.minAmount =
                            double.tryParse(value);
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Text("Max. Amount"),
                  title: TextField(
                    controller: maxAmountController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (value) {
                      setState(() {
                        maxAmountController.text = value;
                        maxAmountController.selection = TextSelection.collapsed(offset: maxAmountController.text.length);

                        transactionFilterModel.maxAmount =
                            double.tryParse(value);
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Text("Categories"),
                  subtitle: Wrap(
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
                            if (value!) {
                              setState(() {
                                _selectedTransactionType = TransactionType.CREDIT;
                              });
                            }
                          }),
                      Text("CREDIT"),
                      Checkbox(
                          value: _selectedTransactionType ==
                              TransactionType.DEBIT,
                          onChanged: (bool? value) {
                            if (value!) {
                              setState(() {
                                _selectedTransactionType = TransactionType.DEBIT;
                              });
                            }
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
                    "${DateFormat("dd-MMM-yyyy").format(transactionModel.transactionDate!).toString()}",
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
                  "$currency ${formatter.format(transactionModel.amount!)}",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color(0xFF1C2536),
              ),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Add_EditTransactionPage(existingTransactionModel: transactionModel,),
                    ));
              },
              onLongPress: () {
                deleteTransaction(transactionModel.id!);
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
                    if(value == 0){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No account found!"),));
                    }
                    else{
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Add_EditTransactionPage(existingTransactionModel: null,),
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
