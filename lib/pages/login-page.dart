import 'package:flutter/material.dart';
import 'package:my_cash_flow/models/password-model.dart';
import 'package:my_cash_flow/pages/account-creation-page.dart';
import 'package:my_cash_flow/pages/base-page.dart';

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
  String errorMessage = "";

  Future<bool> validatePassword(password) async {
    return await PasswordDbHelper.instance.validatePassword(password);
    /*setState(() {
      validationResult = result?1:0;
    });
    return result;*/
  }

  savePassword(String password) async {
    await PasswordDbHelper.instance.setPassword(password);
  }

  createWidget() {
    //If existing user then display widget to login using their password
    if (!widget.isNewUser) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                hintText: "Enter your password",
                prefixIcon: Icon(Icons.key, color: Color(0xFF1C2536),),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter password";
                }
                return null;
              },
              onSaved: (value) {
                validatePassword(value).then((value){
                  if(value){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BasePage(pageIndex: 0,),
                      ),
                    );
                  }
                  else{
                    setState(() {
                      errorMessage = "Incorrect password";
                    });
                  }
                });
              },
            ),
          ),
          errorMessage.isNotEmpty?Text(errorMessage):Container(),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xFF1C2536),
                borderRadius: BorderRadius.circular(20.0)),
            child: TextButton(
              child: const Text("Log in", style: TextStyle(color: Colors.white),),
              onPressed: () {
                _formKey.currentState!.save();
              },
            ),
          )
        ].map((e) => Padding(padding: const EdgeInsets.all(10.0),child: e,)).toList(),
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
              decoration: const InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.key, color: Color(0xFF1C2536)),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter password";
                } else {
                  return null;
                }
              },
              onSaved: (_) {
                if (_formKey.currentState!.validate()) {
                  //Saving the password
                  savePassword(_!);

                  //Clearing navigation stack
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountCreationPage(
                                isNewUser: widget.isNewUser,
                              ),),
                      (route) => false);
                }
              },
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color(0xFF1C2536),
                borderRadius: BorderRadius.circular(20.0)),
            child: TextButton(
              child: const Text("Setup password", style: TextStyle(color: Colors.white),),
              onPressed: () {
                _formKey.currentState!.save();
              },
            ),
          )
        ].map((e) => Padding(padding: EdgeInsets.all(10.0),child: e,)).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return createWidget();
  }
}
