import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_cash_flow/helpers/storage.dart';
import 'package:my_cash_flow/pages/login-page.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: LoginPage()
    );
  }
}
