import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:zwc/data/shared_preference.dart';
import 'package:zwc/model/userassingedbranchmodel.dart';

import '../api/api_client.dart';
import '../api/urls.dart';
import '../routes.dart';
import '../screens/auth/login.dart';

class LogInSuccessController extends GetxController {
  LogInSuccessController();

  UserbranchassingeddataModel? userbranchassigneData;
  getUserProfile([bool? shouldGotoDashboard]) async {
    var response = await APIClient.post(URLS.getUserDetails);

    if (response.statusCode != 200) {
      SharedPreferenceFunctions.logout();
      Get.offAll(() => const LoginScreen());
      Get.showSnackbar(const GetSnackBar(
        title: "Unknown Error",
        message: "Please Login Again",
      ));
      return;
    }

    var body = json.decode(response.body)["data"];
    log(body.toString());

    await SharedPreferenceFunctions.clearUserData();
    await SharedPreferenceFunctions.setUserData(body);
    await SharedPreferenceFunctions.setbranchdetails(
        body["branch_assigned"][0]);

    if (shouldGotoDashboard == true) {
      Get.offAllNamed(
        body["is_address_ent"] == "1"
            ? ZWCRoutes.toHomeScreen
            : ZWCRoutes.toNewUserProfile,
      );
    }
  }
}
