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

  nextSteps(String password){
    if(!widget.isNewUser){
      //Validate password
      validatePassword(password).then((value){
        if(value){
          //Navigate to homepage
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
    }
    else{
      //Save password
      savePassword(password);

      //Navigate to account creation page
      //Clearing navigation stack
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => AccountCreationPage(
              isNewUser: widget.isNewUser,
            ),),
              (route) => false);
    }
  }

  Future<bool> validatePassword(password) async {
    return await PasswordDbHelper.instance.validatePassword(password);
  }

  savePassword(String password) async {
    await PasswordDbHelper.instance.setPassword(password);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            obscureText: true,
            autocorrect: false,
            maxLength: 16,
            enableSuggestions: false,
            decoration: const InputDecoration(
              hintText: "Enter your password",
              hintMaxLines: 16,
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
              if(value.length <4){
                return "Password should have at least 4 characters";
              }
              return null;
            },
            onSaved: (value) {
              if(_formKey.currentState!.validate()) {
                nextSteps(value!);
              }
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
}
