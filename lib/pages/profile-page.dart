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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(),));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: const Color(0xFF1C2536),
                  child: Center(
                      child: Transform.scale(
                        scale: 1.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              child: Icon(Icons.account_balance,color: const Color(0xFF1C2536),),
                              backgroundColor: Colors.white,
                            ),
                            Text("Accounts", style: TextStyle(color: Colors.white),),
                          ].map((e) => Padding(padding: const EdgeInsets.all(10.0),child: e,)).toList(),
                        ),
                      )
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage(),));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: const Color(0xFF1C2536),
                  child: Center(
                    child: Transform.scale(
                      scale: 1.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            child: Icon(Icons.lock,color: const Color(0xFF1C2536),),
                            backgroundColor: Colors.white,
                          ),
                          Text("Change password", style: TextStyle(color: Colors.white),),
                        ].map((e) => Padding(padding: const EdgeInsets.all(10.0),child: e,)).toList(),
                      ),
                    )
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
