import 'package:flutter/material.dart';
import 'package:loja_do_ze/modules/login/views/login_page.dart';
import 'dart:async';
import 'modules/home/views/home_view.dart';
import 'modules/cart/views/cart_page.dart';
import 'shared/utils.dart';
import 'helper.dart';
import 'globals.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loja do Zé',
      theme: ThemeData(primaryColor: Color(0xFF6200EE)),
      home: LoginPage(),
    );
  }
}


