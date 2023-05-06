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

  List<String> _categoryNameList = [];
  List<IconData> _categoryIconList = [];

  List<bool> _isSelectedList = [];

  int _selectedIndex = -1;

  saveTransaction() async {
    int selectedAccountId =
        await AccountDbHelper.instance.getSelectedAccountId();

    transactionModel.transactionType = _selectedTransactionType;

    transactionModel.category = _selectedIndex != -1?_categoryNameList[_selectedIndex]:"";
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

  Widget TagWidget(String label, IconData iconData) {
    return Column(
      children: [Icon(iconData), Text(label)],
    );
  }

  @override
  void initState() {
    super.initState();

    _categoryNameList = [
      "Family",
      "Friends",
      "Medical",
      "Food",
      "Clothing",
      "Education",
      "Entertainment",
      "Travel",
      "Bills",
      "Housing",
      "Other",
      "Salary"
    ];

    _categoryIconList = [
      Icons.family_restroom,
      Icons.group,
      Icons.healing,
      Icons.fastfood,
      Icons.checkroom,
      Icons.school,
      Icons.theater_comedy,
      Icons.airplanemode_active,
      Icons.receipt_long,
      Icons.house,
      Icons.shuffle,
      Icons.attach_money
    ];

    _isSelectedList = List.generate(_categoryNameList.length, (index) => false);
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
        title: const Text("Add transaction"),
      ),
      body: Form(
          child: ListView(
        children: [
          DateTimePicker(
            decoration: const InputDecoration(
              hintText: "Transaction date",
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
              title: Text("Category:\n"),
              subtitle: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: 1.5,
                crossAxisCount: 3,
                children: _categoryNameList.map((e) {
                  int index = _categoryNameList.indexOf(e);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        //Deselect all
                        _isSelectedList = List.generate(_isSelectedList.length, (index) => false);

                        //Select only one
                        _isSelectedList[index] = !_isSelectedList[index];

                        //Save the selected index
                        if(_isSelectedList[index]){
                          _selectedIndex = index;
                        }
                      });
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Icon(
                            _categoryIconList[index],
                            color:_isSelectedList[index]
                                ?Colors.white
                                :Colors.black,
                          ),
                          backgroundColor: _isSelectedList[index]
                              ?const Color(0xFF1C2536)
                              :Colors.grey[300],
                        ),
                        Text(e),
                      ],
                    )
                  );
                }).toList(),
              ),),
          ListTile(
            shape: RoundedRectangleBorder(
                side: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(20.0)),
            title: Text("Transaction type"),
            trailing: Transform.scale(
              scale: 1.5,
              child: Switch(
                  thumbIcon: thumbIcon,
                  value: _selectedTransactionType == TransactionType.CREDIT,
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
          ),
          Container(
            decoration: BoxDecoration(
                color: const Color(0xFF1C2536),
                borderRadius: BorderRadius.circular(20.0)),
            child: TextButton(
              onPressed: () {
                saveTransaction();
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
