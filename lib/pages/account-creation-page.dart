import 'package:flutter/material.dart';

class AccountCreationPage extends StatefulWidget {
  const AccountCreationPage({Key? key}) : super(key: key);

  @override
  _AccountCreationPageState createState() => _AccountCreationPageState();
}

class _AccountCreationPageState extends State<AccountCreationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Account creation page"),
      ),
    );
  }
}
