import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/account-model.dart';

import '../models/investment-model.dart';

class InvestmentPage extends StatefulWidget {
  const InvestmentPage({Key? key}) : super(key: key);

  @override
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {

  List<InvestmentModel> investmentModelList = [];

  getAll() async {
    int accountId = await AccountDbHelper.instance.getSelectedAccountId();
    investmentModelList = await InvestmentDbHelper.instance.getAll(accountId);
    setState(() {

    });
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
        return ListTile(
          title: Text(investmentModel.investmentName),
          subtitle: Text("\$ ${investmentModel.amountInvested}"),
          onLongPress: (){
            delete(investmentModel.id!);
          },
        );
      },
    );
  }
}
