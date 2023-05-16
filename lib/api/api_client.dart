import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zwc/app_constants.dart';
import 'package:zwc/api/urls.dart';
import 'package:zwc/data/shared_preference.dart';

class APIClient {
  static Future<http.Response> post(String url, {Map? body}) async {
    return await http
        .post(Uri.parse(URLS.baseURL + url), body: json.encode(body), headers: {
      "Content-Type": "application/json",
      "Client-Service": AppConstants.appKey,
      "Auth-Key": AppConstants.appSecret,
      // "uid" : "3",
      // "token" : "640328ac60b35",
      if (SharedPreferenceSingleTon.getData("uid") != null)
        "uid": SharedPreferenceSingleTon.getData("uid") ?? "",
      if (SharedPreferenceSingleTon.getData("token") != null)
        "token": SharedPreferenceSingleTon.getData("token") ?? "",
    });
  }
}
