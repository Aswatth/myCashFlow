import 'package:flutter/material.dart';
import 'package:my_cash_flow/pages/accounts-page.dart';
import 'package:my_cash_flow/pages/change-password-page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          leading: Icon(Icons.account_balance),
          title: Text("Accounts"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(),));
          },
        ),
        ListTile(
          leading: Icon(Icons.key),
          title: Text("Change password"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage(),));
          },
        ),
      ],
    );
  }
}
