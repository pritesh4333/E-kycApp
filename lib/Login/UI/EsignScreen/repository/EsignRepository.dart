import 'dart:async';
import "dart:convert";
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:e_kyc/Login/UI/Configuration/AppConfig.dart';
import 'package:e_kyc/Login/UI/EsignScreen/model/Digiouploadresponse.dart';
import 'package:e_kyc/Login/UI/EsignScreen/model/EsignRequestModel.dart';
import 'package:e_kyc/Login/UI/HomeScreen/HomeScreenLarge.dart';
import 'package:e_kyc/Login/UI/HomeScreen/HomeScreenSmall.dart';
import 'package:e_kyc/Login/UI/IPVScreen/bloc/IpvScreenBlock.dart';
import 'package:e_kyc/Login/UI/Login/bloc/LoginBloc.dart';
import 'package:e_kyc/Login/UI/Login/model/LoginUserDetailModelResponse.dart';
import 'package:e_kyc/Login/UI/Login/repository/LoginRepository.dart';
import 'package:e_kyc/Login/UI/PanDetailsScreen/repository/PanDetailRepository.dart';
import 'package:e_kyc/Utilities/ResponseModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:e_kyc/Login/UI/Login/View/save_file_mobile.dart'
    if (dart.library.html) 'package:e_kyc/Login/UI/Login/View/save_file_web.dart';
import 'package:e_kyc/Login/UI/IPVScreen/platformspec/mobiledevice.dart'
    if (dart.library.html) "package:e_kyc/Login/UI/IPVScreen/platformspec/webdevice.dart"
    as newWindow;
import 'package:universal_html/html.dart' as html;
import 'package:http_parser/http_parser.dart';
// import 'package:http_parser/http_parser.dart';

class EsignRepository {
  LoginBloc loginbloc = new LoginBloc();
  String uRl = AppConfig().url;
  var globalRespObj = LoginRepository.loginDetailsResObjGlobal;
  static Timer timerObj;
  Uint8List signature;
  http.Response response;
  saveEsignDetailsAPI(String email, String mobile, String esign) async {
    EsignDetailData data = new EsignDetailData();

    data.emailId = email;
    data.mobileNo = mobile;
    data.esign = esign;

    EsignRequestModel request1 = new EsignRequestModel();
    request1.data = data;

    final jsonRequest = json.encode(request1);
    print('Final E-Kyc Request - $jsonRequest');

    var headers = {'Content-Type': 'application/json'};
    var apiName = AppConfig().url + "SaveEsignDetails";
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

  // SendEsignPDFDetailsAPI(List<int> selectedFile) async {
  //   var headers = {
  //     'Authorization':
  //         'Basic QUlPOE9TTVE3VVFHTFpGQkU0WVJBQ0ZIVE9PS0VQOUI6NDhMR1BYNVpJUFdOVVExRjUyUFNHUUE5V1ZER1FENFI='
  //   };

  //   var request = http.MultipartRequest('POST',
  //       Uri.parse('https://ext.digio.in:444/v2/client/document/upload'));
  //   // request.fields.addAll({
  //   //   "request":
  //   //       "{"'signers'": [{"'identifier'": "'parmarprit100@gmail.com'","'name'":"'SANKET NAYAK'","'sign_type'": "'aadhaar'","'reason'": "'Loan Agreement'"}],"'expire_in_days'": 10,"'display_on_page'": "'all'"}"
  //   // });
  //   // request.files.add(await http.MultipartFile.fromPath('file',
  //   //     '/C:/Users/user/Downloads/photo-1565234574056-1c53de66ecb9.pdf'));
  //   request.files.add(
  //     await http.MultipartFile.fromBytes('file', selectedFile,
  //         contentType: new MediaType('application', 'octet-stream'),
  //         filename: 'test.mp4'),
  //   );
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     print(response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

  sendEsignPDFDetailsAPI(PlatformFile selectedFile, PlatformFile objFile,
      String screenName) async {
    /*
    var headers = {
      "Accept": "application/json",
      'Authorization':
          'Basic QUlPOE9TTVE3VVFHTFpGQkU0WVJBQ0ZIVE9PS0VQOUI6NDhMR1BYNVpJUFdOVVExRjUyUFNHUUE5V1ZER1FENFI=',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Allow-Headers':
          'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale',
      'Access-Control-Allow-Methods': 'POST, OPTIONS'
    };
    */
    // var headers = {
    //   'Authorization':
    //       'Basic QUlPOE9TTVE3VVFHTFpGQkU0WVJBQ0ZIVE9PS0VQOUI6NDhMR1BYNVpJUFdOVVExRjUyUFNHUUE5V1ZER1FENFI='
    // };
    var panDetails;

    var globalRespObj = LoginRepository.loginDetailsResObjGlobal;
    if (PanDetailRepository.userPanNumber != null &&
        PanDetailRepository.userPanNumber != "") {
      panDetails = PanDetailRepository.userPanNumber;
    } else {
      if (globalRespObj != null) {
        if (globalRespObj.response.errorCode == "0") {
          panDetails = globalRespObj.response.data.message[0].pan;
        }
      }
    }
    // String req =
    //     "{\"signers\":[{\"identifier\":\"parmarprit100@gmail.com\",\"name\":\"SANKET NAYAK\",\"sign_type\":\"aadhaar\",\"reason\":\"Loan Agreement\"}],\"expire_in_days\":10,\"display_on_page\":\"all\"}";
    // var request = http.MultipartRequest('POST',
    //     Uri.parse('https://ext.digio.in:444/v2/client/document/upload'));
    var url = AppConfig().url + "uploadpdfFile";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    // request.headers["Access-Control-Allow-Origin"] = "*";
    // request.headers["Access-Control-Allow-Credentials"] = "true";
    // request.headers["Access-Control-Allow-Headers"] =
    //     "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale";
    // request.headers["Access-Control-Allow-Methods"] = "POST, OPTIONS";
    //    request.headers["Authorization"] = "Basic QUlPOE9TTVE3VVFHTFpGQkU0WVJBQ0ZIVE9PS0VQOUI6NDhMR1BYNVpJUFdOVVExRjUyUFNHUUE5V1ZER1FENFI=";

    // request.fields['request'] = req.toString();
    request.fields['email_id'] = LoginRepository.loginEmailId;
    request.fields['mobile_no'] = LoginRepository.loginMobileNo;
    request.fields['imageName'] = panDetails + "Addhar";
    request.fields['name'] = LoginRepository.loginFullName;

    // request.files.add(new http.MultipartFile(
    //     "file", objFile.readStream, objFile.size,
    //     filename: objFile.name));

    // request.files.add(http.MultipartFile(
    //     'file',
    //     File(objFile.path).readAsBytes().asStream(),
    //     File(objFile.path).lengthSync(),
    //     filename: objFile.path.split("/").last));

    // http.MultipartFile.fromBytes('file', File(objFile).readAsBytesSync(),
    //     filename: objFile.path.split("/").last);
    // request.files
    //     .add(await http.MultipartFile.fromPath('file', objFile.path)); //

    // // for mobile video upload

    // request.files.add(http.MultipartFile(
    //     'file',
    //     File(objFile).readAsBytes().asStream(),
    //     File(objFile).lengthSync(),
    //     filename: objFile.split("/").last));
    // request.files.add(await http.MultipartFile.fromPath('file', objFile.path));
    if (screenName.contains("large")) {
      // for web video upload
      request.files.add(new http.MultipartFile(
          "pdf_path", selectedFile.readStream, selectedFile.size,
          filename: selectedFile.name));
    } else {
      // for mobile video upload
      // List<int> imageData = File(MobileFile).readAsBytesSync();
      // request.files.add(
      //   await http.MultipartFile.fromBytes(
      //     'file',
      //     imageData,
      //   ),
      // );
      request.files.add(new http.MultipartFile(
          "pdf_path", objFile.readStream, objFile.size,
          filename: objFile.name));
    }
    //request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      print(responseData);
      final loginResponseObj = Digiouploadresponse.fromJson(
        json.decode(
          responseData.toString(),
        ),
      );

      return loginResponseObj;
    } else {
      print(response.reasonPhrase);
    }
  }

  fetchResults(BuildContext context, String screenName) async {
    // Your fetchResult logic here
    // ignore: unused_local_variable
    AppConfig().showLoaderDialog(context); //// show loader
    final loginAPIClient = http.Client();
    final url = AppConfig().url;
    var apiName = url +
        "getEkycUserDetails?email_id=" +
        LoginRepository.loginEmailId +
        "&mobile_no=" +
        LoginRepository.loginMobileNo +
        "";

    final response = await http.get(
      Uri.parse(apiName),
    );

    if (response.statusCode == 200) {
      print(response.body);

      final loginResponseObj =
          LoginUserDetailModelResponse.fromJson(json.decode(response.body));

      if (loginResponseObj.response.data.message[0].esign == "0") {
        print("You can now write pdf");
        timerObj?.cancel();
        timerObj = null;
        AppConfig().dismissLoaderDialog(context); //// hide loader
        _signPDF(context, screenName);
        return true;
      } else {
        timerObj ??= Timer.periodic(Duration(seconds: 3), (timer) {
          print("waiting for response");
          AppConfig().dismissLoaderDialog(context); //// hide loader

          fetchResults(context, screenName);
        });
        // await Future.delayed(Duration(seconds: 3));

      }
    } else {}
  }

  Future<List<int>> _readDocumentData(String name,
      [bool isImage = false]) async {
    final ByteData data = await rootBundle
        .load(isImage ? 'asset/images/$name' : 'asset/pdf/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<void> _signPDF(BuildContext context, String screenName) async {
    if (globalRespObj != null) {
      AppConfig().showLoaderDialog(context); // show loader
      print('Data already is in global object');
      if (globalRespObj.response.errorCode == "0") {
        //Load the PDF document.
        final PdfDocument document =
            PdfDocument(inputBytes: await _readDocumentData('MasterForm.pdf'));

        //Get the signature field.
        // final PdfSignatureField signatureField =
        //     document.form.fields[6] as PdfSignatureField;

        //Gets the first page from the document
        PdfPage page = document.pages[4];

        // Draw image
        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(234, 179, 5, 5));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(235, 207, 5, 5));
//Draw the text
        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].firstname1 + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(180, 240, 200, 20));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].middlename1 + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(320, 240, 200, 20));
        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].lastname1 + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(455, 240, 200, 20));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].firstname2 + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(180, 265, 200, 20));
        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].middlename2 + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(320, 265, 200, 20));
        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].lastname2 + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(455, 265, 200, 20));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].dob + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(150, 297, 200, 20));

        if (globalRespObj.response.data.message[0].gender == "male" ||
            globalRespObj.response.data.message[0].gender == "Male") {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(139, 316, 5, 5));
        } else if (globalRespObj.response.data.message[0].gender == "female" ||
            globalRespObj.response.data.message[0].gender == "Female") {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(263, 316, 5, 5));
        } else {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(345, 316, 5, 5));
        }

        if (globalRespObj.response.data.message[0].maritalstatus == "married" ||
            globalRespObj.response.data.message[0].maritalstatus == "Married") {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(139, 332, 5, 5));
        } else if (globalRespObj.response.data.message[0].maritalstatus ==
                "single" ||
            globalRespObj.response.data.message[0].maritalstatus == "Single") {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(263, 332, 5, 5));
        } else {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(345, 332, 5, 5));
        }
        if (globalRespObj.response.data.message[0].nationality == "Indian" ||
            globalRespObj.response.data.message[0].nationality == "indian") {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(139, 346, 5, 5));
        }
        if (globalRespObj.response.data.message[0].pan != "" ||
            globalRespObj.response.data.message[0].pan != null) {
          page.graphics.drawString(
              '' + globalRespObj.response.data.message[0].pan + '',
              PdfStandardFont(PdfFontFamily.helvetica, 11),
              bounds: Rect.fromLTWH(139, 485, 200, 20));
        }
        try {
          Uri uri1 = Uri.parse(uRl +
              "images/" +
              globalRespObj.response.data.message[0].photograph);
          http.Response response1 = await http.get(
            uri1,
          );
          Uint8List photograph = response1.bodyBytes;

          photograph.buffer
              .asUint8List(photograph.offsetInBytes, photograph.lengthInBytes);
          page.graphics.drawImage(
              PdfBitmap(photograph), const Rect.fromLTWH(502, 318, 79, 85));
        } catch (error) {
          print('error fetching photograph:$error');
        }

        try {
          Uri uri = Uri.parse(uRl +
              "images/" +
              globalRespObj.response.data.message[0].signature);
          response = await http.get(
            uri,
          );
          signature = response.bodyBytes;
          signature.buffer
              .asUint8List(signature.offsetInBytes, signature.lengthInBytes);
          page.graphics.drawImage(
              PdfBitmap(signature), const Rect.fromLTWH(501, 405, 80, 20));
        } catch (error) {
          print('error fetching signature:$error');
        }

        page = document.pages[5];

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].mobileNo + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(470, 195, 200, 20));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].emailId + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(300, 205, 200, 20));
        try {
          signature = response.bodyBytes;
          signature.buffer
              .asUint8List(signature.offsetInBytes, signature.lengthInBytes);
          page.graphics.drawImage(
              PdfBitmap(signature), const Rect.fromLTWH(465, 335, 110, 30));
        } catch (error) {
          print('error fetching signature::$error');
        }
        dynamic currentTime = DateFormat.jm().format(DateTime.now());
        var now = new DateTime.now();
        var formatter = new DateFormat('dd-MM-yyyy');
        String formattedDate = formatter.format(now);
        page.graphics.drawString('' + formattedDate + " " + currentTime + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(60, 370, 200, 20));

        page = document.pages[6];
        if (globalRespObj.response.data.message[0].bankname != "" ||
            globalRespObj.response.data.message[0].bankname != null) {
          page.graphics.drawString(
              '' + globalRespObj.response.data.message[0].bankname + '',
              PdfStandardFont(PdfFontFamily.helvetica, 8),
              bounds: Rect.fromLTWH(28, 168, 200, 20));
        }
        if (globalRespObj.response.data.message[0].accountnumber != "" ||
            globalRespObj.response.data.message[0].accountnumber != null) {
          page.graphics.drawString(
              '' + globalRespObj.response.data.message[0].accountnumber + '',
              PdfStandardFont(PdfFontFamily.helvetica, 8),
              bounds: Rect.fromLTWH(262, 168, 200, 20));
        }
        if (globalRespObj.response.data.message[0].ifsccode != "" ||
            globalRespObj.response.data.message[0].ifsccode != null) {
          page.graphics.drawString(
              '' + globalRespObj.response.data.message[0].ifsccode + '',
              PdfStandardFont(PdfFontFamily.helvetica, 8),
              bounds: Rect.fromLTWH(520, 168, 200, 20));
        }

        if (globalRespObj.response.data.message[0].nseCash != "" ||
            globalRespObj.response.data.message[0].nseCash != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(35, 435, 7, 7));
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(35, 449, 7, 7));
        }
        if (globalRespObj.response.data.message[0].bseCash != "" ||
            globalRespObj.response.data.message[0].bseCash != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(35, 471, 7, 7));
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(35, 485, 7, 7));
        }
        if (globalRespObj.response.data.message[0].nseFo != "" ||
            globalRespObj.response.data.message[0].nseFo != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(173, 435, 7, 7));
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(173, 451, 7, 7));
        }
        if (globalRespObj.response.data.message[0].bseFo != "" ||
            globalRespObj.response.data.message[0].bseFo != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(173, 473, 7, 7));
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(173, 490, 7, 7));
        }
        if (globalRespObj.response.data.message[0].nseCurrency != "" ||
            globalRespObj.response.data.message[0].nseCurrency != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(310, 435, 7, 7));
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(312, 448, 7, 7));
        }
        if (globalRespObj.response.data.message[0].bseCurrency != "" ||
            globalRespObj.response.data.message[0].bseCurrency != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(312, 473, 7, 7));
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(313, 487, 7, 7));
        }
        if (globalRespObj.response.data.message[0].mcxCommodty != "" ||
            globalRespObj.response.data.message[0].mcxCommodty != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(35, 507, 7, 7));
        }

        if (globalRespObj.response.data.message[0].incomerange ==
                "BELOW 1 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(39, 565, 7, 7));
        } else if (globalRespObj.response.data.message[0].incomerange ==
                "1 LAKH TO 5 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(127, 566, 7, 7));
        } else if (globalRespObj.response.data.message[0].incomerange ==
                "5 LAKH TO 10 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(221, 566, 7, 7));
        } else if (globalRespObj.response.data.message[0].incomerange ==
                "10 LAKH TO 25 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(321, 566, 7, 7));
        } else if (globalRespObj.response.data.message[0].incomerange ==
                "ABOVE 25 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(425, 566, 7, 7));
        } else {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(530, 566, 7, 7));
        }
        if (globalRespObj.response.data.message[0].action ==
                "Politically Exposed Person" &&
            globalRespObj.response.data.message[0].action != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(42, 692, 7, 7));
        }

        page.graphics.drawString(
            ' N/A ', PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(150, 708, 200, 20));

        page = document.pages[7];

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].pan + ' ',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(150, 200, 200, 20));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(125, 717, 7, 7));

        page = document.pages[8];

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(480, 602, 7, 7));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].emailId + ' ',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(225, 622, 200, 20));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(494, 652, 7, 7));

        page = document.pages[9];

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].emailId + ' ',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(70, 404, 200, 20));
        page.graphics.drawString('' + formattedDate + " " + currentTime + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(70, 434, 200, 20));

        page = document.pages[11];

        page.graphics.drawString('' + formattedDate + " " + currentTime + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(410, 126, 100, 20));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].pan + ' ',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(410, 208, 200, 20));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(38, 418, 7, 7));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(147, 399, 7, 7));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(445, 555, 7, 7));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(445, 581, 7, 7));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(513, 612, 7, 7));
        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(445, 638, 7, 7));
        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(402, 660, 7, 7));
        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(448, 700, 7, 7));

        page = document.pages[12];

        page.graphics.drawString('' + formattedDate + " " + currentTime + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(190, 100, 100, 20));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].ifsccode + ' ',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(190, 118, 200, 20));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].accountnumber + ' ',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(190, 136, 300, 20));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(221, 155, 7, 7));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].bankname + ' ',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(190, 172, 300, 20));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].bankname + ' ',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(190, 189, 300, 20));
        if (globalRespObj.response.data.message[0].resAddr2 == "" &&
            globalRespObj.response.data.message[0].resAddr2 != null) {
          page.graphics.drawString(
              '' + globalRespObj.response.data.message[0].resAddr2 + ' ',
              PdfStandardFont(PdfFontFamily.helvetica, 11),
              bounds: Rect.fromLTWH(190, 223, 300, 20));
        }
        if (globalRespObj.response.data.message[0].resAddrCity == "" &&
            globalRespObj.response.data.message[0].resAddrCity != null) {
          page.graphics.drawString(
              '' + globalRespObj.response.data.message[0].resAddrCity + ' ',
              PdfStandardFont(PdfFontFamily.helvetica, 11),
              bounds: Rect.fromLTWH(200, 242, 300, 20));
        }
        if (globalRespObj.response.data.message[0].resAddrState == "" &&
            globalRespObj.response.data.message[0].resAddrState != null) {
          page.graphics.drawString(
              '' + globalRespObj.response.data.message[0].resAddrState + ' ',
              PdfStandardFont(PdfFontFamily.helvetica, 11),
              bounds: Rect.fromLTWH(350, 242, 300, 20));
        }

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].nationality + ' ',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(500, 242, 300, 20));
        if (globalRespObj.response.data.message[0].resAddrPincode == "" &&
            globalRespObj.response.data.message[0].resAddrPincode != null) {
          page.graphics.drawString(
              '' + globalRespObj.response.data.message[0].resAddrPincode + ' ',
              PdfStandardFont(PdfFontFamily.helvetica, 11),
              bounds: Rect.fromLTWH(110, 261, 300, 20));
        }

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].mobileNo + ' ',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(300, 352, 300, 20));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(428, 355, 7, 7));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(173, 432, 7, 7));

        page = document.pages[13];

        page.graphics.drawString(
            '0.20', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(300, 141, 300, 20));

        page.graphics.drawString(
            '0.02', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(500, 141, 300, 20));

        page.graphics.drawString(
            '0.02', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(300, 160, 300, 20));

        page.graphics.drawString(
            '0.02', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(500, 160, 300, 20));

        page.graphics.drawString(
            '0.02', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(265, 217, 300, 20));

        page.graphics.drawString(
            '0.02', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(390, 217, 300, 20));

        page.graphics.drawString(
            '30/-', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(500, 217, 300, 20));

        page.graphics.drawString(
            '0.02', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(265, 235, 300, 20));

        page.graphics.drawString(
            '0.02', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(390, 235, 300, 20));

        page.graphics.drawString(
            '30/-', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(500, 235, 300, 20));

        page.graphics.drawString(
            '0.01', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(300, 300, 300, 20));

        page.graphics.drawString(
            '10/-', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(500, 300, 300, 20));

        page.graphics.drawString(
            '0.01', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(265, 370, 300, 20));

        page.graphics.drawString(
            '0.01', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(390, 370, 300, 20));

        page.graphics.drawString(
            '0.01', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(500, 370, 300, 20));

        page.graphics.drawString(
            '0.01', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(265, 385, 300, 20));

        page.graphics.drawString(
            '0.01', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(390, 385, 300, 20));

        page.graphics.drawString(
            '0.01', PdfStandardFont(PdfFontFamily.helvetica, 11),
            brush: PdfBrushes.red, bounds: Rect.fromLTWH(500, 385, 300, 20));

        page = document.pages[14];

        page.graphics.drawString('' + formattedDate + " " + currentTime + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(475, 121, 100, 20));

        page = document.pages[15];

        page.graphics.drawString('' + formattedDate + " " + currentTime + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(475, 100, 100, 20));

        page = document.pages[16];

        page.graphics.drawString('' + formattedDate + " " + currentTime + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(475, 365, 100, 20));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(48, 586, 7, 7));

        page = document.pages[17];

        page.graphics.drawString('' + formattedDate + " " + currentTime + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(475, 136, 100, 20));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(164, 323, 7, 7));

        page = document.pages[18];

        page.graphics.drawString('' + formattedDate + " " + currentTime + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(475, 130, 100, 20));
        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].emailId + ' ',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(55, 322, 200, 20));

        page = document.pages[19];

        page.graphics.drawString('' + formattedDate + " " + currentTime + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(475, 132, 100, 20));
        page.graphics.drawString(
            '' +
                globalRespObj.response.data.message[0].firstname1 +
                '   ' +
                globalRespObj.response.data.message[0].middlename1 +
                '  ' +
                globalRespObj.response.data.message[0].lastname1 +
                '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(370, 185, 200, 20));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].accountnumber + ' ',
            PdfStandardFont(PdfFontFamily.helvetica, 10),
            bounds: Rect.fromLTWH(165, 374, 200, 20));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].pan + ' ',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(498, 362, 200, 20));

        page = document.pages[22];

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].mobileNo + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(180, 324, 200, 20));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].emailId + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(150, 390, 200, 20));
        if (globalRespObj.response.data.message[0].parmAddrState == "" &&
            globalRespObj.response.data.message[0].parmAddrState != null) {
          page.graphics.drawString(
              '' + globalRespObj.response.data.message[0].parmAddrState + '',
              PdfStandardFont(PdfFontFamily.helvetica, 11),
              bounds: Rect.fromLTWH(86, 487, 100, 20));
        }

        page.graphics.drawString('' + formattedDate + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(477, 489, 100, 20));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(63, 532, 7, 7));

        page = document.pages[24];

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].pan + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(130, 134, 200, 20));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].pan + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(480, 134, 200, 20));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].nationality + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(140, 199, 100, 20));

        page.graphics.drawString(
            '' + globalRespObj.response.data.message[0].nationality + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(420, 178, 100, 20));

        if (globalRespObj.response.data.message[0].incomerange ==
                "BELOW 1 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(154, 223, 7, 7));
        } else if (globalRespObj.response.data.message[0].incomerange ==
                "1 LAKH TO 5 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(275, 223, 7, 7));
        } else if (globalRespObj.response.data.message[0].incomerange ==
                "5 LAKH TO 10 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(407, 223, 7, 7));
        } else if (globalRespObj.response.data.message[0].incomerange ==
                "10 LAKH TO 25 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(154, 239, 7, 7));
        } else if (globalRespObj.response.data.message[0].incomerange ==
                "ABOVE 25 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(275, 239, 7, 7));
        } else {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(407, 239, 7, 7));
        }

        page.graphics.drawString('' + formattedDate + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(470, 260, 100, 20));

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(369, 353, 7, 7));

        page.graphics.drawString('' + formattedDate + '',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(135, 627, 100, 20));
        if (globalRespObj.response.data.message[0].parmAddrState == "" &&
            globalRespObj.response.data.message[0].parmAddrState != null) {
          page.graphics.drawString(
              '' + globalRespObj.response.data.message[0].parmAddrState + '',
              PdfStandardFont(PdfFontFamily.helvetica, 11),
              bounds: Rect.fromLTWH(450, 627, 100, 20));
        }

        page = document.pages[25];

        page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(174, 619, 7, 7));

        page = document.pages[26];

        page.graphics.drawString('' + formattedDate + '',
            PdfStandardFont(PdfFontFamily.helvetica, 9),
            bounds: Rect.fromLTWH(103, 456, 100, 20));
        if (globalRespObj.response.data.message[0].parmAddrCity == "" &&
            globalRespObj.response.data.message[0].parmAddrCity != null) {
          page.graphics.drawString(
              '' + globalRespObj.response.data.message[0].parmAddrCity + '',
              PdfStandardFont(PdfFontFamily.helvetica, 9),
              bounds: Rect.fromLTWH(190, 456, 100, 20));
        }

        // START Edited by sushant
        page = document.pages[27];
        //Draw the text
        String fatherSpouse = ' ' +
            globalRespObj.response.data.message[0].firstname2 +
            ' ' +
            globalRespObj.response.data.message[0].middlename2 +
            ' ' +
            globalRespObj.response.data.message[0].lastname2;
        page.graphics.drawString(
          fatherSpouse,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(170, 120, 200, 15),
        );
        try {
          Uri uri11 = Uri.parse(uRl +
              "images/" +
              globalRespObj.response.data.message[0].photograph);
          http.Response response11 = await http.get(
            uri11,
          );
          Uint8List data1 = response11.bodyBytes;
          data1.buffer.asUint8List(data1.offsetInBytes, data1.lengthInBytes);
          page.graphics.drawImage(
            PdfBitmap(data1),
            const Rect.fromLTWH(467, 120, 79, 85),
          );
        } catch (error) {
          print('error fetching photograph :$error');
        }
        if (globalRespObj.response.data.message[0].gender == "Male" &&
            globalRespObj.response.data.message[0].gender != null) {
          page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(126, 149, 4, 4),
          );
        } else {
          page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(155, 149, 4, 4),
          );
        }

        if (globalRespObj.response.data.message[0].maritalstatus == "Single" &&
            globalRespObj.response.data.message[0].maritalstatus != null) {
          page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(240, 150, 4, 4),
          );
        } else {
          page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(266, 150, 4, 4),
          );
        }

        page.graphics.drawString(
          ' ' + globalRespObj.response.data.message[0].dob + ' ',
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(349, 144, 100, 15),
        );

        if (globalRespObj.response.data.message[0].nationality != "Indian" &&
            globalRespObj.response.data.message[0].nationality != null) {
          page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(137, 163, 3, 3),
          );
        } else {
          page.graphics.drawImage(
            PdfBitmap(await _readDocumentData('right_tick.png', true)),
            const Rect.fromLTWH(166, 163, 3, 3),
          );

          page.graphics.drawString(
            ' ' + globalRespObj.response.data.message[0].nationality + ' ',
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(190, 154, 100, 15),
          );
        }

        page.graphics.drawImage(
          PdfBitmap(await _readDocumentData('right_tick.png', true)),
          const Rect.fromLTWH(162, 176, 4, 4),
        );

        page.graphics.drawString(
          ' ' + globalRespObj.response.data.message[0].pan + ' ',
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(113, 187, 100, 13),
        );

        var obj = globalRespObj.response.data.message[0];
        String resAddress = '';
        if (obj.resAddr1 == "" &&
            obj.resAddr1 != null &&
            obj.resAddr2 == "" &&
            obj.resAddr2 != null) {
          resAddress = ' ' + obj.resAddr1 + ' ' + obj.resAddr2 + ' ';
        }
        page.graphics.drawString(
          resAddress,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(113, 258, 150, 15),
        );
        if (obj.resAddrCity != "" && obj.resAddrCity != null) {
          page.graphics.drawString(
            obj.resAddrCity,
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(152, 278, 150, 15),
          );
        }
        if (obj.resAddrState != "" && obj.resAddrState != null) {
          page.graphics.drawString(
            obj.resAddrState,
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(122, 290, 150, 15),
          );
        }
        if (obj.resAddrPincode != "" && obj.resAddrPincode != null) {
          page.graphics.drawString(
            obj.resAddrPincode,
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(478, 280, 150, 15),
          );
        }
        page.graphics.drawString(
          obj.nationality,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(367, 290, 150, 15),
        );

        page.graphics.drawString(
          obj.mobileNo,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(145, 320, 150, 15),
        );

        page.graphics.drawString(
          obj.emailId,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(145, 330, 250, 15),
        );
        String perAddress = '';
        if (obj.parmAddr1 == "" &&
            obj.parmAddr1 != null &&
            obj.parmAddr2 == "" &&
            obj.parmAddr2 != null) {
          perAddress = ' ' + obj.parmAddr1 + ' ' + obj.parmAddr2 + ' ';
        }
        page.graphics.drawString(
          perAddress,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(114, 400, 150, 15),
        );
        if (obj.parmAddrCity != "" && obj.parmAddrCity != null) {
          page.graphics.drawString(
            obj.parmAddrCity,
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(149, 420, 150, 15),
          );
        }
        if (obj.parmAddrState != "" && obj.parmAddrState != null) {
          page.graphics.drawString(
            obj.parmAddrState,
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(122, 430, 150, 15),
          );
        }
        if (obj.parmAddrPincode != "" && obj.parmAddrPincode != null) {
          page.graphics.drawString(
            obj.parmAddrPincode,
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(478, 420, 150, 15),
          );
        }
        page.graphics.drawString(
          obj.nationality,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(365, 427, 150, 15),
        );

        if (globalRespObj.response.data.message[0].incomerange ==
                "BELOW 1 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(256, 509, 4, 4));
        } else if (globalRespObj.response.data.message[0].incomerange ==
                "1 LAKH TO 5 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(313, 509, 4, 4));
        } else if (globalRespObj.response.data.message[0].incomerange ==
                "5 LAKH TO 10 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(355, 509, 4, 4));
        } else if (globalRespObj.response.data.message[0].incomerange ==
                "10 LAKH TO 25 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(401, 509, 4, 4));
        } else if (globalRespObj.response.data.message[0].incomerange ==
                "ABOVE 25 LAKH" &&
            globalRespObj.response.data.message[0].incomerange != null) {
          page.graphics.drawImage(
              PdfBitmap(await _readDocumentData('right_tick.png', true)),
              const Rect.fromLTWH(450, 509, 4, 4));
        }

        page.graphics.drawString(
          '' + formattedDate + " ",
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(375, 522, 100, 20),
        );
        if (obj.resAddrCity != "" && obj.resAddrCity != null) {
          page.graphics.drawString(
            obj.resAddrCity,
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(110, 650, 100, 20),
          );
        }
        page.graphics.drawString(
          '' + formattedDate + '',
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(330, 650, 100, 20),
        );

        page = document.pages[30];
        if (obj.resAddrCity != "" && obj.resAddrCity != null) {
          page.graphics.drawString(
            obj.resAddrCity,
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(100, 270, 100, 20),
          );
        }
        page.graphics.drawString(
          formattedDate,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(274, 270, 100, 20),
        );

        page = document.pages[31];

        page.graphics.drawString(
          formattedDate,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(170, 100, 100, 20),
        );

        page.graphics.drawString(
          obj.mobileNo,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(170, 220, 100, 20),
        );

        page.graphics.drawString(
          obj.emailId,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(170, 234, 200, 20),
        );

        page = document.pages[33];

        page.graphics.drawString(
          formattedDate,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(510, 51, 100, 20),
        );

        page.graphics.drawString(
          obj.mobileNo,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(100, 351, 100, 20),
        );

        page.graphics.drawString(
          obj.emailId,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(100, 373, 200, 20),
        );

        page.graphics.drawString(
          obj.emailId,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(130, 742, 200, 15),
        );

        page = document.pages[51];

        page.graphics.drawString(
          obj.emailId,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(235, 400, 200, 20),
        );

        page.graphics.drawString(
          obj.pan,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(130, 567, 100, 20),
        );

        page.graphics.drawString(
          formattedDate,
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(120, 600, 200, 20),
        );
        if (obj.resAddrCity != "" && obj.resAddrCity != null) {
          page.graphics.drawString(
            obj.resAddrCity,
            PdfStandardFont(PdfFontFamily.helvetica, 11),
            bounds: Rect.fromLTWH(120, 612, 200, 15),
          );
        }

        //END by sushant
        try {
          Uri uri1 = Uri.parse(uRl +
              "images/" +
              globalRespObj.response.data.message[0].photograph);
          http.Response response1 = await http.get(
            uri1,
          );
          Uint8List photograph = response1.bodyBytes;

          photograph.buffer
              .asUint8List(photograph.offsetInBytes, photograph.lengthInBytes);
          document.pages.add().graphics.drawImage(
              PdfBitmap(photograph), const Rect.fromLTWH(50, 25, 400, 800));
        } catch (error) {
          print('error fetching photograph:$error');
        }
        // add pan image
        try {
          Uri uri2 = Uri.parse(
              uRl + "images/" + globalRespObj.response.data.message[0].pancard);
          http.Response response2 = await http.get(
            uri2,
          );
          Uint8List pan = response2.bodyBytes;
          pan.buffer.asUint8List(pan.offsetInBytes, pan.lengthInBytes);
          document.pages
              .add()
              .graphics
              .drawImage(PdfBitmap(pan), const Rect.fromLTWH(50, 25, 400, 800));
        } catch (error) {
          print('error fetching pancard :$error');
        }
        // add pan image
        try {
          // add addhar image
          Uri uri3 = Uri.parse(uRl +
              "images/" +
              globalRespObj.response.data.message[0].addressproof);
          http.Response response3 = await http.get(
            uri3,
          );
          Uint8List addhar = response3.bodyBytes;
          addhar.buffer.asUint8List(addhar.offsetInBytes, addhar.lengthInBytes);
          document.pages.add().graphics.drawImage(
              PdfBitmap(addhar), const Rect.fromLTWH(50, 25, 400, 800));
        } catch (error) {
          print('error fetching addressproof :$error');
        }
        // add pan image

        // add pan image

        // add signature image
        try {
          document.pages.add().graphics.drawImage(
              PdfBitmap(signature), const Rect.fromLTWH(50, 25, 400, 800));
        } catch (error) {
          print('error fetching signature :$error');
        }

        // // add bankproof image
        //     try {
        //       Uri uri4 = Uri.parse(uRl +
        //           "images/" +
        //           globalRespObj.response.data.message[0].pan +
        //           "bankproof" +
        //           globalRespObj.response.data.message[0].uniqueId +
        //           ".pdf");
        //       http.Response response4 = await http.get(
        //         uri4,
        //       );
        //       Uint8List bankproof = response4.bodyBytes;
        //       bankproof.buffer
        //           .asUint8List(bankproof.offsetInBytes, bankproof.lengthInBytes);
        //       document.pages.add().graphics.drawImage(
        //           PdfBitmap(bankproof), const Rect.fromLTWH(50, 25, 400, 800));
        //     } catch (error) {
        //       print('error fetching bankproof :$error');
        //     }
        //     // add incomeproof image
        //     try {
        //       Uri uri5 = Uri.parse(uRl +
        //           "images/" +
        //           globalRespObj.response.data.message[0].pan +
        //           "incomeproof" +
        //           globalRespObj.response.data.message[0].uniqueId +
        //           ".pdf");
        //       http.Response response5 = await http.get(
        //         uri5,
        //       );

        //       Uint8List incomeproof = response5.bodyBytes;

        //       document.pages.add().graphics.drawImage(
        //           PdfBitmap(incomeproof), const Rect.fromLTWH(50, 25, 400, 800));
        //     } catch (error) {
        //       print('error fetching incomeproof :$error');
        //     }
        // add incomeproof image

        //Save the PDF document
        final List<int> bytes = document.save();
        //Dispose the document.
        document.dispose();

        var flag = await sendKycPDFDocument(
            context,
            "large",
            bytes,
            "",
            globalRespObj.response.data.message[0].bankproof,
            globalRespObj.response.data.message[0].incomeproof,
            globalRespObj.response.data.message[0].pan);
        //Save and launch file.
        if (flag == "0") {
          try {
            Uri uri4 = Uri.parse(uRl +
                "images/" +
                globalRespObj.response.data.message[0].pan +
                "FinalEKycDocument.pdf");
            http.Response response4 = await http.get(
              uri4,
            );
            Uint8List bankproof = response4.bodyBytes;
            bankproof.buffer
                .asUint8List(bankproof.offsetInBytes, bankproof.lengthInBytes);

            await FileSaveHelper.saveAndLaunchFile(
                bankproof, globalRespObj.response.data.message[0].pan + '.pdf');
            AppConfig().dismissLoaderDialog(context); //// dismiss loader
            showAlert(context, "Download completed successfully", screenName);
          } catch (error) {
            AppConfig().dismissLoaderDialog(context); //// dismiss loader
            showAlert(context, "Try again" + error.toString(), screenName);
            print('error fetching kycdocument :$error');
          }
        } else {
          AppConfig().dismissLoaderDialog(context); //// dismiss loader
          showAlert(context, "Esign authorization failed. ", screenName);
        }
      }
    } else {
      AppConfig().dismissLoaderDialog(context); //// dismiss loader
    }
  }

  sendKycPDFDocument(
    BuildContext context,
    String screenName,
    List<int> selectedFile,
    String mobilevideopath,
    String bank_proof,
    String income_proof,
    String pan,
  ) async {
    try {
      // AppConfig().showLoaderDialog(context); // show loader

      final obj = await sendKycPDFDocumentRequest(
          screenName, selectedFile, mobilevideopath);
      // AppConfig().dismissLoaderDialog(context); //// dismiss loader
      if (obj == 0) {
        ResponseModel obj =
            await pdfMergeRequest(bank_proof, income_proof, pan);

        if (obj.response.errorCode == "0") {
          return "0";
        } else if (obj.response.errorCode == "1") {
          showAlert(context, "Esign authorization failed. ", screenName);
          return "1";
        }
      } else if (obj == 1) {
        showAlert(context, "Esign authorization failed. ", screenName);
        return "1";
      }
    } catch (exception) {
      // AppConfig().dismissLoaderDialog(context); //// dismiss loader
      print("no data" + exception.toString());

      showAlert(context, "Try again" + exception.toString(), screenName);
      return "1";
    }
  }

  Future<int> sendKycPDFDocumentRequest(
      String screenname, List<int> selectedFile, String mobilevideopath) async {
    // FilePickerResult results = await FilePicker.platform.pickFiles();
    // File result = File(results.files, "pancard");

    var ipvDetails;

    var globalRespObj = LoginRepository.loginDetailsResObjGlobal;
    if (PanDetailRepository.userPanNumber != null &&
        PanDetailRepository.userPanNumber != "") {
      ipvDetails = PanDetailRepository.userPanNumber;
    } else {
      if (globalRespObj != null) {
        if (globalRespObj.response.errorCode == "0") {
          ipvDetails = globalRespObj.response.data.message[0].pan;
        }
      }
    }
    var url = AppConfig().url + "uploadKYCPdFFile";

    Uri uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);

    //request.headers.addAll(requestHeaders);
    // request.headers["<custom header>"] = "content";
    request.fields['email_id'] = LoginRepository.loginEmailId;
    request.fields['mobile_no'] = LoginRepository.loginMobileNo;
    // request.fields['name'] = LoginRepository.login_full_name;
    request.fields['imageName'] = ipvDetails + "KycDocument";

    if (screenname.contains("large")) {
      // for web video upload
      // print("pdf large bytes data" + selectedFile.toString());

      request.files.add(
        await http.MultipartFile.fromBytes('pdf_path', selectedFile,
            contentType: new MediaType('application', 'octet-stream'),
            filename: 'test.pdf'),
      );

      // request.files.add(new http.MultipartFile(
      //     "pdf_path", selectedFile.readStream, selectedFile.size,
      //     filename: selectedFile.name));
    } else {
      // for mobile video upload
      List<int> imageData = File(mobilevideopath).readAsBytesSync();
      request.files.add(
        await http.MultipartFile.fromBytes('pdf_path', imageData,
            contentType: new MediaType('application', 'octet-stream'),
            filename: 'test.pdf'),
      );
    }

    final uploadResponse = await request.send();
    final response = await http.Response.fromStream(uploadResponse);

    var flag = 0;
    if (response.statusCode == 200) {
      flag = 0;
      return flag;
    } else {
      flag = 1;
      return flag;
    }
  }

  Future<dynamic> showAlert(BuildContext ctx, String msg, String screenname) {
    return showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: Text("E-KYC"),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (msg == "Video uploaded") {
                if (screenname.toString().contains("small")) {
                  HomeScreenSmall.screensStreamSmall.sink
                      .add(Ekycscreenamesmall.esigndetailscreen);
                } else {
                  HomeScreenLarge.screensStreamLarge.sink
                      .add(Ekycscreenamelarge.esigndetailscreen);
                }
              }
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  pdfMergeRequest(String bank_proof, String income_proof, String pan) async {
    final url = AppConfig().url;
    var apiName = url +
        "pdfMerger?bank_proof=" +
        bank_proof +
        "&income_proof=" +
        income_proof +
        "&pan=" +
        pan;

    final response = await http.get(
      Uri.parse(apiName),
    );

    if (response.statusCode == 200) {
      final loginResponseObj =
          ResponseModel.fromJson(json.decode(response.body));

      return loginResponseObj;
    } else {
      print(response.reasonPhrase);
    }
  }
}
