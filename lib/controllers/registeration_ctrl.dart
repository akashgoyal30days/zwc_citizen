import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zwc/routes.dart';

import '../api/api_client.dart';
import '../api/urls.dart';

class RegisterationController extends GetxController {
  bool showLoading = false, otpMode = false, gettingOTP = false;
  String? errorMessage;

  getOTP(String name, String number) async {
    if (name.isEmpty || number.isEmpty) return;

    gettingOTP = true;
    errorMessage = null;
    update();

    var response = await APIClient.post(
      URLS.registerCustomer,
      body: {
        "name": name,
        "phone_num": number,
      },
    );

    var body = json.decode(response.body) ?? {};

    log(response.body);

    if (response.statusCode != 200) {
      errorMessage = body?["message"] ?? "Unkown Error";
      gettingOTP = false;
      update();
      return;
    }

    gettingOTP = false;
    otpMode = body["status"] == true;
    update();
    return body?["user_id"].toString();
  }

  Future<bool> resendOTP(String phoneNumber) async {
    gettingOTP = true;
    errorMessage = null;
    update();

    var response = await APIClient.post(URLS.registrationResendOTP,
        body: {"phone_num": phoneNumber});

    var body = json.decode(response.body) ?? {};
    log(body.toString());

    if (response.statusCode != 200 || body["status"] == false) {
      errorMessage = body?["message"] ?? "Unkown Error";
      gettingOTP = false;
      update();
      return false;
    }

    gettingOTP = false;
    update();
    return true;
  }

  verifyOTP(String otp, String userID) async {
    showLoading = true;
    errorMessage = null;
    update();

    var response =
        await APIClient.post(URLS.registrationOTPVerification, body: {
      "user_id": userID,
      "otp": otp,
    });

    var body = json.decode(response.body) ?? {};

    if (response.statusCode != 200 || body["status"] == false) {
      errorMessage = body?["message"] ?? "Unkown Error";
      showLoading = false;
      update();
      return false;
    }

    Get.offNamed(ZWCRoutes.toLoginScreen);
    Get.showSnackbar(const GetSnackBar(
      titleText: Text(
        "Account created Succesfully",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: Text(
        "Now login with the credentials",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 5),
    ));
  }
}
