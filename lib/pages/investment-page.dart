import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_cash_flow/helpers/globals.dart';
import 'package:my_cash_flow/models/account-model.dart';

import '../models/investment-model.dart';
import 'add-edit-investment-page.dart';

class InvestmentPage extends StatefulWidget {
  const InvestmentPage({Key? key}) : super(key: key);

  @override
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {

  List<InvestmentModel> investmentModelList = [];

  String currency = "";

  getAll() async {
    AccountModel? account = await AccountDbHelper.instance.getSelectedAccount();

    if(account != null){
      investmentModelList = await InvestmentDbHelper.instance.getAll(account.id!);
      setState(() {
        currency = account.currency;
      });
    }
  }

  delete(int investmentId) async{
    await InvestmentDbHelper.instance.delete(investmentId);
    getAll();
  }

  @override
  void initState() {
    super.initState();
    getAll();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: investmentModelList.length,
      itemBuilder: (context, index){
        InvestmentModel investmentModel = investmentModelList[index];
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          child: ListTile(
            title: Text(investmentModel.investmentName, style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormatter.format(investmentModel.date!)),
                Text(investmentModel.comments)
              ].map((e) => Padding(padding: const EdgeInsets.all(4.0), child: e,)).toList(),
            ),
            trailing: Chip(label: Text("$currency ${NumberFormatter.format(investmentModel.amountInvested)}", style: TextStyle(color: Colors.white),),backgroundColor: const Color(0xFF1C2536),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditInvestmentPage(existingInvestmentModel: investmentModel,),));
            },
            onLongPress: (){
              delete(investmentModel.id!);
            },
          ),
        );
      },
    );
  }
}
