import 'dart:convert';

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
}
