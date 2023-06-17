import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/password-model.dart';

import 'base-page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  late GlobalKey<FormState> formKey;

  bool hideOldPassword = true;
  bool hideNewPassword = true;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  Future<bool> save(String oldPassword, String newPassword)async{
    String existingPassword = await PasswordDbHelper.instance.getPassword();

    if(oldPassword == existingPassword){
      await PasswordDbHelper.instance.setPassword(newPassword);
      return true;
    }
    else{
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change password"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            ListTile(
              title: TextFormField(
                controller: oldPasswordController,
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
                validator: (value){
                  if(value == null || value.isEmpty) {
                    return "Password cannot be empty";
                  }
                  if(value.length < 4){
                    return "Password should be at least 4 characters";
                  }
                  return null;
                },
                onChanged: (value){
                  setState(() {
                    oldPasswordController.text = value;
                    oldPasswordController.selection = TextSelection.collapsed(offset: oldPasswordController.text.length);
                  });
                },
                onSaved: (value){
                  oldPasswordController.text = value!;
                },
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: newPasswordController,
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
                validator: (value){
                  if(value == null || value.isEmpty) {
                    return "Password cannot be empty";
                  }
                  if(value.length < 4){
                    return "Password should be at least 4 characters";
                  }
                  return null;
                },
                onChanged: (value){
                  setState(() {
                    newPasswordController.text = value;
                    newPasswordController.selection = TextSelection.collapsed(offset: newPasswordController.text.length);
                  });
                },
                onSaved: (value){
                  newPasswordController.text = value!;
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
                  if(formKey.currentState!.validate()){
                    formKey.currentState!.save();
                    save(oldPasswordController.text, newPasswordController.text).then((value) {
                      if(value) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => BasePage(pageIndex: 0,)), (route)=>false);
                      } else{
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect old password")));
                      }
                    });
                  }
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ].map((e) => Padding(padding: const EdgeInsets.all(10.0),child: e,)).toList(),
        ),
      ),
    );
  }
}
