import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppConfig {
  get internalVersionNO => '1.0.1.10';
  get deviceID => 'D572727E85A5';
  get deviceDetails => 'iPhone 12 mini iOS 14.4';
  // get url => 'http://192.168.209.11:3006/';
  // get url => 'http://192.168.209.141:3000/';
  // get url => 'http://182.76.70.73:3006/'; // static IP
  // get url => 'https://192.168.209.106:3000/';

// this will enable live url for digio process
  get url => 'https://tester.greeksoft.in:3006/';
  get popupUrlDev =>
      'https://ext.digio.in/#/gateway/login/'; // sandbox URL for testing
  get popupUrlProd =>
      'https://app.digio.in/#/gateway/login/'; // live production url

  encryptionMDSConverstion(String pass) {
    return md5.convert(utf8.encode(pass)).toString();
  }

  void showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    "Please wait",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'century_gothic',
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  void dismissLoaderDialog(BuildContext context) {
    Navigator.pop(context); //// dismiss loader
  }
}
