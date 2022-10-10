import 'package:e_kyc/Login/UI/Configuration/AppConfig.dart';
import 'package:e_kyc/Login/UI/HomeScreen/HomeScreenLarge.dart';
import 'package:e_kyc/Login/UI/HomeScreen/HomeScreenSmall.dart';
import 'package:e_kyc/Login/UI/Login/model/LoginUserDetailModelResponse.dart';
import 'package:e_kyc/Login/UI/Login/repository/LoginRepository.dart';
import 'package:e_kyc/Login/UI/PersonalDetailsScreen/repository/PersonalDetailsRepository.dart';
import 'package:e_kyc/Utilities/CommonDialog.dart';
import 'package:e_kyc/Utilities/ResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PersonalDetailsBloc {
  // CheckBox variables to track 'Check/Uncheck'.
  var selectAllCheckBox = false;
  bool nseCashCheckBox = false; //0
  bool nseFNOCheckBox = false; //1
  bool nseCurrencyCheckBox = false; //2
  bool bseCashCheckBox = false; //3
  bool bseFNOCheckBox = false; //4
  bool bseCurencyCheckBox = false; //5
  bool mcxCommodityCheckBox = false; //6
  bool ncdexComodityCheckBox = false; //7

  //Checkbox for Address
  bool sameAddressCheckbox = false;

  // RadioButoton 'Gender' check
  var genderCheck = -1;
  //  'Marital status'
  var maritalStatus = -1;
  // 'Father / Spouse'
  var fatherSpouseCheck = -1;

  //Action [Politically exposed person/ Post Regulatory Action]
  var actionCheck = -1;

  //Nationality
  var nationality = "";
  List<String> nationalityItems = <String>["Indian", "Other"];

  //Income Range
  var incomeRange = "";
  List<String> incomeRangeItems = <String>[
    "Below 1 Lakh",
    "1 Lakh TO 5 Lakh",
    "5 Lakh TO 10 Lakh",
    "10 Lakh TO 25 Lakh",
    "Above 25 Lakh"
  ];

  //Occupation
  var occupation = "";
  List<String> occupationItems = <String>[
    "S-Service",
    "Private Sector",
    "Public Sector",
    "Government Sector",
    "O-Others",
    "Professional",
    "Self Employed",
    "Retired",
    "Housewife",
    "Student",
    "B-Business",
    "X- Not Categorized"
  ];

  // TextField Controller
  final firstNameTextController1 = TextEditingController();
  final middleNameTextController1 = TextEditingController();
  final lastNameTextController1 = TextEditingController();

  final firstNameTextController2 = TextEditingController();
  final middleNameTextController2 = TextEditingController();
  final lastNameTextController2 = TextEditingController();

  // 1
  final BehaviorSubject<String> _firstName1 = BehaviorSubject<String>();
  Stream<String> get validateFirstName1 => this._firstName1.stream;
  final BehaviorSubject<String> _middleName1 = BehaviorSubject<String>();
  Stream<String> get validateMiddleName1 => this._middleName1.stream;
  final BehaviorSubject<String> _lastName1 = BehaviorSubject<String>();
  Stream<String> get validateLastName1 => this._lastName1.stream;

  //2
  final BehaviorSubject<String> _firstName2 = BehaviorSubject<String>();
  Stream<String> get validateFirstName2 => this._firstName2.stream;
  final BehaviorSubject<String> _middleName2 = BehaviorSubject<String>();
  Stream<String> get validateMiddleName2 => this._middleName2.stream;
  final BehaviorSubject<String> _lastName2 = BehaviorSubject<String>();
  Stream<String> get validateLastName2 => this._lastName2.stream;

  var ctx;
  var validation = false;

  //Persona Details Repository
  PersonalDetailsRepository _personalDetailsRepository =
      new PersonalDetailsRepository();

  bool segmentValidateFlag = false;
  String genericMessage;

  // Residential Address
  final resAddressLine1TextController = TextEditingController();
  final resAddressLine2TextController = TextEditingController();
  final resStateTextController = TextEditingController();
  final resCityTextController = TextEditingController();
  final resPinCodeTextController = TextEditingController();

  final BehaviorSubject<String> _resAddress1 = BehaviorSubject<String>();
  Stream<String> get validateResAddress1 => this._resAddress1.stream;
  final BehaviorSubject<String> _resAddress2 = BehaviorSubject<String>();
  Stream<String> get validateResAddress2 => this._resAddress2.stream;
  final BehaviorSubject<String> _resState = BehaviorSubject<String>();
  Stream<String> get validateResState => this._resState.stream;
  final BehaviorSubject<String> _resCity = BehaviorSubject<String>();
  Stream<String> get validateResCity => this._resCity.stream;
  final BehaviorSubject<String> _resPinCode = BehaviorSubject<String>();
  Stream<String> get validateResPinCode => this._resPinCode.stream;

  // Permanent Address
  final perAddressLine1TextController = TextEditingController();
  final perAddressLine2TextController = TextEditingController();
  final perStateTextController = TextEditingController();
  final perCityTextController = TextEditingController();
  final perPinCodeTextController = TextEditingController();

  final BehaviorSubject<String> _perAddress1 = BehaviorSubject<String>();
  Stream<String> get validatePerAddress1 => this._perAddress1.stream;
  final BehaviorSubject<String> _perAddress2 = BehaviorSubject<String>();
  Stream<String> get validatePerAddress2 => this._perAddress2.stream;
  final BehaviorSubject<String> _perState = BehaviorSubject<String>();
  Stream<String> get validatePerState => this._perState.stream;
  final BehaviorSubject<String> _perCity = BehaviorSubject<String>();
  Stream<String> get validatePerCity => this._perCity.stream;
  final BehaviorSubject<String> _perPinCode = BehaviorSubject<String>();
  Stream<String> get validatePerPinCode => this._perPinCode.stream;

// Dispose call
  void dispose() {
    this._firstName1.close();
    this._middleName1.close();
    this._lastName1.close();
    this._firstName2.close();
    this._middleName2.close();
    this._lastName2.close();

    this.firstNameTextController1.dispose();
    this.middleNameTextController1.dispose();
    this.lastNameTextController1.dispose();
    this.firstNameTextController2.dispose();
    this.middleNameTextController2.dispose();
    this.lastNameTextController2.dispose();

    this._resAddress1.close();
    this._resAddress2.close();
    this._resState.close();
    this._resCity.close();
    this._resPinCode.close();

    this.resAddressLine1TextController.dispose();
    this.resAddressLine2TextController.dispose();
    this.resStateTextController..dispose();
    this.resCityTextController.dispose();
    this.resPinCodeTextController.dispose();

    this._perAddress1.close();
    this._perAddress2.close();
    this._perState.close();
    this._perCity.close();
    this._perPinCode.close();

    this.perAddressLine1TextController.dispose();
    this.perAddressLine2TextController.dispose();
    this.perStateTextController.dispose();
    this.perCityTextController.dispose();
    this.perPinCodeTextController.dispose();
  }

// Validating  Personal Details.
  bool validatePersonalDetails(BuildContext context) {
    this.ctx = context;
    validation = true;

    // Validate segment is-Selected OR Not
    if (!selectAllCheckBox) {
      if (nseCashCheckBox ||
          nseFNOCheckBox ||
          nseCurrencyCheckBox ||
          bseCashCheckBox ||
          bseFNOCheckBox ||
          bseCurencyCheckBox ||
          mcxCommodityCheckBox ||
          ncdexComodityCheckBox) {
        print("Segment selected");
      } else {
        validation = false;
        this.genericMessage = "Select at least 1 segment.";
        return validation;
      }
    }

    // Validate Residential Address
    if (resAddressLine1TextController.text.length == 0) {
      this._resAddress1.sink.add('Enter Address line 1');
      validation = false;
      genericMessage = 'Enter Address line 1';
      return validation;
    } else {
      this._resAddress1.sink.add('');
    }

    if (resAddressLine2TextController.text.length == 0) {
      this._resAddress2.sink.add('Enter Address line 2');
      validation = false;
      genericMessage = 'Enter Address line 2';
      return validation;
    } else {
      this._resAddress2.sink.add('');
    }

    if (resStateTextController.text.length == 0) {
      this._resState.sink.add('Enter State');
      validation = false;
      genericMessage = 'Enter State';
      return validation;
    } else {
      this._resState.sink.add('');
    }

    if (resCityTextController.text.length == 0) {
      this._resCity.sink.add('Enter City');
      validation = false;
      genericMessage = 'Enter City';
      return validation;
    } else {
      this._resCity.sink.add('');
    }

    if (resPinCodeTextController.text.length == 0) {
      this._resPinCode.sink.add('Enter Pin Code');
      validation = false;
      genericMessage = 'Enter Pin Code';
      return validation;
    } else if (resPinCodeTextController.text.length < 6) {
      this._resPinCode.sink.add('Enter 6 Digit Pin Code');
      validation = false;
      genericMessage = 'Enter 6 Digit Pin Code';
      return validation;
    } else {
      this._resPinCode.sink.add('');
    }

    // Validate Permanent Address
    if (perAddressLine1TextController.text.length == 0) {
      this._perAddress1.sink.add('Enter Address line 1');
      validation = false;
      genericMessage = 'Enter Address line 1';
      return validation;
    } else {
      this._perAddress1.sink.add('');
    }

    if (perAddressLine2TextController.text.length == 0) {
      this._perAddress2.sink.add('Enter Address line 2');
      validation = false;
      genericMessage = 'Enter Address line 2';
      return validation;
    } else {
      this._perAddress2.sink.add('');
    }

    if (perStateTextController.text.length == 0) {
      this._perState.sink.add('Enter State');
      validation = false;
      genericMessage = 'Enter State';
      return validation;
    } else {
      this._perState.sink.add('');
    }

    if (perCityTextController.text.length == 0) {
      this._perCity.sink.add('Enter City');
      validation = false;
      genericMessage = 'Enter City';
      return validation;
    } else {
      this._perCity.sink.add('');
    }

    if (perPinCodeTextController.text.length == 0) {
      this._perPinCode.sink.add('Enter Pin Code');
      validation = false;
      genericMessage = 'Enter Pin Code';
      return validation;
    } else if (perPinCodeTextController.text.length < 6) {
      this._perPinCode.sink.add('Enter 6 Digit Pin Code');
      validation = false;
      genericMessage = 'Enter 6 Digit Pin Code';
      return validation;
    } else {
      this._perPinCode.sink.add('');
    }

    // Validate nationality
    if (nationality.isEmpty) {
      validation = false;
      this.genericMessage = "Select your country";
      return validation;
    }

    //Validate gender
    if (genderCheck == -1) {
      validation = false;
      this.genericMessage = "Select your gender";
      return validation;
    }

    // Validate textfield
    if (firstNameTextController1.text.length == 0) {
      this._firstName1.sink.add('Enter First Name');
      validation = false;
      genericMessage = "Enter first Name";
      return validation;
    } else {
      this._firstName1.sink.add("");
    }

    if (middleNameTextController1.text.length == 0) {
      this._middleName1.sink.add('Enter Middle Name');
      validation = false;
      genericMessage = "Enter middle Name";
      return validation;
    } else {
      this._middleName1.sink.add("");
    }

    if (lastNameTextController1.text.length == 0) {
      this._lastName1.sink.add('Enter Last Name');
      validation = false;
      genericMessage = "Enter last Name";
      return validation;
    } else {
      this._lastName1.sink.add("");
    }

    //Validate Marital Status
    if (maritalStatus == -1) {
      validation = false;
      genericMessage = "Select marital status";
      return validation;
    }

    //Validate Father / Spouse
    if (fatherSpouseCheck == -1) {
      validation = false;
      genericMessage = "Select Father / Spouse";
      return validation;
    }
    var fatherSpouse = fatherSpouseCheck == 0 ? "father" : "spouse";
    // Check Radio button selected and do the validation with proper message.
    if (firstNameTextController2.text.length == 0) {
      this._firstName2.sink.add('Enter First Name');
      validation = false;
      genericMessage = "Enter $fatherSpouse first Name";
      return validation;
    } else {
      this._firstName2.sink.add("");
    }

    if (middleNameTextController2.text.length == 0) {
      this._middleName2.sink.add('Enter Middle Name');
      validation = false;
      genericMessage = "Enter $fatherSpouse middle Name";
      return validation;
    } else {
      this._middleName2.sink.add("");
    }

    if (lastNameTextController2.text.length == 0) {
      this._lastName2.sink.add('Enter Last Name');
      validation = false;
      genericMessage = "Enter $fatherSpouse last Name";
      return validation;
    } else {
      this._lastName2.sink.add("");
    }

    // Validate income range
    if (incomeRange.isEmpty) {
      validation = false;
      genericMessage = "Select income range";
      return validation;
    }

    //Validate occupation
    if (occupation.isEmpty) {
      validation = false;
      genericMessage = "Select occupation";
      return validation;
    }

    //Validate action
    if (actionCheck == -1) {
      validation = false;
      genericMessage =
          "Select Politically exposed person/ Past Regulatory Action";
      return validation;
    }

    return validation;
  }

  // Call PErsonal Details Submit API
  void callPersonalDetailsAPI(BuildContext context, String screenname) async {
    print("callPersonalDetailsAPI");
    try {
      AppConfig().showLoaderDialog(context); // show loader

      ResponseModel obj = await this
          ._personalDetailsRepository
          .callingPersonalDetailsAPI(LoginRepository.loginEmailId,
              LoginRepository.loginMobileNo, this);
      AppConfig().dismissLoaderDialog(context); //// dismiss loader
      if (obj.response.errorCode == "0") {
        LoginUserDetailModelResponse obj = await LoginRepository()
            .getEkycUserDetails(LoginRepository.loginEmailId,
                LoginRepository.loginMobileNo, LoginRepository.loginFullName);
        LoginRepository.loginDetailsResObjGlobal = obj;
        if (screenname.toString().contains("small")) {
          HomeScreenSmall.screensStreamSmall.sink
              .add(Ekycscreenamesmall.bankdetailscreen);
        } else {
          HomeScreenLarge.screensStreamLarge.sink
              .add(Ekycscreenamelarge.bankdetailscreen);
        }
      } else {
        showAlert("failed");
      }
    } catch (exception) {
      validation = false;
      // showAlert("failed");
      CommonErrorDialog.showServerErrorDialog(context, 'Something went wrong');
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

  void updateSelectAllCheckbox() {
    if (this.nseCashCheckBox &&
        this.bseCashCheckBox &&
        this.nseFNOCheckBox &&
        this.bseFNOCheckBox &&
        this.nseCurrencyCheckBox &&
        this.bseCurencyCheckBox &&
        this.mcxCommodityCheckBox &&
        this.ncdexComodityCheckBox) {
      this.selectAllCheckBox = true;
    } else {
      this.selectAllCheckBox = false;
    }
  }
}
