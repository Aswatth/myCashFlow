import 'package:flutter/material.dart';
import 'package:my_cash_flow/helpers/enums.dart';
import 'package:my_cash_flow/models/password-model.dart';
import 'package:my_cash_flow/pages/add-edit-account-page.dart';
import 'package:my_cash_flow/pages/base-page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordEditingController =
      TextEditingController();

  Future<PasswordResult> checkPassword(String password) async {
    if (password.length >= 4 && password.length <= 16) {
      //Check is password already exists -> Whether it is new user or returning user
      bool isNewUser = await PasswordDbHelper.instance.checkIfNewUser();
      if (isNewUser) {
        await PasswordDbHelper.instance.setPassword(password);
        return PasswordResult.SIGNUP;
      } else {
        bool validationResult =
            await PasswordDbHelper.instance.validatePassword(password);
        if (validationResult) {
          return PasswordResult.LOGIN;
        } else {
          return PasswordResult.INCORRECT_PASSWORD;
        }
      }
    }
    return PasswordResult.INVALID_PASSWORD;
    
  }

  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            obscureText: true,
            autocorrect: false,
            maxLength: 16,
            enableSuggestions: false,
            decoration: const InputDecoration(
              hintText: "Enter your password",
              hintMaxLines: 16,
              prefixIcon: Icon(
                Icons.key,
                color: Color(0xFF1C2536),
              ),
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
            validator: (value){
              if(value == null || value.isEmpty) {
                return "Password cannot be empty";
              }
              if(value.length < 4){
                return "Password should be at least 4 characters";
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _passwordEditingController.text = value;
                _passwordEditingController.selection = TextSelection.collapsed(offset: _passwordEditingController.text.length);
              });
            },
            onSaved: (value){
              checkPassword(value!).then((value) {
                switch (value) {
                  case PasswordResult.SIGNUP:
                    {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditAccountsPage(),
                          ),
                              (route) => false);
                    }
                    break;
                  case PasswordResult.LOGIN:
                    {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BasePage(pageIndex: 0),
                          ),
                              (route) => false);
                    }
                    break;
                  case PasswordResult.INCORRECT_PASSWORD:
                    {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Incorrect password"),
                        duration: Duration(seconds: 1),
                      ));
                    }
                    break;
                }
              });
            },
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xFF1C2536),
                borderRadius: BorderRadius.circular(20.0)),
            child: TextButton(
              child: const Text(
                "Log in",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                checkPassword(_passwordEditingController.text);
                if(formKey.currentState!.validate()){
                  formKey.currentState!.save();
                }
              },
            ),
          )
        ]
            .map((e) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: e,
                ))
            .toList(),
      ),
    );
  }
}
