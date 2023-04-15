import 'package:flutter/material.dart';
import 'package:my_cash_flow/helpers/storage.dart';
import 'package:my_cash_flow/pages/account-creation-page.dart';
import 'package:my_cash_flow/pages/home-page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //To check if the user is new user or not
  Future<bool> isNewUser() async{
    String value = await StorageHelper().readFile();
    if(value == "NOT-FOUND"){
      return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<bool>(
          future: isNewUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              bool value = snapshot.data!;
              return Login(isNewUser: value);
            }
            else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Fetching your information"),
                  CircularProgressIndicator()
                ],
              );
            }
          },
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

  fetchPassword(password) {

    StorageHelper().readFile().then((value){
      setState(() {
        if(password == value) {
          validationResult = 1;
        }
        else{
          validationResult = 0;
        }
        _formKey.currentState!.validate();
      });
    });
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
              decoration: const InputDecoration(
                  hintText: "Enter you password"
              ),
              validator: (value){
                if(value ==null || value.isEmpty) {
                  return "Please enter password";
                }
                else{
                  fetchPassword(value);
                  if(validationResult == 1) {
                    return null;
                  } else if(validationResult == 0) {
                    return "Incorrect password";
                  }
                  return "Validating...";
                }
              },
            ),
          ),
          TextButton(
            child: const Text("Log in"),
            onPressed: () {
              if(_formKey.currentState!.validate()){
                print("logging in");
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
              }
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
              controller: _controller,
              decoration: const InputDecoration(
                  hintText: "Enter you password"
              ),
              validator: (value){
                if(value ==null || value.isEmpty) {
                  return "Please enter password";
                }
                else {
                  return null;
                }
              },
            ),
          ),
          TextButton(
            child: const Text("Setup password"),
            onPressed: () {
              if(_formKey.currentState!.validate()){
                StorageHelper().save(_controller.text).then((value){
                  if(value) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AccountCreationPage(),));
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Setting up password was unsuccessful")));
                  }
                });
              }
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




