import 'dart:convert';
import 'dart:developer';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:zwc/api/api_client.dart';
import 'package:zwc/api/urls.dart';

class ChangePasswordController extends GetxController {
  String errorText = "";
  bool showLoading = false;
  Future<bool> changePassword(newPassword) async {
    showLoading = true;
    errorText = "";
    update();
    var response = await APIClient.post(URLS.changePassword, body: {
      "password": newPassword,
      "confirm_password": newPassword,
    });
    var body = json.decode(response.body);
    if (response.statusCode != 200) {
      errorText = body["message"];
      return false;
    }

    showLoading = false;
    update();
    return true;
  }

  Future<bool> forgotpassword({String? username}) async {
    showLoading = true;
    errorText = "";
    update();
    var response = await APIClient.post(URLS.forgotpassword, body: {
      "username": username,
    });
    var body = json.decode(response.body);
    log(body.toString());
    if (response.statusCode != 200) {
      return false;
    }

    showLoading = false;
    update();
    return true;
  }
}
