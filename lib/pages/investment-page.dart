import 'package:flutter/material.dart';

class InvestmentPage extends StatefulWidget {
  const InvestmentPage({Key? key}) : super(key: key);

  @override
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Text("1%"),
          title: Text("Fixed deposit"),
          subtitle: Text("INR 5000"),
          trailing: Text("20-Oct-2025"),
        )
      ],
    );
  }
}
