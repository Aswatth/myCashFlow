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
  final TextEditingController _passwordEditingController = TextEditingController();

  Future<PasswordResult> checkPassword() async {
    String password = _passwordEditingController.text;
    print("Typed password: "+password);
    if (password.length >= 4 && password.length <= 16) {
      //Check is password already exists -> Whether it is new user or returning user
      bool isNewUser = await PasswordDbHelper.instance.checkIfNewUser();
      if(isNewUser){
        return PasswordResult.SIGNUP;
      }
      else {
        bool validationResult = await PasswordDbHelper.instance.validatePassword(password);
        if(validationResult){
          return PasswordResult.LOGIN;
        }
        else{
          return PasswordResult.INCORRECT_PASSWORD;
        }
      }
    }
    return PasswordResult.INVALID_PASSWORD;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          onChanged: (value){
            setState(() {
              _passwordEditingController.text = value;
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
              checkPassword().then((value) {
                    switch(value){
                    case PasswordResult.SIGNUP: {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditAccountsPage(),
                          ),
                              (route) => false);
                    }
                    break;
                      case PasswordResult.LOGIN: {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BasePage(pageIndex: 0),
                            ),
                                (route) => false);
                      }
                      break;
                    case PasswordResult.INCORRECT_PASSWORD: {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Incorrect password"),
                      ));
                    }
                    break;
                    case PasswordResult.INVALID_PASSWORD: {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Password length should be at least 4 characters"),
                      ));
                    }
                    break;
    }
                  });
            },
          ),
        )
      ]
          .map((e) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: e,
              ))
          .toList(),
    );
  }
}
