import 'dart:convert';
import 'dart:io';
import 'package:acset_helpdesk/home_page.dart';
import 'package:acset_helpdesk/model/category.dart';
import 'package:acset_helpdesk/model/credential.dart';
import 'package:acset_helpdesk/model/parameter.dart';
import 'package:acset_helpdesk/services/abstract_request.dart';
import 'package:acset_helpdesk/services/sharepref.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:acset_helpdesk/static/global_var.dart' as globalVariables;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class CreateTicket extends StatefulWidget {
  @override
  _CreateTicketState createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  final _formKey = GlobalKey<FormState>();
  String _title;
  String _description;
  String _handphone;
  File attach1 = null;
  File attach2 = null;

  String _category;
  String _subcategory;
  List<ParameterModel> param;
  List<CategoryModel> cat;
  SharedPref sharedPref = SharedPref();
  CredentialModel credential;
  List<CategoryModel> cat1 = new List<CategoryModel>();
  List<CategoryModel> subcat1 = new List<CategoryModel>();
  CategoryModel selectedCat = new CategoryModel();
  CategoryModel selectedSubCat1 = new CategoryModel();
  bool _showAttachment = false;
  String attachName1 = "ATTACHMENT";
  String attachName2 = "PHOTO";
  AbstractRequest abr = new AbstractRequest();
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Map<String, dynamic> map = await sharedPref.read("credential");
      setState(() {
        credential = CredentialModel.fromJson(map);
      });
      loadCategory();
      loadParameter();
    });
  }

  Future chooseFile(number) async {
    switch (number) {
      case 1:
        {
          attach1 = await FilePicker.getFile();
          setState(() {
            attachName1 = attach1.path.split("/").last;
          });
        }
        break;

      case 2:
        {
          attach2 = await FilePicker.getFile();
          setState(() {
            attachName2 = attach2.path.split("/").last;
          });
        }
        break;

      default:
        {
          attach1 = await FilePicker.getFile();
          setState(() {
            attachName1 = attach1.path.split("/").last;
          });
        }
        break;
    }
  }

  doUpload(File file) async {
    if (file == null)
      return null;
    else {
      String base64File = base64Encode(file.readAsBytesSync());
      String fileName = file.path.split("/").last;
      var data = {"base64file": base64File, "filename": fileName};
      String jsonBody = json.encode(data);
      final resUpload = await abr.post('/ticket/IT/base64upload', jsonBody);
      if (resUpload.statusCode == 200) {
        var responseJson = json.decode(resUpload.body);
        return responseJson["filename"];
      }
    }
  }

  Future<void> myAlert(String message, Function func) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(message)],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              textColor: Color(0xff000000),
              color: Color(0xffffcc00),
              onPressed: () {
                Navigator.of(context).pop();
                func();
              },
            ),
          ],
        );
      },
    );
  }

  Future loadParameter() async {
    var crit = {"isActive": true};
    String jsonBody = json.encode(crit);
    final response = await abr.post('/parameter/IT/parameter_cr', jsonBody);
    if (response.statusCode == 200) {
      //Map<String, dynamic> map = json.decode(response.body);
      var responseJson = json.decode(response.body);
      setState(() {
        param = (responseJson as List)
            .map((p) => ParameterModel.fromJson(p))
            .toList();
      });
    }
  }

  Future loadCategory() async {
//    Map<String, dynamic> map = await sharedPref.read("credential");
//    setState(() {
//      credential = CredentialModel.fromJson(map);
//    });
    //String URL = globalVariables.BASE_URL + '/category/category_cr';

    var crit = {"isActive": true};
    String jsonBody = json.encode(crit);
    final response = await abr.post('/category/IT/category_cr', jsonBody);
//    print('jsonBody: ${jsonBody}');
//    final encoding = Encoding.getByName('utf-8');
//
//    bool trustSelfSigned = true;
//    HttpClient httpClient = new HttpClient();
//    httpClient.badCertificateCallback =
//        ((X509Certificate cert, String host, int port) => trustSelfSigned);
//    IOClient ioClient = new IOClient(httpClient);
//
//    final response = await ioClient.post(
//      URL,
//      headers: {
//        "Content-Type": "application/json",
//        "x-access-token": credential.token
//      },
//      body: jsonBody,
//      encoding: encoding,
//    );

    if (response.statusCode == 200) {
      //Map<String, dynamic> map = json.decode(response.body);
      var responseJson = json.decode(response.body);
      setState(() {
        cat = (responseJson as List)
            .map((p) => CategoryModel.fromJson(p))
            .toList();
        cat1.addAll(cat.where((r) => r.pLevel == "1").toList());
        subcat1.addAll(cat.where((r) => r.pLevel == "2").toList());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    myDDL("Category", cat1, _category, (val) {
                      setState(() {
                        _category = val;
                        selectedCat =
                            cat.where((r) => r.pId == val).toList()[0];
                        _subcategory = null;
                        _showAttachment = false;
                        subcat1 = new List<CategoryModel>();
                        subcat1 = cat.where((r) => r.pLevel == "2").toList();
                        subcat1 = subcat1
                            .where((r) => r.pParent == _category)
                            .toList();
                      });
                    }),
                    SizedBox(height: 25.0),
                    myDDL("Sub Category", subcat1, _subcategory, (val) {
                      setState(() {
                        _subcategory = val;
                        selectedSubCat1 =
                            cat.where((r) => r.pId == val).toList()[0];
                        if (selectedSubCat1.pFileNama != null) {
                          _showAttachment = true;
                        } else {
                          _showAttachment = false;
                        }
                      });
                    }),
                    SizedBox(height: 25.0),
//                Visibility(
//                  child: myButton(attachName1, (){
//                    chooseFile(1);
//                  }),
//                  maintainSize: true,
//                  maintainAnimation: true,
//                  maintainState: true,
//                  visible: _showAttachment,
//                )
                    myTextField("Title", (val) {
                      _title = val;
                    }),
                    SizedBox(height: 25.0),
                    myTextField("Description", (val) {
                      _description = val;
                    }),
                    SizedBox(height: 25.0),
                    myTextField("Handphone", (val) {
                      _handphone = val;
                    }, isNumber: true),
                    SizedBox(height: 25.0),
                    if (_showAttachment)
                      myButton(attachName1, 0xffd1def0, () {
                        chooseFile(1);
                      }),
                    if (_showAttachment)
                      SizedBox(height: 25.0),
                    myButton(attachName2, 0xffd1def0, () {
                      chooseFile(2);
                    }),
                    SizedBox(height: 25.0),
                    myButton("SUBMIT", 0xffffcc00, () {
                      final form = _formKey.currentState;
                      form.save();
                      print(form.validate());
                      if (form.validate()) {
                        if (attach2 == null) {
                          myAlert("Please attach at lease 1 document / photo!", (){});
                        } else {
                          var data = {
                            "tProblem": _title,
                            "tMsg": _description,
                            "rDate": new DateTime.now()
                                .toIso8601String()
                                .replaceAll("T", " ")
                                .substring(0, 23),
                            "pNoHandphone": _handphone,
                            "ipAddress": "NativeAndroid",
                            "tStat":"0",
                            "pPriority": cat
                                .where((r) => r.pId == _subcategory)
                                .toList()[0]
                                .pPriorityID,
                            "pCat": _category,
                            "pCatSub1": _subcategory,
                            "pCatSub2": "",
                            "pNote": "",
                            "pMax": param
                                .where((r) =>
                                    r.pID == "PRTY" &&
                                    r.pKey ==
                                        cat
                                            .where((r) => r.pId == _subcategory)
                                            .toList()[0]
                                            .pPriorityID)
                                .toList()[0]
                                .pText
                          };
                          doSubmit(data);
                        }
                      } else {}
                    })
                  ],
                ))));
  }

  void onLoading(Function func) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 5,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: 20),
            Row(mainAxisSize: MainAxisSize.max, children: [
              new SizedBox(
                width: 20,
              ),
              new CircularProgressIndicator(),
              new SizedBox(
                width: 10,
              ),
              new Text("Loading"),
              new SizedBox(
                width: 20,
              )
            ]),
            SizedBox(height: 20)
          ]),
        );
      },
    );
    func(context);
  }

  void doSubmit(data) async {
    this.onLoading((context) async {
      data["pName"] = credential.name;
      data["createBy"] = "ACSET\\"+credential.username;
      data["pMail"] = credential.email;
      data["pDept"] = credential.dept;
      data["pAttach1"] = await doUpload(attach1);
      data["pAttach2"] = await doUpload(attach2);

      String jsonBody = json.encode(data);
      final response = await abr.post('/ticket/IT/', jsonBody);
      print(jsonBody);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        var responseJson = json.decode(response.body);
        myAlert("Ticket submitted with number "+responseJson[0]["tID"], (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(selectedView: 1)),
          );
        });

      }else{
        myAlert("An error occured. Please try again later.", (){

        });
      }
    });



  }

  myDDL(placeholder, List<CategoryModel> list, selectedCat, Function func) {
    //list.add(new CategoryModel(pDesc: "-Select-", pId: null));
    return DropdownButtonFormField<String>(
        validator: (value) {
          if (value == null) {
            return placeholder + ' required';
          }
          return null;
        },
        value: selectedCat == null ? null : selectedCat,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          labelText: placeholder,
//                      fillColor: Colors.white,
//                      filled: true,
          labelStyle: TextStyle(color: Colors.black),
          errorBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.red),
            borderRadius: new BorderRadius.circular(0.0),
          ),
          errorStyle: TextStyle(color: Colors.red),
          focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Color(0xff283271)),
            borderRadius: new BorderRadius.circular(0.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Color(0xff283271)),
            borderRadius: new BorderRadius.circular(8),
          ),
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(0.0),
            ),
            borderSide: new BorderSide(
              color: Color(0xff283271),
              width: 1.0,
            ),
          ),
        ),
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black, fontSize: 16),
        onChanged: (value) {
          func(value);
        },
        items: list != null
            ? list.map((CategoryModel value) {
                return DropdownMenuItem<String>(
                    value: value.pId, child: Text(value.pDesc));
              }).toList()
            : new List<CategoryModel>()
//
        );
  }

  myTextField(placeholder, Function func, {bool isNumber = false}) {
    return TextFormField(
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: <TextInputFormatter>[
        isNumber
            ? WhitelistingTextInputFormatter.digitsOnly
            : WhitelistingTextInputFormatter(RegExp("."))
      ],
      validator: (value) {
        if (value.isEmpty) {
          return placeholder + ' required';
        }
        return null;
      },
      onSaved: (value) => func(value),
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: placeholder,
//                      fillColor: Colors.white,
//                      filled: true,
        labelStyle: TextStyle(color: Colors.black),
        errorBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.red),
          borderRadius: new BorderRadius.circular(0.0),
        ),
        errorStyle: TextStyle(color: Colors.red),
        focusedBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: Color(0xff283271)),
          borderRadius: new BorderRadius.circular(0.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: Color(0xff283271)),
          borderRadius: new BorderRadius.circular(8),
        ),
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(0.0),
          ),
          borderSide: new BorderSide(
            color: Color(0xff283271),
            width: 1.0,
          ),
        ),
      ),
    );
  }

  myButton(text, color, Function func) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(8.0),
      color: Color(color),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          func();
//          final form = _formKey.currentState;
//          form.save();
//          if (form.validate()) {
//            print("$_username $_password");
//            Provider.of<AuthService>(context, listen: false)
//                .loginUser(
//                username: _username, password: _password);
//          }
        },
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  myText(inputText) {
    return Text(
      inputText,
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
  }
}
