import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/password-model.dart';

import 'base-page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  bool hideOldPassword = true;
  bool hideNewPassword = true;

  String oldPassword = "";
  String newPassword = "";

  save()async{
    String existingPassword = await PasswordDbHelper.instance.getPassword();

    if(oldPassword == existingPassword){
      print("New password: "+newPassword);
      await PasswordDbHelper.instance.setPassword(newPassword);

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => BasePage(pageIndex: 0,)), (route)=>false);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change password"),
      ),
      body: Column(
        children: [
          ListTile(
            title: TextField(
              obscureText: hideOldPassword,
              autocorrect: false,
              maxLength: 16,
              enableSuggestions: false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                suffix: IconButton(
                  onPressed: (){
                    setState(() {
                      hideOldPassword = !hideOldPassword;
                    });
                  },
                  icon: Icon(hideOldPassword? Icons.visibility_off:Icons.visibility,color: const Color(0xFF1C2536),),
                ),
                label: Text("Old password", style: TextStyle(color: const Color(0xFF1C2536)),),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Color(0xFF1C2536),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Color(0xFF1C2536),
                  ),
                ),
              ),
              onChanged: (value){
                setState(() {
                  oldPassword = value;
                });
              },
            ),
          ),
          ListTile(
            title: TextField(
              obscureText: hideNewPassword,
              autocorrect: false,
              maxLength: 16,
              enableSuggestions: false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                suffix: IconButton(
                  onPressed: (){
                    setState(() {
                      hideNewPassword = !hideNewPassword;
                    });
                  },
                  icon: Icon(hideNewPassword? Icons.visibility_off:Icons.visibility,color: const Color(0xFF1C2536),),
                ),
                label: Text("New password", style: TextStyle(color: const Color(0xFF1C2536)),),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Color(0xFF1C2536),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Color(0xFF1C2536),
                  ),
                ),
              ),
              onChanged: (value){
                setState(() {
                  newPassword = value;
                });
              },
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xFF1C2536),
                borderRadius: BorderRadius.circular(20.0)),
            child: TextButton(
              onPressed: () {
                //Save password change
                save();
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ].map((e) => Padding(padding: const EdgeInsets.all(10.0),child: e,)).toList(),
      ),
    );
  }
}
