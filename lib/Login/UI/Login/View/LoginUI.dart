import 'package:e_kyc/Login/UI/Login/View/LoginScreenLarge.dart';
import 'package:e_kyc/Login/UI/Login/View/LoginScreenSmall.dart';
import 'package:flutter/material.dart';

class LoginUI extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E - KYC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  // int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return LoginScreen();
          } else {
            return LoginScreenLarge();
          }
        },
      ),
    );
  }
}
