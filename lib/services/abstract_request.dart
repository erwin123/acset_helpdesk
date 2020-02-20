import 'dart:io';
import 'package:acset_helpdesk/model/credential.dart';
import 'package:acset_helpdesk/services/sharepref.dart';
import 'package:http/io_client.dart';
import 'dart:convert';
import 'package:acset_helpdesk/static/global_var.dart' as globalVariables;

class AbstractRequest {
  String URL = globalVariables.BASE_URL;
  final encoding = Encoding.getByName('utf-8');
  bool trustSelfSigned = true;
  HttpClient httpClient = new HttpClient();
  IOClient ioClient = new IOClient();
  CredentialModel credential = new CredentialModel();
  SharedPref sharedPref = new SharedPref();
  Future credentialLoader;
  AbstractRequest() {
    credentialLoader = new Future(() async{
      Map<String, dynamic> map = await sharedPref.read("credential");
      credential = CredentialModel.fromJson(map);
    });
    httpClient.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
    ioClient = new IOClient(httpClient);
  }
  get(String Uri, String jsonBody) async {
    await credentialLoader;
    var UriHit =
        globalVariables.ENV == "PROD" ? Uri.replaceAll("IT/", "") : Uri;
    final response = await ioClient
        .get(UriHit + Uri,
        headers: {
          "Content-Type": "application/json",
          "x-access-token": credential.token
        });
    return response;
  }

  post(String Uri, String jsonBody) async {
    await credentialLoader;
    var UriHit =
        globalVariables.ENV == "PROD" ? Uri.replaceAll("IT/", "") : Uri;

    final response = await ioClient.post(
      URL + UriHit,
      headers: {
        "Content-Type": "application/json",
        "x-access-token": credential.token
      },
      body: jsonBody,
      encoding: encoding,
    );
    return response;
  }

  postNoToken(String Uri, String jsonBody) async {
    var UriHit =
    globalVariables.ENV == "PROD" ? Uri.replaceAll("IT/", "") : Uri;

    final response = await ioClient.post(
      URL + UriHit,
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonBody,
      encoding: encoding,
    );
    return response;
  }
  put(String Uri, String jsonBody) async {
    await credentialLoader;
    var UriHit =
        globalVariables.ENV == "PROD" ? Uri.replaceAll("IT/", "") : Uri;
    final response = await ioClient.put(
      URL + UriHit,
      headers: {
        "Content-Type": "application/json",
        "x-access-token": credential.token
      },
      body: jsonBody,
      encoding: encoding,
    );
    return response;
  }

  patch(String Uri, String jsonBody) async {
    await credentialLoader;
    var UriHit =
        globalVariables.ENV == "PROD" ? Uri.replaceAll("IT/", "") : Uri;
    final response = await ioClient.patch(
      URL + UriHit,
      headers: {
        "Content-Type": "application/json",
        "x-access-token": credential.token
      },
      body: jsonBody,
      encoding: encoding,
    );
    return response;
  }

  delete(String Uri, String Unique) async {
    await credentialLoader;
    var UriHit =
        globalVariables.ENV == "PROD" ? Uri.replaceAll("IT/", "") : Uri;
    final response = await ioClient.delete(
        URL + UriHit + "/" + Unique.toString(),
        headers: {
          "Content-Type": "application/json",
          "x-access-token": credential.token
        });
    return response;
  }
}
