import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/password-model.dart';
import 'package:my_cash_flow/pages/account-creation-page.dart';
import 'package:my_cash_flow/pages/home-page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isNewUser = true;
  bool isLoading = true;

  //To check if the user is new user or not
  checkIfNewUser() async {
    PasswordDbHelper.instance.checkIfNewUser().then((value) {
      setState(() {
        isNewUser = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfNewUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: !isLoading
            ? Login(
                isNewUser: isNewUser,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  final bool isNewUser;

  const Login({Key? key, required this.isNewUser}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  int validationResult = -1;

  Future<bool> validatePassword(password) async {
    bool result = await PasswordDbHelper.instance.validatePassword(password);
    setState(() {
      if (result) {
        validationResult = 1;
      } else {
        validationResult = 0;
      }
      _formKey.currentState!.validate();
    });
    return result;
  }

  savePassword(String password) async {
    await PasswordDbHelper.instance.setPassword(password);
  }

  createWidget() {
    //If existing user then display widget to login using their password
    if (!widget.isNewUser) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(hintText: "Enter you password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter password";
                } else {
                  if (validationResult == 0) {
                    return "Incorrect password";
                  } else {
                    return null;
                  }
                }
              },
              onSaved: (_) {
                if (_formKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                }
              },
            ),
          ),
          TextButton(
            child: const Text("Log in"),
            onPressed: () {
              _formKey.currentState!.save();
            },
          )
        ],
      );
    }
    //If not then set up password for new user
    else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              controller: _controller,
              decoration: const InputDecoration(hintText: "Enter you password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter password";
                } else {
                  return null;
                }
              },
              onSaved: (_) {
                if (_formKey.currentState!.validate()) {
                  savePassword(_controller.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountCreationPage(),
                    ),
                  );
                }
              },
            ),
          ),
          TextButton(
            child: const Text("Setup password"),
            onPressed: () {
              _formKey.currentState!.save();
            },
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return createWidget();
  }
}
