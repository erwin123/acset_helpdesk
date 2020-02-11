class ParameterModel {
  String pID;
  String pKey;
  String pDesc;
  String pText;
  int pArg;
  bool isActive;

  ParameterModel(
      {this.pID,
        this.pKey,
        this.pDesc,
        this.pText,
        this.pArg,
        this.isActive});

  factory ParameterModel.fromJson(Map<String, dynamic> json) {
    return new ParameterModel(
        pID: json['pID'],
        pKey: json['pKey'],
        pDesc: json['pDesc'],
        pText: json['pText'],
        pArg: json['pArg'],
        isActive: json['isActive']);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["pID"] = pID;
    map["pKey"] = pKey;
    map["pDesc"] = pDesc;
    map["pText"] = pText;
    map["pArg"] = pArg;
    map["isActive"] = isActive;
    return map;
  }

  Map<String, dynamic> toJson() => {
    'pID': pID,
    'pKey': pKey,
    'pDesc': pDesc,
    'pText': pText,
    'pArg': pArg,
    'isActive': isActive
  };
}
