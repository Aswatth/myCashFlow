import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_cash_flow/pages/login-page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF1F0F5),
        appBarTheme: AppBarTheme(
          color: const Color(0xFF1C2536),
        )
      ),
      title: 'Flutter Demo',
      home: Scaffold(
        body: LoginPage(),
      )
    );
  }
}
