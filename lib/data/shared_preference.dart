import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceSingleTon {
  static late SharedPreferences sharedPreferences;

  static initialize() async =>
      sharedPreferences = await SharedPreferences.getInstance();

  static setData(String key, String value) async =>
      await sharedPreferences.setString(key, value);

  static String? getData(String key) => sharedPreferences.getString(key);

  static clearAll() async => await sharedPreferences.clear();
}

class SharedPreferenceFunctions {
  static Map? decodedData;

  static bool isUserLoggedin() =>
      SharedPreferenceSingleTon.getData("uid") != null;

  static bool userNeedsRegistration() =>
      SharedPreferenceFunctions.getUserData("is_address_ent") != "1";

  static logout() async {
    decodedData = null;
    await SharedPreferenceSingleTon.clearAll();
  }

  static setUserData(data) async {
    decodedData = null;
    await SharedPreferenceSingleTon.setData("userProfile", json.encode(data));
  }

  static setbranchdetails(data) async {
    await SharedPreferenceSingleTon.setData(
        "userbranchdetails", json.encode(data));
  }

  static clearUserData() async =>
      await SharedPreferenceSingleTon.setData("userProfile", "");

  static getUserData(String key) {
    if (SharedPreferenceSingleTon.getData("userProfile") == null) return;
    decodedData ??=
        json.decode(SharedPreferenceSingleTon.getData("userProfile")!);
    return decodedData![key];
  }

  static Map getUserJSONData() {
    if (SharedPreferenceSingleTon.getData("userProfile") == null) return {};
    decodedData ??=
        json.decode(SharedPreferenceSingleTon.getData("userProfile")!);
    return decodedData!;
  }

  static Map<String, dynamic> getuserbranchdata() {
    if (SharedPreferenceSingleTon.getData("userbranchdetails") == null)
      return {};
    var data =
        json.decode(SharedPreferenceSingleTon.getData("userbranchdetails")!);
    return data!;
  }
}
