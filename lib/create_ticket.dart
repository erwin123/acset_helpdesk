import 'dart:convert';
import 'dart:io';
import 'package:acset_helpdesk/model/category.dart';
import 'package:acset_helpdesk/model/credential.dart';
import 'package:acset_helpdesk/services/sharepref.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:acset_helpdesk/static/global_var.dart' as globalVariables;
import 'package:http/http.dart' as http;

class CreateTicket extends StatefulWidget {
  @override
  _CreateTicketState createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  final _formKey = GlobalKey<FormState>();
  String _title;
  String _description;
  File attach1;
  File attach2;

  String _category;
  String _subcategory;
  List<CategoryModel> cat;
  SharedPref sharedPref = SharedPref();
  CredentialModel credential;
  List<CategoryModel> cat1 = new List<CategoryModel>();
  List<CategoryModel> subcat1 = new List<CategoryModel>();
  CategoryModel selectedCat = new CategoryModel();
  CategoryModel selectedSubCat1 = new CategoryModel();
  bool _showAttachment = false;
  String attachName1 = "Attachment";
  String attachName2 = "Photo";
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadCategory());
  }

  Future chooseFile(number) async{
    switch(number) {
      case 1: {
        attach1 =  await FilePicker.getFile();
        setState(() {
          attachName1 = attach1.path.split("/").last;
        });

      }
      break;

      case 2: {
        attach2 =  await FilePicker.getFile();
        setState(() {
          attachName2 = attach2.path.split("/").last;
        });
      }
      break;

      default: {
        attach1 =  await FilePicker.getFile();
        setState(() {
          attachName1 = attach1.path
              .split("/")
              .last;
        });
      }
      break;
    }

  }
  void _upload() {
    if (attach1 == null) return;
    String base64Image = base64Encode(attach1.readAsBytesSync());
    String fileName = attach1.path.split("/").last;
//    http.post(phpEndPoint, body: {
//      "image": base64Image,
//      "name": fileName,
//    }).then((res) {
//      print(res.statusCode);
//    }).catchError((err) {
//      print(err);
//    });
  }
  Future loadCategory() async {
    Map<String, dynamic> map = await sharedPref.read("credential");
    setState(() {
      credential = CredentialModel.fromJson(map);
    });
    print(credential.token);
    String URL = globalVariables.BASE_URL + '/category/IT/category_cr';
    CategoryModel loginModel = new CategoryModel();
    var crit = {"isActive": true};
    String jsonBody = json.encode(crit);
    print('jsonBody: ${jsonBody}');
    final encoding = Encoding.getByName('utf-8');
    final response = await http.post(
      URL,
      headers: {
        "Content-Type": "application/json",
        "x-access-token": credential.token
      },
      body: jsonBody,
      encoding: encoding,
    );
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
      //print(CategoryModel.fromJson(map).pText);
//      sharedPref.saveString("token", map["token"]);
//      sharedPref.saveString("username", map["username"]);
//      sharedPref.saveString("role", map["ur"]);
//      sharedPref.saveString("email", map["email"]);
//        this.credential = CredentialModel.fromJson(map);
//        await sharedPref.save("credential", CredentialModel.fromJson(map).toJson());
//        notifyListeners();
//        return Future.value(this.credential);
    }
  }

//      else{
//        Future.value(null);
//        return Future.value(null);
//      }

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
                    selectedCat = cat.where((r)=>r.pId == val).toList()[0];
                    _subcategory = null;
                    _showAttachment = false;
                    subcat1 = new List<CategoryModel>();
                    subcat1 = cat.where((r) => r.pLevel == "2").toList();
                    subcat1 = subcat1.where((r) => r.pParent == _category).toList();
                  });
                }),
                SizedBox(height: 25.0),
                myDDL("Sub Category", subcat1, _subcategory, (val) {
                  setState(() {
                    _subcategory = val;
                    selectedSubCat1 = cat.where((r)=>r.pId == val).toList()[0];
                    if(selectedSubCat1.pFileNama != null){
                      _showAttachment = true;
                    }else{
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
                if(_showAttachment)myButton(attachName1, (){
                  chooseFile(1);
                }),
                if(_showAttachment)SizedBox(height: 25.0),
                myButton(attachName2, (){
                  chooseFile(2);
                }),
                SizedBox(height: 25.0),
                myButton("SUBMIT", (){
                  final form = _formKey.currentState;
                  form.save();
                  print(form.validate());
                  if (form.validate()) {

                  }else{

                  }
                })
              ],
            ))));
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
      value: selectedCat == null? null : selectedCat,
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

  myTextField(placeholder, Function func, {bool type = false}) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return placeholder + ' required';
        }
        return null;
      },
      onSaved: (value) => func(value),
      obscureText: type,
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

  myButton(text, Function func) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(8.0),
      color: Color(0xffffcc00),
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
