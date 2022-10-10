import 'dart:convert';
import 'dart:math';

import 'package:e_kyc/Login/UI/Configuration/AppConfig.dart';
import 'package:e_kyc/Login/UI/EsignScreen/model/Digiouploadresponse.dart';
import 'package:e_kyc/Login/UI/EsignScreen/model/digiobodyresponse.dart';
import 'package:e_kyc/Login/UI/EsignScreen/repository/EsignRepository.dart';
import 'package:e_kyc/Login/UI/Login/repository/LoginRepository.dart';
import 'package:e_kyc/Utilities/CommonDialog.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/src/platform_file.dart';
import 'package:flutter/material.dart';
import 'package:e_kyc/Login/UI/IPVScreen/platformspec/mobiledevice.dart'
    if (dart.library.html) "package:e_kyc/Login/UI/IPVScreen/platformspec/webdevice.dart"
    as newWindow;

class EsignBloc {
  EsignRepository _repository = new EsignRepository();

  var addharselected = true;
  var emudraselected = false;
  var manuallyselected = false;
  var ctx;
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  void dispose() {}

  navtoesigndetail(
      BuildContext context, String esign, String screenname) async {
    try {
      this.ctx = context;
      AppConfig().showLoaderDialog(context); //// show loader
      // ResponseModel obj = await this._repository.SaveEsignDetailsAPI(
      //       LoginRepository.login_email_id,
      //       LoginRepository.login_mobile_no,
      //       esign,
      //     );
      // AppConfig().DismissLoaderDialog(context); //// dismiss loader
      // if (obj.response.errorCode == "0") {
      //   LoginUserDetailModelResponse obj = await LoginRepository()
      //       .getEkycUserDetails(LoginRepository.login_email_id,
      //           LoginRepository.login_mobile_no);
      //   LoginRepository.loginDetailsResObjGlobal = obj;
      //   print("YOUR EKYC COMPLETED");
      //   return true;
      // } else {
      //   print("no data");
      //   showAlert("failed");
      //   return false;
      // }
    } catch (exception) {
      print("no data" + exception);
      // showAlert("failed");
      CommonErrorDialog.showServerErrorDialog(context, 'Server not responding');
      return false;
    }
  }

  Future<dynamic> showAlert(String msg) {
    return showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: Text("E-KYC"),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> sendPDF(BuildContext context, PlatformFile objFile,
      PlatformFile mobileFiles, String screenName) async {
    try {
          AppConfig().showLoaderDialog(context); //// show loader
      this.ctx = context;
      Digiouploadresponse obj = await this
          ._repository
          .sendEsignPDFDetailsAPI(objFile, mobileFiles, screenName);
      if (obj.statusCode == 200) {
        String bodyString = obj.body;
        final loginResponseObj = DigioBodyResponse.fromJson(
          json.decode(
            bodyString.toString(),
          ),
        );

        print(loginResponseObj.toString());
        // wait for return response start
        // ignore: unused_local_variable
        final result = await _repository.fetchResults(context,screenName);
        // wait for return response end

        //Setting url dynamic
        String popURL = '';
        if (AppConfig().url == 'https://tester.greeksoft.in:3006/') {
          popURL = AppConfig().popupUrlProd;
        } else {
          popURL = AppConfig().popupUrlDev;
        }

        var url = popURL +
            loginResponseObj.id.toString() +
            "/" +
            getRandomString(5) +
            "/" +
            LoginRepository.loginEmailId +
            "?redirect_url=" +
            AppConfig().url +
            "digioReturResponse?emailId=" +
            LoginRepository.loginEmailId +
            "";
        print("Redirect URL to Digio " + url);
            AppConfig().dismissLoaderDialog(context); //// hide loader
        newWindow.openNewTab(url);
      } else {
                AppConfig().dismissLoaderDialog(context); //// hide loader
        showAlert("E-Sign upload failed");
      }
    } catch (exception) {
      print(exception.toString());
              AppConfig().dismissLoaderDialog(context); //// hide loader
      showAlert(exception.toString());
    }
  }

  String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );
}
