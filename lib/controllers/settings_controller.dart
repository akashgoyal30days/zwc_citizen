import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zwc/controllers/log_in_success_controller.dart';
import 'package:zwc/data/shared_preference.dart';
import 'package:http/http.dart' as http;

import '../api/api_client.dart';
import '../api/urls.dart';
import '../app_constants.dart';
import '../model/locaiton_models.dart';

class SettingsController extends GetxController {
  late String name, email, phone, image, address;
  late Map userData;
  late AreaModel selectedArea;
  late BranchModel selectedBranch;
  BankModel? selectedBank;

  SettingsController() {
    getUserDetails();
  }

  getUserDetails() {
    userData = SharedPreferenceFunctions.getUserJSONData();
    name = userData["name"];
    email = userData["email"];
    phone = userData["phone_num"];
    image = userData["profile_image"];
    address = userData["address"];
    selectedArea = AreaModel({
      "id": userData["area_id"] ?? "",
      "name": userData["area"] ?? "",
    });
    selectedBranch = BranchModel(userData["branch_assigned"][0]);
    try {
      selectedBank = BankModel(data: userData["bank_details"]);
    } catch (e) {}
  }

  updateProfilePicture(String filePath) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(URLS.baseURL + URLS.updateUserProfilePicture),
    );
    request.headers.addAll({
      "Content-Type": "application/json",
      "Client-Service": AppConstants.appKey,
      "Auth-Key": AppConstants.appSecret,
      if (SharedPreferenceSingleTon.getData("uid") != null)
        "uid": SharedPreferenceSingleTon.getData("uid") ?? "",
      if (SharedPreferenceSingleTon.getData("token") != null)
        "token": SharedPreferenceSingleTon.getData("token") ?? "",
    });
    request.files.add(await http.MultipartFile.fromPath("file", filePath));
    var response = await request.send();
    if (response.statusCode != 200) {
      String errorReason = "";
      try {
        errorReason =
            (json.decode(await response.stream.bytesToString())["message"]
                    as String)
                .replaceAllMapped("<p>", (match) => "")
                .replaceAllMapped("</p>", (match) => "");
      } catch (e) {
        errorReason = response.reasonPhrase ?? "Unkown Error";
      }
      Get.showSnackbar(GetSnackBar(
        duration: Duration(seconds: 5),
        titleText: Text(
          "Error!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          errorReason,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }
    await updateAllUserDetails();
  }

  updatePersonalDetails(String name, String email) async {
    var response = await APIClient.post(URLS.updateUserProfile, body: {
      "name": name,
      "email": email,
      "address": address,
      "area_id": selectedArea.id
    });

    if (response.statusCode != 200) {
      Get.showSnackbar(GetSnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        titleText: Text(
          "Please try again",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        messageText: Text(
          "Unkown error occured while updating details",
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
    await updateAllUserDetails();
  }

  updateAddress(address, selectedArea) async {
    var response = await APIClient.post(URLS.updateUserProfile, body: {
      "name": name,
      "email": email,
      "address": address,
      "area_id": selectedArea.id
    });

    if (response.statusCode != 200) {
      Get.showSnackbar(GetSnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        titleText: Text(
          "Please try again",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        messageText: Text(
          "Unkown error occured while updating details",
          style: TextStyle(color: Colors.white),
        ),
      ));
      return false;
    }
    return true;
  }

  updateBranch(BranchModel? selectedBranch) async {
    var response = await APIClient.post(
      URLS.updateBranch,
      body: {"branch_id": selectedBranch?.id ?? ""},
    );
    print(response.body);
    if (response.statusCode != 200) {
      Get.showSnackbar(GetSnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        titleText: Text(
          "Please try again",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        messageText: Text(
          "Unkown error occured while updating details",
          style: TextStyle(color: Colors.white),
        ),
      ));
      return false;
    }
    return true;
  }

  updateLocationDetails(
      address, selectedArea, BranchModel selectedBranch) async {
    if (!await updateAddress(address, selectedArea)) return;
    if (!await updateBranch(selectedBranch)) return;
    await updateAllUserDetails();
  }

  updateBankDetails(BankModel bankModel) async {
    var response = await APIClient.post(
      URLS.updateBank,
      body: {
        "account_no": bankModel.accountNumber,
        "ifsc_code": bankModel.ifscCode,
        "upi_id": bankModel.upiID,
      },
    );
    if (response.statusCode != 200) {
      Get.showSnackbar(GetSnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        titleText: Text(
          "Please try again",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        messageText: Text(
          "Unkown error occuredcefce while updating details",
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
    print("Error 4");
    await updateAllUserDetails();
  }

  updatePassword(password) async {
    var response = await APIClient.post(URLS.changePassword, body: {
      "password": password,
      "confirm_password": password,
    });
    var body = json.decode(response.body);
    if (response.statusCode != 200) {
      String error = body["message"] ?? "Unknown Error, please try again";
      Get.showSnackbar(GetSnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        titleText: Text(
          "Please try again",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        messageText: Text(
          error,
          style: TextStyle(color: Colors.white),
        ),
      ));
      return false;
    }
    return true;
  }

  updateAllUserDetails() async {
    await LogInSuccessController().getUserProfile();
    getUserDetails();
    update();
  }
}
