import 'package:e_kyc/Login/UI/EsignScreen/repository/EsignRepository.dart';
import 'package:e_kyc/Login/UI/HomeScreen/HomeScreenSmall.dart';
import 'package:e_kyc/Login/UI/Login/repository/LoginRepository.dart';
import 'package:e_kyc/Login/UI/PersonalDetailsScreen/bloc/PersonalDetailsBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonalDetailsScreenSmall extends StatefulWidget {
  @override
  _PersonalDetailsScreenSmallState createState() =>
      _PersonalDetailsScreenSmallState();
}

class _PersonalDetailsScreenSmallState
    extends State<PersonalDetailsScreenSmall> {
  String _chosenValue, _chosenValue1, _chosenValue2;

  PersonalDetailsBloc personalDetailsBloc = new PersonalDetailsBloc();
  var validFirstName1 = "";
  var validMiddleName1 = "";
  var validLastName1 = "";
  //2
  var validFirstName2 = "";
  var validMiddleName2 = "";
  var validLastName2 = "";

  //Residential Address
  var validResAddress1 = "";
  var validResAddress2 = "";
  var validResState = "";
  var validResCity = "";
  var validResPinCode = "";

  //Permanent Address
  var validPerAddress1 = "";
  var validPerAddress2 = "";
  var validPerState = "";
  var validPerCity = "";
  var validPerPinCode = "";

  var globalRespObj = LoginRepository.loginDetailsResObjGlobal;

  @override
  void dispose() {
    this.personalDetailsBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    HomeScreenSmall.percentageFlagSmall.add("0.205");
    super.initState();

    if (globalRespObj != null) {
      print(globalRespObj.response.errorCode);
      if (globalRespObj.response.errorCode == "0") {
        var stage = int.parse(globalRespObj.response.data.message[0].stage);
        if (stage >= 1) {
          var responseData = globalRespObj.response.data.message[0];
          this.personalDetailsBloc.nseCashCheckBox =
              responseData.nseCash == "0" ? true : false;
          this.personalDetailsBloc.nseFNOCheckBox =
              responseData.nseFo == "1" ? true : false;
          this.personalDetailsBloc.nseCurrencyCheckBox =
              responseData.nseCurrency == "2" ? true : false;
          this.personalDetailsBloc.bseCashCheckBox =
              responseData.bseCash == "3" ? true : false;
          this.personalDetailsBloc.bseFNOCheckBox =
              responseData.bseFo == "4" ? true : false;
          this.personalDetailsBloc.bseCurencyCheckBox =
              responseData.bseCurrency == "5" ? true : false;
          this.personalDetailsBloc.mcxCommodityCheckBox =
              responseData.mcxCommodty == "6" ? true : false;
          this.personalDetailsBloc.ncdexComodityCheckBox =
              responseData.ncdexCommodty == "7" ? true : false;

          if (this.personalDetailsBloc.nseCashCheckBox &&
              this.personalDetailsBloc.nseFNOCheckBox &&
              this.personalDetailsBloc.nseCurrencyCheckBox &&
              this.personalDetailsBloc.bseCashCheckBox &&
              this.personalDetailsBloc.bseFNOCheckBox &&
              this.personalDetailsBloc.bseCurencyCheckBox &&
              this.personalDetailsBloc.mcxCommodityCheckBox &&
              this.personalDetailsBloc.ncdexComodityCheckBox) {
            this.personalDetailsBloc.selectAllCheckBox = true;
          }

          if (responseData.gender.isNotEmpty) {
            if (responseData.gender.toLowerCase() == "male") {
              this.personalDetailsBloc.genderCheck = 0;
            } else if (responseData.gender.toLowerCase() == "female") {
              this.personalDetailsBloc.genderCheck = 1;
            } else {
              this.personalDetailsBloc.genderCheck = 2;
            }
          }

          this.personalDetailsBloc.firstNameTextController1.text =
              responseData.firstname1;
          this.personalDetailsBloc.middleNameTextController1.text =
              responseData.middlename1;
          this.personalDetailsBloc.lastNameTextController1.text =
              responseData.lastname1;

          //  Residential Address
          this.personalDetailsBloc.resAddressLine1TextController.text =
              responseData.resAddr1;
          this.personalDetailsBloc.resAddressLine2TextController.text =
              responseData.resAddr2;
          this.personalDetailsBloc.resStateTextController.text =
              responseData.resAddrState;
          this.personalDetailsBloc.resCityTextController.text =
              responseData.resAddrCity;
          this.personalDetailsBloc.resPinCodeTextController.text =
              responseData.resAddrPincode;

          // Permanent Address
          this.personalDetailsBloc.perAddressLine1TextController.text =
              responseData.parmAddr1;
          this.personalDetailsBloc.perAddressLine2TextController.text =
              responseData.parmAddr2;
          this.personalDetailsBloc.perStateTextController.text =
              responseData.parmAddrState;
          this.personalDetailsBloc.perCityTextController.text =
              responseData.parmAddrCity;
          this.personalDetailsBloc.perPinCodeTextController.text =
              responseData.parmAddrPincode;

          //Marital status
          if (responseData.maritalstatus.isNotEmpty) {
            if (responseData.maritalstatus == "Single") {
              this.personalDetailsBloc.maritalStatus = 0;
            } else if (responseData.maritalstatus == "Married") {
              this.personalDetailsBloc.maritalStatus = 1;
            } else {
              this.personalDetailsBloc.maritalStatus = 2;
            }
          }

          //Father Spouse
          if (responseData.fatherspouse.isNotEmpty) {
            if (responseData.fatherspouse.toLowerCase() == "father") {
              this.personalDetailsBloc.fatherSpouseCheck = 0;
            } else if (responseData.fatherspouse.toLowerCase() == "spouse") {
              this.personalDetailsBloc.fatherSpouseCheck = 1;
            }
          }

          //Name segment
          this.personalDetailsBloc.firstNameTextController2.text =
              responseData.firstname2;
          this.personalDetailsBloc.middleNameTextController2.text =
              responseData.middlename2;
          this.personalDetailsBloc.lastNameTextController2.text =
              responseData.lastname2;

          if (responseData.action.isNotEmpty) {
            this.personalDetailsBloc.actionCheck =
                responseData.action == "Politically Exposed Person" ? 0 : 1;
          }

          //Nationality , incomeRange, occupation
          if (responseData.nationality.isNotEmpty) {
            _chosenValue = responseData.nationality;
            personalDetailsBloc.nationality = _chosenValue;
          }

          if (responseData.incomerange.isNotEmpty) {
            _chosenValue1 = responseData.incomerange;
            personalDetailsBloc.incomeRange = _chosenValue1;
          }

          if (responseData.occupation.isNotEmpty) {
            _chosenValue2 = responseData.occupation;
            personalDetailsBloc.occupation = _chosenValue2;
          }
        }
      }
    }
    //1
    this.personalDetailsBloc.validateFirstName1.listen((event) {
      setState(() {
        this.validFirstName1 = event;
      });
    });
    this.personalDetailsBloc.validateMiddleName1.listen((event) {
      setState(() {
        this.validMiddleName1 = event;
      });
    });
    this.personalDetailsBloc.validateLastName1.listen((event) {
      setState(() {
        this.validLastName1 = event;
      });
    });
    //2
    this.personalDetailsBloc.validateFirstName2.listen((event) {
      setState(() {
        this.validFirstName2 = event;
      });
    });
    this.personalDetailsBloc.validateMiddleName2.listen((event) {
      setState(() {
        this.validMiddleName2 = event;
      });
    });
    this.personalDetailsBloc.validateLastName2.listen((event) {
      setState(() {
        this.validLastName2 = event;
      });
    });

    //Residential Address Stream Handler
    this.personalDetailsBloc.validateResAddress1.listen((event) {
      setState(() {
        this.validResAddress1 = event;
      });
    });

    this.personalDetailsBloc.validateResAddress2.listen((event) {
      setState(() {
        this.validResAddress2 = event;
      });
    });

    this.personalDetailsBloc.validateResState.listen((event) {
      setState(() {
        this.validResState = event;
      });
    });

    this.personalDetailsBloc.validateResCity.listen((event) {
      setState(() {
        this.validResCity = event;
      });
    });

    this.personalDetailsBloc.validateResPinCode.listen((event) {
      setState(() {
        this.validResPinCode = event;
      });
    });

    //Permanent Address Stream Handler
    this.personalDetailsBloc.validatePerAddress1.listen((event) {
      setState(() {
        this.validPerAddress1 = event;
      });
    });

    this.personalDetailsBloc.validatePerAddress2.listen((event) {
      setState(() {
        this.validPerAddress2 = event;
      });
    });

    this.personalDetailsBloc.validatePerState.listen((event) {
      setState(() {
        this.validPerState = event;
      });
    });

    this.personalDetailsBloc.validatePerCity.listen((event) {
      setState(() {
        this.validPerCity = event;
      });
    });

    this.personalDetailsBloc.validatePerPinCode.listen((event) {
      setState(() {
        this.validPerPinCode = event;
      });
    });
    if (EsignRepository.timerObj != null) {
      EsignRepository.timerObj.cancel();
      EsignRepository.timerObj = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    _header(),
                    _personalDetailsForm(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _header() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(top: 5),
            width: 100,
            height: 60,
            child: Image.asset(
              'asset/images/personal_header.png',
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ONLINE ACCOUNT OPENING E - KYC",
                    style: TextStyle(
                        color: Color(0xFF0066CC),
                        fontSize: 15,
                        fontFamily: 'century_gothic',
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "PERSONAL DETAILS",
                    style: TextStyle(
                      fontFamily: 'century_gothic',
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: Color(0xFFFAB804),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _personalDetailsForm() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        "SELECT SEGMENTS",
                        style: TextStyle(
                          fontFamily: 'century_gothic',
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Color(0xFFFAB804),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Select All"),
                          Checkbox(
                            value: personalDetailsBloc.selectAllCheckBox,
                            onChanged: (value) {
                              setState(() {
                                personalDetailsBloc.selectAllCheckBox = value;
                                personalDetailsBloc.nseCashCheckBox = value;
                                personalDetailsBloc.nseFNOCheckBox = value;
                                personalDetailsBloc.nseCurrencyCheckBox = value;
                                personalDetailsBloc.mcxCommodityCheckBox =
                                    value;
                                personalDetailsBloc.bseCashCheckBox = value;
                                personalDetailsBloc.bseFNOCheckBox = value;
                                personalDetailsBloc.bseCurencyCheckBox = value;
                                personalDetailsBloc.ncdexComodityCheckBox =
                                    value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            nseSegment(),
            bseSegment(),
            SizedBox(
              height: 10,
            ),
            residentialAddress(),
            permanentAddress(),
            nationalitySegment(),
            genderSegment(),
            nameSegment1(),
            maritalStatusSegment(),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 18),
                    child: Row(
                      children: [
                        Text(
                          "FATHER / SPOUSE",
                          style: TextStyle(
                            fontFamily: 'century_gothic',
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Color(0xFFFAB804),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            child: Row(
                              children: [
                                Radio(
                                  value: 0,
                                  groupValue:
                                      personalDetailsBloc.fatherSpouseCheck,
                                  onChanged: (value) {
                                    setState(() {
                                      personalDetailsBloc.fatherSpouseCheck =
                                          value;
                                    });
                                  },
                                  activeColor: Colors.blue,
                                ),
                                Text(
                                  'Father',
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Row(
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue:
                                      personalDetailsBloc.fatherSpouseCheck,
                                  onChanged: (value) {
                                    setState(() {
                                      personalDetailsBloc.fatherSpouseCheck =
                                          value;
                                    });
                                  },
                                  activeColor: Colors.blue,
                                ),
                                Text(
                                  'Spouse',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            nameSegment2(),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'INCOME RANGE',
                      style: TextStyle(
                        fontFamily: 'century_gothic',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Color(0xFFFAB804),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: DropdownButton<String>(
                      value: _chosenValue1,
                      style: TextStyle(color: Colors.black),
                      items: personalDetailsBloc.incomeRangeItems
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Text(
                        "Select income range",
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _chosenValue1 = value;
                          personalDetailsBloc.incomeRange = _chosenValue1;
                          print(personalDetailsBloc.incomeRange);
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'OCCUPATION',
                      style: TextStyle(
                        fontFamily: 'century_gothic',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Color(0xFFFAB804),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: DropdownButton<String>(
                      value: _chosenValue2,
                      style: TextStyle(color: Colors.black),
                      items: personalDetailsBloc.occupationItems
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Text(
                        "Select occupation",
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _chosenValue2 = value;
                          personalDetailsBloc.occupation = _chosenValue2;
                          print(personalDetailsBloc.occupation);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Radio(
                          value: 0,
                          groupValue: personalDetailsBloc.actionCheck,
                          onChanged: (value) {
                            setState(() {
                              personalDetailsBloc.actionCheck = value;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                      ),
                      Container(
                        child: Text(
                          'Politically Exposed person',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        child: Radio(
                          value: 1,
                          groupValue: personalDetailsBloc.actionCheck,
                          onChanged: (value) {
                            setState(() {
                              personalDetailsBloc.actionCheck = value;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                      ),
                      Container(
                        child: Text(
                          'Past Regulatory Action',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _continuebtn(),
          ],
        ),
      ),
    );
  }

  Widget maritalStatusSegment() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 18),
            child: Row(
              children: [
                Text(
                  "MARITAL STATUS",
                  style: TextStyle(
                    fontFamily: 'century_gothic',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color(0xFFFAB804),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Radio(
                        value: 0,
                        groupValue: personalDetailsBloc.maritalStatus,
                        onChanged: (value) {
                          setState(() {
                            personalDetailsBloc.maritalStatus = value;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                      Text(
                        'Single',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: personalDetailsBloc.maritalStatus,
                        onChanged: (value) {
                          setState(() {
                            personalDetailsBloc.maritalStatus = value;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                      Text('Married'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: personalDetailsBloc.maritalStatus,
                        onChanged: (value) {
                          setState(() {
                            personalDetailsBloc.maritalStatus = value;
                            print(personalDetailsBloc.maritalStatus);
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                      Text('Other'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget residentialAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            'RESIDENTIAL ADDRESS',
            style: TextStyle(
              fontFamily: 'century_gothic',
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: Color(0xFFFAB804),
              letterSpacing: 0.2,
            ),
          ),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsetsDirectional.only(bottom: 14.0),
                width: 250.0,
                child: TextField(
                  controller: personalDetailsBloc.resAddressLine1TextController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9 ,./()-]'))
                  ],
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 8), // add padding to adjust text
                    isDense: false,
                    hintText: "Address line 1",
                    errorText:
                        validResAddress1.isEmpty ? null : validResAddress1,
                    // add padding to adjust icon
                  ),
                ),
              ),
              Container(
                width: 250.0,
                margin: EdgeInsetsDirectional.only(bottom: 14.0),
                child: TextField(
                  controller: personalDetailsBloc.resAddressLine2TextController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9 ,./()-]'))
                  ],
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 8), // add padding to adjust text
                    isDense: false,
                    hintText: "Address line 2",
                    errorText:
                        validResAddress2.isEmpty ? null : validResAddress2,
                    // add padding to adjust icon
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 150.0,
                    margin: EdgeInsetsDirectional.only(bottom: 14.0),
                    child: TextField(
                      controller: personalDetailsBloc.resStateTextController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z .-]'))
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 8), // add padding to adjust text
                        isDense: false,
                        hintText: "State",
                        errorText: validResState.isEmpty ? null : validResState,
                        // add padding to adjust icon
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 150.0,
                    margin: EdgeInsetsDirectional.only(
                      bottom: 14.0,
                    ),
                    padding: EdgeInsets.only(right: 30.0, left: 10),
                    child: TextField(
                      controller: personalDetailsBloc.resCityTextController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z .-]'))
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8),
                        isDense: false,
                        hintText: 'City',
                        errorText: validResCity.isEmpty ? null : validResCity,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 150.0,
                margin: EdgeInsetsDirectional.only(bottom: 14.0),
                child: TextField(
                  controller: personalDetailsBloc.resPinCodeTextController,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]'),
                    ),
                  ],
                  maxLength: 6,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8),
                    isDense: false,
                    hintText: 'Pin Code',
                    errorText: validResPinCode.isEmpty ? null : validResPinCode,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget permanentAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            'PERMANENT ADDRESS',
            style: TextStyle(
              fontFamily: 'century_gothic',
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: Color(0xFFFAB804),
              letterSpacing: 0.2,
            ),
          ),
        ),
        Row(
          children: [
            Container(
              // margin: EdgeInsets.only(left: 0),
              child: Checkbox(
                value: personalDetailsBloc.sameAddressCheckbox,
                onChanged: (value) {
                  setState(
                    () {
                      personalDetailsBloc.sameAddressCheckbox = value;
                      print(
                          'same address checkbox ${personalDetailsBloc.sameAddressCheckbox}');
                      if (personalDetailsBloc.sameAddressCheckbox) {
                        updatePermanentAddressData();
                      } else {
                        addRemoveAddressData();
                      }
                    },
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 0,
                left: 0,
              ),
              child: Text(
                'Residential & Permanent Address Same',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontFamily: 'century_gothic',
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  letterSpacing: 1.0,
                ),
              ),
            )
          ],
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsetsDirectional.only(bottom: 14.0),
                width: 250.0,
                child: TextField(
                  controller: personalDetailsBloc.perAddressLine1TextController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9 ,./()-]'))
                  ],
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 8), // add padding to adjust text
                    isDense: false,
                    hintText: "Address line 1",
                    errorText:
                        validPerAddress1.isEmpty ? null : validPerAddress1,
                    // add padding to adjust icon
                  ),
                ),
              ),
              Container(
                width: 250.0,
                margin: EdgeInsetsDirectional.only(bottom: 14.0),
                child: TextField(
                  controller: personalDetailsBloc.perAddressLine2TextController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9 ,./()-]'))
                  ],
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 8), // add padding to adjust text
                    isDense: false,
                    hintText: "Address line 2",
                    errorText:
                        validPerAddress2.isEmpty ? null : validPerAddress2,
                    // add padding to adjust icon
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 150.0,
                    margin: EdgeInsetsDirectional.only(bottom: 14.0),
                    child: TextField(
                      controller: personalDetailsBloc.perStateTextController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z .-]'))
                      ],
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 8), // add padding to adjust text
                          isDense: false,
                          hintText: "State",
                          errorText:
                              validPerState.isEmpty ? null : validPerState
                          // add padding to adjust icon
                          ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 150.0,
                    margin: EdgeInsetsDirectional.only(
                      bottom: 14.0,
                    ),
                    padding: EdgeInsets.only(right: 30.0, left: 10),
                    child: TextField(
                      controller: personalDetailsBloc.perCityTextController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z .-]'))
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8),
                        isDense: false,
                        hintText: 'City',
                        errorText: validPerCity.isEmpty ? null : validPerCity,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: 150.0,
                margin: EdgeInsetsDirectional.only(bottom: 14.0),
                child: TextField(
                  controller: personalDetailsBloc.perPinCodeTextController,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]'),
                    ),
                  ],
                  maxLength: 6,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8),
                    isDense: false,
                    hintText: 'Pin Code',
                    errorText: validPerPinCode.isEmpty ? null : validPerPinCode,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container nameSegment1() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsetsDirectional.only(bottom: 14.0),
            width: 200.0,
            child: TextField(
              controller: personalDetailsBloc.firstNameTextController1,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
              ],
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 8), // add padding to adjust text
                isDense: false,
                hintText: "First Name",
                errorText: validFirstName1.isEmpty ? null : validFirstName1,
                // add padding to adjust icon
              ),
            ),
          ),
          Container(
            width: 200.0,
            margin: EdgeInsetsDirectional.only(bottom: 14.0),
            child: TextField(
              controller: personalDetailsBloc.middleNameTextController1,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
              ],
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 8), // add padding to adjust text
                isDense: false,
                hintText: "Middle Name",
                errorText: validMiddleName1.isEmpty ? null : validMiddleName1,
                // add padding to adjust icon
              ),
            ),
          ),
          Container(
            width: 200.0,
            margin: EdgeInsetsDirectional.only(bottom: 14.0),
            child: TextField(
              controller: personalDetailsBloc.lastNameTextController1,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
              ],
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 8), // add padding to adjust text
                isDense: false,
                hintText: "Last Name",
                errorText: validLastName1.isEmpty ? null : validLastName1,
                // add padding to adjust icon
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container nameSegment2() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 200.0,
            margin: EdgeInsetsDirectional.only(bottom: 14.0),
            child: TextField(
              controller: personalDetailsBloc.firstNameTextController2,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
              ],
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 8), // add padding to adjust text
                isDense: false,
                hintText: "First Name",
                errorText: validFirstName2.isEmpty ? null : validFirstName2,
                // add padding to adjust icon
              ),
            ),
          ),
          Container(
            width: 200.0,
            margin: EdgeInsetsDirectional.only(bottom: 14.0),
            child: TextField(
              controller: personalDetailsBloc.middleNameTextController2,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
              ],
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 8), // add padding to adjust text
                isDense: false,
                hintText: "Middle Name",
                errorText: validMiddleName2.isEmpty ? null : validMiddleName2,
                // add padding to adjust icon
              ),
            ),
          ),
          Container(
            width: 200.0,
            margin: EdgeInsetsDirectional.only(bottom: 14.0),
            child: TextField(
              controller: personalDetailsBloc.lastNameTextController2,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
              ],
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 8), // add padding to adjust text
                isDense: false,
                hintText: "Last Name",
                errorText: validLastName2.isEmpty ? null : validLastName2,
                // add padding to adjust icon
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container nationalitySegment() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0, left: 0),
                  child: Text(
                    "NATIONALITY",
                    style: TextStyle(
                      fontFamily: 'century_gothic',
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Color(0xFFFAB804),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8, left: 10),
                  child: DropdownButton<String>(
                    value: _chosenValue,
                    style: TextStyle(color: Colors.black),
                    items: personalDetailsBloc.nationalityItems
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Country",
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _chosenValue = value;
                        personalDetailsBloc.nationality = _chosenValue;
                        print(personalDetailsBloc.nationality);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Container(
          //         margin: EdgeInsets.only(
          //           top: 55,
          //           left: 14,
          //         ),
          //         child: Text(
          //           "GENDER",
          //           style: CustomTextStyles.TextStyle2,
          //         ),
          //       ),
          //       Container(
          //         margin: EdgeInsets.only(top: 8, left: 10),
          //         child: Row(
          //           children: [
          //             Radio(
          //               value: 0,
          //               groupValue: personalDetailsBloc.genderCheck,
          //               onChanged: (value) {
          //                 setState(() {
          //                   personalDetailsBloc.genderCheck = value;
          //                   print(personalDetailsBloc.genderCheck);
          //                 });
          //               },
          //             ),
          //             Text('Male'),
          //           ],
          //         ),
          //       ),
          //       Container(
          //         margin: EdgeInsets.only(top: 8, left: 10),
          //         child: Row(
          //           children: [
          //             Radio(
          //               value: 1,
          //               groupValue: personalDetailsBloc.genderCheck,
          //               onChanged: (value) {
          //                 setState(() {
          //                   personalDetailsBloc.genderCheck = value;
          //                   print(personalDetailsBloc.genderCheck);
          //                 });
          //               },
          //             ),
          //             Text('Female'),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget genderSegment() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 18),
            child: Row(
              children: [
                Text(
                  "GENDER",
                  style: TextStyle(
                    fontFamily: 'century_gothic',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color(0xFFFAB804),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Radio(
                        value: 0,
                        groupValue: personalDetailsBloc.genderCheck,
                        onChanged: (value) {
                          setState(() {
                            personalDetailsBloc.genderCheck = value;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                      Text(
                        'Male',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: personalDetailsBloc.genderCheck,
                        onChanged: (value) {
                          setState(() {
                            personalDetailsBloc.genderCheck = value;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                      Text('Female'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: personalDetailsBloc.genderCheck,
                        onChanged: (value) {
                          setState(() {
                            personalDetailsBloc.genderCheck = value;
                            print(personalDetailsBloc.genderCheck);
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                      Text('Other'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget nseSegment() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        child: Checkbox(
                          value: personalDetailsBloc.nseCashCheckBox,
                          onChanged: (value) {
                            setState(() {
                              personalDetailsBloc.nseCashCheckBox = value;
                              personalDetailsBloc.updateSelectAllCheckbox();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "NSE CASH",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        child: Checkbox(
                          value: personalDetailsBloc.bseCashCheckBox,
                          onChanged: (value) {
                            setState(() {
                              personalDetailsBloc.bseCashCheckBox = value;
                              personalDetailsBloc.updateSelectAllCheckbox();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "BSE CASH",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        child: Checkbox(
                          value: personalDetailsBloc.nseFNOCheckBox,
                          onChanged: (value) {
                            setState(() {
                              personalDetailsBloc.nseFNOCheckBox = value;
                              personalDetailsBloc.updateSelectAllCheckbox();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "NSE F&O",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        child: Checkbox(
                          value: personalDetailsBloc.bseFNOCheckBox,
                          onChanged: (value) {
                            setState(() {
                              personalDetailsBloc.bseFNOCheckBox = value;
                              personalDetailsBloc.updateSelectAllCheckbox();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "BSE F&O",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bseSegment() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        child: Checkbox(
                          value: personalDetailsBloc.nseCurrencyCheckBox,
                          onChanged: (value) {
                            setState(() {
                              personalDetailsBloc.nseCurrencyCheckBox = value;
                              personalDetailsBloc.updateSelectAllCheckbox();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "NSE CURRENCY",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        child: Checkbox(
                          value: personalDetailsBloc.bseCurencyCheckBox,
                          onChanged: (value) {
                            setState(() {
                              personalDetailsBloc.bseCurencyCheckBox = value;
                              personalDetailsBloc.updateSelectAllCheckbox();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "BSE CURRENCY",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        child: Checkbox(
                          value: personalDetailsBloc.mcxCommodityCheckBox,
                          onChanged: (value) {
                            setState(() {
                              personalDetailsBloc.mcxCommodityCheckBox = value;
                              personalDetailsBloc.updateSelectAllCheckbox();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "MCX COMMODITY",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        child: Checkbox(
                          value: personalDetailsBloc.ncdexComodityCheckBox,
                          onChanged: (value) {
                            setState(() {
                              personalDetailsBloc.ncdexComodityCheckBox = value;
                              personalDetailsBloc.updateSelectAllCheckbox();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "NCDEX COMMODITY",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _continuebtn() {
    return Container(
      margin: EdgeInsets.only(right: 20, top: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 45,
            width: 110,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.only(top: 4, left: 4, bottom: 4, right: 4), //
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue[200],
                ),
                borderRadius: BorderRadius.circular(
                    20) // use instead of BorderRadius.all(Radius.circular(20))
                ),
            child: TextButton(
              child:
                  Text("PROCEED".toUpperCase(), style: TextStyle(fontSize: 14)),
              style: ButtonStyle(
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(1)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.blue[200]))),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () => this
                          .personalDetailsBloc
                          .validatePersonalDetails(context) ==
                      true
                  ? personalDetailsBloc.callPersonalDetailsAPI(context, 'small')
                  : showAlert(personalDetailsBloc.genericMessage),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showAlert(String msg) {
    return showDialog(
      context: context,
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

  void updatePermanentAddressData() {
    setState(() {
      personalDetailsBloc.perAddressLine1TextController.text =
          personalDetailsBloc.resAddressLine1TextController.text;
      personalDetailsBloc.perAddressLine2TextController.text =
          personalDetailsBloc.resAddressLine2TextController.text;
      personalDetailsBloc.perStateTextController.text =
          personalDetailsBloc.resStateTextController.text;
      personalDetailsBloc.perCityTextController.text =
          personalDetailsBloc.resCityTextController.text;
      personalDetailsBloc.perPinCodeTextController.text =
          personalDetailsBloc.resPinCodeTextController.text;
    });
  }

  void addRemoveAddressData() {
    setState(
      () {
        if (personalDetailsBloc.perAddressLine1TextController.text ==
                personalDetailsBloc.resAddressLine1TextController.text &&
            personalDetailsBloc.perAddressLine2TextController.text ==
                personalDetailsBloc.resAddressLine2TextController.text &&
            personalDetailsBloc.perStateTextController.text ==
                personalDetailsBloc.resStateTextController.text &&
            personalDetailsBloc.perCityTextController.text ==
                personalDetailsBloc.resCityTextController.text &&
            personalDetailsBloc.perPinCodeTextController.text ==
                personalDetailsBloc.resPinCodeTextController.text) {
          //Removing the data permanent address
          personalDetailsBloc.perAddressLine1TextController.text = '';
          personalDetailsBloc.perAddressLine2TextController.text = '';
          personalDetailsBloc.perStateTextController.text = '';
          personalDetailsBloc.perCityTextController.text = '';
          personalDetailsBloc.perPinCodeTextController.text = '';
        }
      },
    );
  }
}
