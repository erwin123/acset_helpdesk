class CategoryModel {
  String pType;
  String pLevel;
  String pId;
  String pParent;
  String pDesc;
  String pText;
  String pApproval;
  String pAutoAsign;
  String pArg;
  bool isActive;
  String pPriorityID;
  String pFileNama;
  String pFileLabel;

  CategoryModel(
      {this.pType,
      this.pLevel,
      this.pId,
      this.pParent,
      this.pDesc,
      this.pText,
      this.pApproval,
      this.pAutoAsign,
      this.pArg,
      this.isActive,
      this.pPriorityID,
      this.pFileNama,
      this.pFileLabel});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return new CategoryModel(
        pType: json['pType'],
        pLevel: json['pLevel'],
        pId: json['pId'],
        pParent: json['pParent'],
        pDesc: json['pDesc'],
        pText: json['pText'],
        pApproval: json['pApproval'],
        pAutoAsign: json['pAutoAsign'],
        pArg: json['pArg'],
        isActive: json['isActive'],
        pPriorityID: json['pPriorityID'],
        pFileNama: json['pFileNama'],
        pFileLabel: json['pFileLabel']);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["pType"] = pType;
    map["pLevel"] = pLevel;
    map["pId"] = pId;
    map["pParent"] = pParent;
    map["pDesc"] = pDesc;
    map["pText"] = pText;
    map["pApproval"] = pApproval;
    map["pAutoAsign"] = pAutoAsign;
    map["pArg"] = pArg;
    map["isActive"] = isActive;
    map["pPriorityID"] = pPriorityID;
    map["pFileNama"] = pFileNama;
    map["pFileLabel"] = pFileLabel;
    return map;
  }

  Map<String, dynamic> toJson() => {
        'pType': pType,
        'pLevel': pLevel,
        'pId': pId,
        'pParent': pParent,
        'pDesc': pDesc,
        'pDesc': pDesc,
        'pText': pText,
        'pApproval': pApproval,
        'pAutoAsign': pAutoAsign,
        'pArg': pArg,
        'isActive': isActive,
        'pPriorityID': pPriorityID,
        'pFileNama': pFileNama,
        'pFileLabel': pFileLabel
      };
}
