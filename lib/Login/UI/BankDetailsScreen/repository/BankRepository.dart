// ignore_for_file: unused_import

import "dart:convert";

import 'package:e_kyc/Login/UI/BankDetailsScreen/model/BankRequestModel.dart';
import 'package:e_kyc/Login/UI/BankDetailsScreen/model/BankResponseModel.dart';
import 'package:e_kyc/Login/UI/Configuration/AppConfig.dart';
import 'package:e_kyc/Utilities/ResponseModel.dart';
import "package:http/http.dart" as http;

class BankRepository {
  saveBankDetailsAPI(String email, String mobile, String ifsccode,
      String accountnumber, String bankname) async {
    BankDetailData data = new BankDetailData();

    data.emailId = email;
    data.mobileNo = mobile;
    data.ifsccode = ifsccode;
    data.accountnumber = accountnumber;
    data.bankname = bankname;

    BankRequestModel request1 = new BankRequestModel();
    request1.data = data;

    final jsonRequest = json.encode(request1);
    print('Final E-Kyc Request - $jsonRequest');

    var headers = {'Content-Type': 'application/json'};
    var apiName = AppConfig().url + "SaveBankDetails";
    var request = http.Request('POST', Uri.parse(apiName));
    request.body = jsonRequest;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      print('Response Data :- ${responseData.toString()}');
      final loginResponseObj = BankResponseModel.fromJson(
        json.decode(
          responseData.toString(),
        ),
      );
      return loginResponseObj;
    } else {
      print(response.reasonPhrase);
    }
  }
}
