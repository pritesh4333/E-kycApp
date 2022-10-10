class BankRequestModel {
  BankDetailData data;

  BankRequestModel({this.data});

  BankRequestModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new BankDetailData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class BankDetailData {
  String emailId;
  String mobileNo;
  String ifsccode;
  String accountnumber;
  String bankname;

  BankDetailData({this.emailId, this.mobileNo, this.ifsccode, this.accountnumber, this.bankname});

  BankDetailData.fromJson(Map<String, dynamic> json) {
    emailId = json['email_id'];
    mobileNo = json['mobile_no'];
    ifsccode = json['ifsccode'];
    accountnumber = json['accountnumber'];
    bankname = json['bankname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_id'] = this.emailId;
    data['mobile_no'] = this.mobileNo;
    data['ifsccode'] = this.ifsccode;
    data['accountnumber'] = this.accountnumber;
      data['bankname'] = this.bankname;
    return data;
  }
}