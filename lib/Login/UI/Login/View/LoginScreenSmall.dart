import 'package:e_kyc/Login/UI/EsignScreen/repository/EsignRepository.dart';
import 'package:e_kyc/Login/UI/HomeScreen/HomeScreenUI.dart';
import 'package:e_kyc/Login/UI/Login/bloc/LoginBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc loginbloc = new LoginBloc();
  var validfullname = "",
      validemail = "",
      validmobile = "",
      validclientcode = "";

  var mobileOtpTxt = "";
  var emailOtpTxt = "";

  @override
  void dispose() {
    this.loginbloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this.loginbloc.validatefullname.listen((event) {
      setState(() {
        this.validfullname = event;
      });
    });
    this.loginbloc.validateemail.listen((event) {
      setState(() {
        this.validemail = event;
      });
    });
    this.loginbloc.validatemobile.listen((event) {
      setState(() {
        this.validmobile = event;
      });
    });
    this.loginbloc.validateclientcode.listen((event) {
      setState(() {
        this.validclientcode = event;
      });
    });
    this.loginbloc.validateMobileOtp.listen((event) {
      setState(() {
        this.mobileOtpTxt = event;
      });
    });

    this.loginbloc.validateEmailOtp.listen((event) {
      setState(() {
        this.emailOtpTxt = event;
      });
    });

    this.loginbloc.fullnameTextController.addListener(() {
      setState(() {
        final text = this.loginbloc.fullnameTextController.text.toUpperCase();
        this.loginbloc.fullnameTextController.value =
            this.loginbloc.fullnameTextController.value.copyWith(
                  text: text,
                  selection: TextSelection(
                      baseOffset: text.length, extentOffset: text.length),
                );
      });
    });
    if (EsignRepository.timerObj != null) {
      EsignRepository.timerObj.cancel();
      EsignRepository.timerObj = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Column(
            children: [
              header(),
              Container(
                child: Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Container(
                          child: headericon(),
                        ),
                        Visibility(
                          visible: this.loginbloc.loginfieldsvisiblity,
                          child: Container(
                            child: loginfield(),
                          ),
                        ),
                        Visibility(
                          visible: this.loginbloc.emailOtpVerification,
                          child: Container(
                            child: otpfield(),
                          ),
                        ),
                        Visibility(
                          visible: this.loginbloc.otpVerifiedVisiblity,
                          child: Container(
                            child: otpverifiedpopup(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Version : 5.1.2022+3",
                  style: TextStyle(
                    fontFamily: 'century_gothic',
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  header() {
    return Container(
      height: 60,
      decoration: new BoxDecoration(
        color: Color(0xFF0074C4),
        borderRadius: new BorderRadius.only(
          bottomLeft: const Radius.circular(20.0),
          bottomRight: const Radius.circular(20.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              "E - KYC",
              style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontFamily: 'century_gothic',
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 150,
                    height: 135,
                    child: Image.asset('asset/images/vishwaslogo.png')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  headericon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
              margin: EdgeInsets.only(top: 25),
              width: 300,
              height: 200,
              child: Image.asset('asset/images/backgroudicon.png')),
        ),
      ],
    );
  }

  loginfield() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[400],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Text.rich(
              TextSpan(
                // with no TextStyle it will have default text style

                children: <TextSpan>[
                  TextSpan(
                      text: 'OPEN YOUR ACCOUNT IN 10 MINS',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            child: TextField(
              controller: this.loginbloc.fullnameTextController,
              keyboardType: TextInputType.name,
              onSubmitted: (str) {
                print('Done or return button tapped');
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    top: 15, left: 10), // add padding to adjust text
                isDense: true,
                hintText: "Full Name",
                hintStyle: TextStyle(
                    fontSize: 18,
                    fontFamily: 'century_gothic',
                    color: Colors.grey[400]),
                errorText: validfullname.isEmpty ? null : validfullname,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(10), // add padding to adjust icon
                  child: SvgPicture.asset(
                    'asset/svg/full_name.svg',
                    // color: Colors.black,
                    height: 22,
                    width: 22,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextField(
              controller: this.loginbloc.emailTextController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    top: 15, left: 10), // add padding to adjust text
                isDense: true,
                hintText: "Email ID",
                hintStyle: TextStyle(
                    fontSize: 18,
                    fontFamily: 'century_gothic',
                    color: Colors.grey[400]),
                errorText: validemail.isEmpty ? null : validemail,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(10), // add padding to adjust icon
                  child: SvgPicture.asset(
                    'asset/svg/email_id.svg',
                    color: Colors.black,
                    height: 22,
                    width: 22,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextField(
              controller: this.loginbloc.mobileTextController,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              maxLength: 10,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    top: 15, left: 10), // add padding to adjust text
                isDense: true,
                hintText: "Mobile Number",
                hintStyle: TextStyle(
                    fontSize: 18,
                    fontFamily: 'century_gothic',
                    color: Colors.grey[400]),
                errorText: validmobile.isEmpty ? null : validmobile,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(10), // add padding to adjust icon
                  child: SvgPicture.asset(
                    'asset/svg/mobile.svg',
                    color: Colors.black,
                    height: 22,
                    width: 22,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: this.loginbloc.checkboxcheck,
                      onChanged: (value) {
                        setState(() {
                          this.loginbloc.checkboxcheck = value;
                        });
                      },
                    ),
                    Text(
                      "Through Referral",
                      style: TextStyle(
                        fontFamily: 'century_gothic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      Text(
                        "Disclaimer",
                        style: TextStyle(
                          fontFamily: 'century_gothic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 500,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Visibility(
              visible: loginbloc.checkboxcheck,
              child: TextField(
                controller: this.loginbloc.clientcodeTextController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontFamily: 'century_gothic'),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 15), // add padding to adjust text
                  isDense: true,
                  hintText: "ENTER CLIENT CODE",
                  hintStyle: TextStyle(
                      fontSize: 18,
                      fontFamily: 'century_gothic',
                      color: Colors.grey[400]),
                  errorText: validclientcode.isEmpty ? null : validclientcode,
                  prefixIcon: Padding(
                    padding:
                        EdgeInsets.only(top: 15), // add padding to adjust icon
                  ),
                ),
              ),
            ),
          ),
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
              child: Text("CONTINUE".toUpperCase(),
                  style: TextStyle(fontSize: 14)),
              style: ButtonStyle(
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(1)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.blue[200]))),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFF0074C4)),
              ),
              onPressed: () => continuebtnclick(context),
            ),
          ),
        ],
      ),
    );
  }

  otpfield() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 10, bottom: 20),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[400],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: 20),
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text.rich(
              TextSpan(
                // with no TextStyle it will have default text style

                children: <TextSpan>[
                  TextSpan(
                      text: 'PLEASE ENTER OTP YOU RECEIVED ON EMAIL AND MOBILE',
                      style: TextStyle(
                          fontFamily: 'century_gothic',
                          color: Color(0xFF000000),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            padding: EdgeInsets.all(5),
            alignment: Alignment.centerLeft,
            child: Text("OTP RECEIVED VIA MOBILE",
                style: TextStyle(
                    fontFamily: 'century_gothic',
                    color: Color(0xFF000000),
                    fontSize: 12,
                    fontWeight: FontWeight.normal)),
          ),
          Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: Text(this.mobileOtpTxt,
                style: TextStyle(
                    fontFamily: 'century_gothic',
                    color: getColor(this.mobileOtpTxt),
                    fontSize: 11,
                    fontWeight: FontWeight.normal)),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: PinCodeTextField(
              controller: this.loginbloc.mobileOtpTextFieldController,
              appContext: context,
              length: 6,
              // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              //   obscureText: this._isObscurePin,
              obscureText: true,
              obscuringCharacter: '*',
              pinTheme: PinTheme(
                borderRadius: BorderRadius.circular(5.0),
                fieldHeight: 30,
                fieldWidth: 30,
                borderWidth: 1,
                fieldOuterPadding: EdgeInsets.zero,
                shape: PinCodeFieldShape.box,
                activeColor: Colors.black,
                selectedColor: Colors.black,
                inactiveColor: Colors.black,
                disabledColor: Colors.black,
                activeFillColor: Colors.black,
                selectedFillColor: Colors.black,
                inactiveFillColor: Colors.black,
                errorBorderColor: Colors.black,
              ),
              onChanged: (string) {
                print(string);
                if (string.length == 6) {
                  setState(
                      () => this.loginbloc?.isEnableMobileVerifyButton = true);
                }
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20),
                  alignment: Alignment.topRight,
                  child: TextButton(
                    child: Text("VERIFY".toUpperCase(),
                        style: TextStyle(
                            fontSize: 10, fontFamily: 'century_gothic')),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(16)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.blue[200]))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF0074C4)),
                    ),
                    onPressed: () => this.loginbloc.isEnableMobileVerifyButton
                        ? {
                            if (this.loginbloc.isEnableMobileVerifyButton)
                              {
                                print(" Mobile verfy btn pressed"),
                                this.loginbloc.validatioOTPMobile(context)
                              }
                            else
                              {
                                print(" Mobile OTP"),
                              }
                          }
                        : null,
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 10),
                  child: Text("Resend OTP",
                      style: TextStyle(
                          fontFamily: 'century_gothic',
                          fontSize: 12,
                          color: Color(0xFF0066CC),
                          fontWeight: FontWeight.normal)),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, top: 10),
            child: Text("OTP RECEIVED VIA EMAIL",
                style: TextStyle(
                    fontFamily: 'century_gothic',
                    color: Color(0xFF000000),
                    fontSize: 12,
                    fontWeight: FontWeight.normal)),
          ),
          Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: Text(this.emailOtpTxt,
                style: TextStyle(
                    fontFamily: 'century_gothic',
                    color: getColor(this.emailOtpTxt),
                    fontSize: 11,
                    fontWeight: FontWeight.normal)),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: PinCodeTextField(
              controller: this.loginbloc.emailOtpTextFieldController,
              appContext: context,
              length: 6,
              // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              obscureText: true,
              obscuringCharacter: '*',
              pinTheme: PinTheme(
                borderRadius: BorderRadius.circular(5.0),
                fieldHeight: 30,
                fieldWidth: 30,
                borderWidth: 1,
                fieldOuterPadding: EdgeInsets.zero,
                shape: PinCodeFieldShape.box,
                activeColor: Colors.black,
                selectedColor: Colors.black,
                inactiveColor: Colors.black,
                disabledColor: Colors.black,
                activeFillColor: Colors.black,
                selectedFillColor: Colors.black,
                inactiveFillColor: Colors.black,
                errorBorderColor: Colors.black,
              ),
              onChanged: (string) {
                print(string);
                if (string.length == 6) {
                  setState(
                      () => this.loginbloc?.isEnableemailVerifyButton = true);
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    child: Text("VERIFY".toUpperCase(),
                        style: TextStyle(
                            fontSize: 10, fontFamily: 'century_gothic')),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(16)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.blue[200]))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF0074C4)),
                    ),
                    onPressed: () => this.loginbloc.isEnableemailVerifyButton
                        ? {
                            if (this.loginbloc.isEnableemailVerifyButton)
                              {
                                print("Email verfy btn pressed"),
                                this.loginbloc.validatioOTPEmail(context)
                              }
                            else
                              {
                                print(" Email OTP"),
                              }
                          }
                        : null,
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 10),
                  child: Text("Resend OTP",
                      style: TextStyle(
                          fontFamily: 'century_gothic',
                          fontSize: 12,
                          color: Color(0xFF0066CC),
                          fontWeight: FontWeight.normal)),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20),
            child: Container(
              alignment: Alignment.center,
              child: Container(
                height: 45,
                width: 110,
                margin: EdgeInsets.all(20),

                padding:
                    EdgeInsets.only(top: 4, left: 4, bottom: 4, right: 4), //
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue[200],
                    ),
                    borderRadius: BorderRadius.circular(
                        20) // use instead of BorderRadius.all(Radius.circular(20))
                    ),
                child: TextButton(
                  child: Text("CONTINUE".toUpperCase(),
                      style: TextStyle(
                          fontSize: 12, fontFamily: 'century_gothic')),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(1)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.blue[200]))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF0074C4)),
                  ),
                  onPressed: () => otpbtnclick(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  otpverifiedpopup() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25),
            child: Container(
                width: 150,
                height: 135,
                child: Image.asset('asset/images/success_otp.png')),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 25),
            padding: EdgeInsets.all(10),
            child: Text("OTP Verified Successfull",
                style: TextStyle(
                    fontFamily: 'century_gothic',
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.normal)),
          ),
          Container(
            height: 45,
            width: 110,
            margin: EdgeInsets.all(20),

            padding: EdgeInsets.only(top: 4, left: 4, bottom: 4, right: 4), //

            child: TextButton(
              child: Text("CONTINUE".toUpperCase(),
                  style: TextStyle(fontSize: 12, fontFamily: 'century_gothic')),
              style: ButtonStyle(
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(1)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.blue[200]))),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xFF0074C4)),
              ),
              onPressed: () => otpVerifiedBtnClick(),
            ),
          ),
        ],
      ),
    );
  }

  continuebtnclick(BuildContext context) async {
    var obj = await loginbloc.validationcheck(context);
    if (obj) {
      // ignore: unused_local_variable
      var getuserdetailsobj = await loginbloc.getEkycUserDetails(context);
      // if (getuserdetailsobj &&
      //     LoginRepository
      //             .loginDetailsResObjGlobal.response.data.message[0].emailOtp !=
      //         "" &&
      //     LoginRepository
      //             .loginDetailsResObjGlobal.response.data.message[0].emailOtp !=
      //         null &&
      //     LoginRepository.loginDetailsResObjGlobal.response.data.message[0]
      //             .mobileOtp !=
      //         "" &&
      //     LoginRepository.loginDetailsResObjGlobal.response.data.message[0]
      //             .mobileOtp !=
      //         null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreenUI()),
        (route) => true,
      );
      // } else {
      //   setState(() {
      //     this.loginbloc.loginfieldsvisiblity = false;
      //     this.loginbloc.emailOtpVerification = true;
      //     loginbloc.sendOtpToEmail(context);
      //     loginbloc.sendOtpToMobile(context);
      //   });
      // }
    }
  }

  Color getColor(status) {
    if (status == "Verified Successfully") {
      return Colors.green[900];
    } else {
      return Color(0XFFff0000);
    }
  }

  otpbtnclick(BuildContext context) async {
    if (loginbloc.isEmailandMobileOtpVerifiedCheck) {
      // check with if email and mobile opt is verified or not if verified then click contiue
      var obj = await loginbloc.otpValidation(context);
      if (obj) {
        setState(() {
          this.loginbloc.emailOtpVerification = false;
          this.loginbloc.loginfieldsvisiblity = false;
          this.loginbloc.otpVerifiedVisiblity = true;
        });
        //  await Future.delayed(Duration(seconds: 1));

      } else {}
    } else {
      this.loginbloc.mobileotp.sink.add("Please Verify Mobile OTP");
      this.loginbloc.emailotp.sink.add("Please Verify Email OTP");
    }
  }

  otpVerifiedBtnClick() {
    this.loginbloc.saveLoginFormDetails(context);
  }
}
