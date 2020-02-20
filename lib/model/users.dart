class UsersModel {
  String uID;
  String uPass;
  String uName;
  String uMail;
  String uType;
  String uBirthDate;
  String uParent;
  String uParentControl;
  String pDeptID;
  String pCompanyID;
  String deleted;
  String updBy;
  String updDate;

  UsersModel(
      {this.uID,
        this.uPass,
        this.uName,
        this.uMail,
        this.uType,
        this.uBirthDate,
        this.uParent,
        this.uParentControl,
        this.pDeptID,
        this.pCompanyID,
        this.deleted,
        this.updBy,
        this.updDate
      });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return new UsersModel(
        uID: json['uID'],
        uPass: json['uPass'],
        uName: json['uName'],
        uMail: json['uMail'],
        uType: json['uType'],
        uBirthDate: json['uBirthDate'],
      uParent: json['uParent'],
      uParentControl: json['uParentControl'],
      pDeptID: json['pDeptID'],
      pCompanyID: json['pCompanyID'],
      deleted: json['deleted'],
      updBy: json['updBy'],
      updDate: json['updDate'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["uID"] = uID;
    map["uPass"] = uPass;
    map["uName"] = uName;
    map["uMail"] = uMail;
    map["uType"] = uType;
    map["uBirthDate"] = uBirthDate;
    map["uParent"] = uParent;
    map["uParentControl"] = uParentControl;
    map["pDeptID"] = pDeptID;
    map["pCompanyID"] = pCompanyID;
    map["deleted"] = deleted;
    map["updBy"] = updBy;
    map["updDate"] = updDate;
    return map;
  }

  Map<String, dynamic> toJson() => {
    'uID': uID,
    'uPass': uPass,
    'uName': uName,
    'uMail': uMail,
    'uType': uType,
    'uBirthDate': uBirthDate,
    'uParent': uParent,
    'uParentControl': uParentControl,
    'pDeptID': pDeptID,
    'pCompanyID': pCompanyID,
    'deleted': deleted,
    'updBy': updBy,
    'updDate': updDate
  };
}
