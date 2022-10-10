import 'dart:convert';

import 'package:e_kyc/Login/UI/Configuration/AppConfig.dart';
import 'package:e_kyc/Login/UI/PersonalDetailsScreen/bloc/PersonalDetailsBloc.dart';
import 'package:e_kyc/Utilities/ResponseModel.dart';
import 'package:http/http.dart' as http;
import 'package:e_kyc/Login/UI/PersonalDetailsScreen/model/PersonalDetailsRequestModel.dart';

/*
0 - NSE CASH,
1 - NSE FNO,
2 - NSE CURRENCY,
3 - BSE CASH,
4 = BSE  FNO,
5 - BSE CURRENCY,
6 - MCX COMMODITY,
7 - NCDEX COMMODITY,
*/

class PersonalDetailsRepository {
  // 'ePersonalDetails' [API]
  callingPersonalDetailsAPI(String email, String mobile,
      PersonalDetailsBloc personalDetailsBloc) async {
    PersonaDetailRequestData personaDetailRequestData =
        new PersonaDetailRequestData();

    personaDetailRequestData.emailId = email;
    personaDetailRequestData.mobileNo = mobile;
    personaDetailRequestData.nseCash =
        personalDetailsBloc.nseCashCheckBox ? "0" : "";
    personaDetailRequestData.nseFo =
        personalDetailsBloc.nseFNOCheckBox ? "1" : "";
    personaDetailRequestData.nseCurrency =
        personalDetailsBloc.nseCurrencyCheckBox ? "2" : "";
    personaDetailRequestData.bseCash =
        personalDetailsBloc.bseCashCheckBox ? "3" : "";
    personaDetailRequestData.bseFo =
        personalDetailsBloc.bseFNOCheckBox ? "4" : "";
    personaDetailRequestData.bseCurrency =
        personalDetailsBloc.bseCurencyCheckBox ? "5" : "";
    personaDetailRequestData.mcxCommodity =
        personalDetailsBloc.mcxCommodityCheckBox ? "6" : "";
    personaDetailRequestData.ncdexCommodity =
        personalDetailsBloc.ncdexComodityCheckBox ? "7" : "";
    personaDetailRequestData.nationality = personalDetailsBloc.nationality;
    String gender = "";
    if (personalDetailsBloc.genderCheck == 0) {
      gender = "Male";
    } else if (personalDetailsBloc.genderCheck == 1) {
      gender = "Female";
    } else {
      gender = "Other";
    }
    personaDetailRequestData.gender = gender;
    // personalDetailsBloc.genderCheck == 0 ? "Male" : "Female";
    personaDetailRequestData.firstname1 =
        personalDetailsBloc.firstNameTextController1.text;
    personaDetailRequestData.middlename1 =
        personalDetailsBloc.middleNameTextController1.text;
    personaDetailRequestData.lastname1 =
        personalDetailsBloc.lastNameTextController1.text;

    personaDetailRequestData.resAddr1 =
        personalDetailsBloc.resAddressLine1TextController.text;
    personaDetailRequestData.resAddr2 =
        personalDetailsBloc.resAddressLine2TextController.text;
    personaDetailRequestData.resAddrState =
        personalDetailsBloc.resStateTextController.text;
    personaDetailRequestData.resAddrCity =
        personalDetailsBloc.resCityTextController.text;
    personaDetailRequestData.resAddrPincode =
        personalDetailsBloc.resPinCodeTextController.text;

    personaDetailRequestData.parmAddr1 =
        personalDetailsBloc.perAddressLine1TextController.text;
    personaDetailRequestData.parmAddr2 =
        personalDetailsBloc.perAddressLine2TextController.text;
    personaDetailRequestData.parmAddrState =
        personalDetailsBloc.perStateTextController.text;
    personaDetailRequestData.parmAddrCity =
        personalDetailsBloc.perCityTextController.text;
    personaDetailRequestData.parmAddrPincode =
        personalDetailsBloc.perPinCodeTextController.text;

    var tempMaritalStatus = personalDetailsBloc.maritalStatus;
    var maritalStatus = "";
    if (tempMaritalStatus == 0) {
      maritalStatus = "Single";
    } else if (tempMaritalStatus == 1) {
      maritalStatus = "Married";
    } else {
      maritalStatus = "Other";
    }
    personaDetailRequestData.maritalstatus = maritalStatus;
    personaDetailRequestData.fatherspouse =
        personalDetailsBloc.fatherSpouseCheck == 0 ? "father" : "spouse";
    personaDetailRequestData.firstname2 =
        personalDetailsBloc.firstNameTextController2.text;
    personaDetailRequestData.middlename2 =
        personalDetailsBloc.middleNameTextController2.text;
    personaDetailRequestData.lastname2 =
        personalDetailsBloc.lastNameTextController2.text;
    personaDetailRequestData.incomerange = personalDetailsBloc.incomeRange;
    personaDetailRequestData.occupation = personalDetailsBloc.occupation;
    personaDetailRequestData.action = personalDetailsBloc.actionCheck == 0
        ? "Politically Exposed Person"
        : "Past Regulatory Action";
    personaDetailRequestData.perextra1 = "";
    personaDetailRequestData.perextra2 = "";

    PersonaDetailsRequestModel requestModel = new PersonaDetailsRequestModel();
    requestModel.data = personaDetailRequestData;

    print(jsonEncode(requestModel));
    final jsonRequest = json.encode(requestModel);

    var headers = {'Content-Type': 'application/json'};
    var apiName = AppConfig().url + "saveEKYCPersonalDetails";
    var request = http.Request('POST', Uri.parse(apiName));

    request.body = jsonRequest;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      print('Response Data :- ${responseData.toString()}');
      final loginResponseObj = ResponseModel.fromJson(
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
