class PersonaDetailsRequestModel {
  PersonaDetailRequestData data;

  PersonaDetailsRequestModel({this.data});

  PersonaDetailsRequestModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new PersonaDetailRequestData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class PersonaDetailRequestData {
  String emailId;
  String mobileNo;
  String nseCash;
  String nseFo;
  String nseCurrency;
  String mcxCommodity;
  String bseCash;
  String bseFo;
  String bseCurrency;
  String ncdexCommodity;
  String nationality;
  String gender;
  String firstname1;
  String middlename1;
  String lastname1;
  String maritalstatus;
  String fatherspouse;
  String firstname2;
  String middlename2;
  String lastname2;
  String incomerange;
  String occupation;
  String action;
  String perextra1;
  String perextra2;
  String resAddr1;
  String resAddr2;
  String resAddrState;
  String resAddrCity;
  String resAddrPincode;
  String parmAddr1;
  String parmAddr2;
  String parmAddrState;
  String parmAddrCity;
  String parmAddrPincode;

  PersonaDetailRequestData({
    this.emailId,
    this.mobileNo,
    this.nseCash,
    this.nseFo,
    this.nseCurrency,
    this.mcxCommodity,
    this.bseCash,
    this.bseFo,
    this.bseCurrency,
    this.ncdexCommodity,
    this.nationality,
    this.gender,
    this.firstname1,
    this.middlename1,
    this.lastname1,
    this.maritalstatus,
    this.fatherspouse,
    this.firstname2,
    this.middlename2,
    this.lastname2,
    this.incomerange,
    this.occupation,
    this.action,
    this.perextra1,
    this.perextra2,
    this.resAddr1,
    this.resAddr2,
    this.resAddrState,
    this.resAddrCity,
    this.resAddrPincode,
    this.parmAddr1,
    this.parmAddr2,
    this.parmAddrState,
    this.parmAddrCity,
    this.parmAddrPincode,
  });

  PersonaDetailRequestData.fromJson(Map<String, dynamic> json) {
    emailId = json['email_id'];
    mobileNo = json['mobile_no'];
    nseCash = json['nse_cash'];
    nseFo = json['nse_fo'];
    nseCurrency = json['nse_currency'];
    mcxCommodity = json['mcx_commodity'];
    bseCash = json['bse_cash'];
    bseFo = json['bse_fo'];
    bseCurrency = json['bse_currency'];
    ncdexCommodity = json['ncdex_commodity'];
    nationality = json['nationality'];
    gender = json['gender'];
    firstname1 = json['firstname1'];
    middlename1 = json['middlename1'];
    lastname1 = json['lastname1'];
    maritalstatus = json['maritalstatus'];
    fatherspouse = json['fatherspouse'];
    firstname2 = json['firstname2'];
    middlename2 = json['middlename2'];
    lastname2 = json['lastname2'];
    incomerange = json['incomerange'];
    occupation = json['occupation'];
    action = json['action'];
    perextra1 = json['perextra1'];
    perextra2 = json['perextra2'];
    resAddr1 = json['res_addr_1'];
    resAddr2 = json['res_addr_2'];
    resAddrState = json['res_addr_state'];
    resAddrCity = json['res_addr_city'];
    resAddrPincode = json['res_addr_pincode'];
    parmAddr1 = json['parm_addr_1'];
    parmAddr2 = json['parm_addr_2'];
    parmAddrState = json['parm_addr_state'];
    parmAddrCity = json['parm_addr_city'];
    parmAddrPincode = json['parm_addr_pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_id'] = this.emailId;
    data['mobile_no'] = this.mobileNo;
    data['nse_cash'] = this.nseCash;
    data['nse_fo'] = this.nseFo;
    data['nse_currency'] = this.nseCurrency;
    data['mcx_commodity'] = this.mcxCommodity;
    data['bse_cash'] = this.bseCash;
    data['bse_fo'] = this.bseFo;
    data['bse_currency'] = this.bseCurrency;
    data['ncdex_commodity'] = this.ncdexCommodity;
    data['nationality'] = this.nationality;
    data['gender'] = this.gender;
    data['firstname1'] = this.firstname1;
    data['middlename1'] = this.middlename1;
    data['lastname1'] = this.lastname1;
    data['maritalstatus'] = this.maritalstatus;
    data['fatherspouse'] = this.fatherspouse;
    data['firstname2'] = this.firstname2;
    data['middlename2'] = this.middlename2;
    data['lastname2'] = this.lastname2;
    data['incomerange'] = this.incomerange;
    data['occupation'] = this.occupation;
    data['action'] = this.action;
    data['perextra1'] = this.perextra1;
    data['perextra2'] = this.perextra2;
    data['res_addr_1'] = this.resAddr1;
    data['res_addr_2'] = this.resAddr2;
    data['res_addr_state'] = this.resAddrState;
    data['res_addr_city'] = this.resAddrCity;
    data['res_addr_pincode'] = this.resAddrPincode;
    data['parm_addr_1'] = this.parmAddr1;
    data['parm_addr_2'] = this.parmAddr2;
    data['parm_addr_state'] = this.parmAddrState;
    data['parm_addr_city'] = this.parmAddrCity;
    data['parm_addr_pincode'] = this.parmAddrPincode;
    return data;
  }
}
