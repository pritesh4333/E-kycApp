class LoginDetailModeRequest {
  LoginRequestData data;

  LoginDetailModeRequest({this.data});

  LoginDetailModeRequest.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new LoginRequestData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class LoginRequestData {
  String fullName;
  String emailId;
  String mobileNo;
  String clientCode;
  String mobileOtp;
  String emailOtp;

  LoginRequestData(
      {this.fullName,
      this.emailId,
      this.mobileNo,
      this.clientCode,
      this.mobileOtp,
      this.emailOtp});

  LoginRequestData.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    emailId = json['email_id'];
    mobileNo = json['mobile_no'];
    clientCode = json['client_code'];
    mobileOtp = json['mobile_otp'];
    emailOtp = json['email_otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['email_id'] = this.emailId;
    data['mobile_no'] = this.mobileNo;
    data['client_code'] = this.clientCode;
    data['mobile_otp'] = this.mobileOtp;
    data['email_otp'] = this.emailOtp;
    return data;
  }
}