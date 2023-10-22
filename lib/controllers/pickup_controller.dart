import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:zwc/api/api_client.dart';
import 'package:zwc/api/urls.dart';
import 'package:zwc/model/userassingedbranchmodel.dart';

import '../app_constants.dart';
import '../data/shared_preference.dart';

class PickupController extends GetxController {
  bool loadingHistory = false;
  var showLoading = true.obs;
  String errorText = "", newRequestErrorText = "";

  final List<PickRequestModel> pendingRequests = [],
      acceptedRequests = [],
      rejectedRequests = [],
      completedRequests = [];

  PickupController() {
    getHistoryRequests();
  }

  getHistoryRequests() async {
    pendingRequests.clear();
    acceptedRequests.clear();
    rejectedRequests.clear();
    completedRequests.clear();
    loadingHistory = true;
    errorText = "";
    update();

    var response = await APIClient.post(URLS.pastRequests);
    var body = json.decode(response.body);
    log(body.toString());

    if (response.statusCode != 200) {
      errorText = "unkown Error";
      loadingHistory = false;
      update();
    }
    for (var pickuprequest in (body["data"] as List).reversed.toList()) {
      var model = PickRequestModel(pickuprequest);
      if (model.pickRequestsType == 0) {
        pendingRequests.add(model);
      } else if (model.pickRequestsType == 1) {
        completedRequests.add(model);
      } else if (model.pickRequestsType == 2) {
        rejectedRequests.add(model);
      } else if (model.pickRequestsType == 3) {
        acceptedRequests.add(model);
      }
    }
    loadingHistory = false;
    update();
  }

  UserbranchassingeddataModel? userbranchdetails;
  List<dynamic> getratelistdata = [];

  getratelist() async {
    getratelistdata.clear();
    userbranchdetails = UserbranchassingeddataModel.fromJson(
        SharedPreferenceFunctions.getuserbranchdata());

    showLoading(true);
    update();
    var response = await APIClient.post(URLS.getratelist,
        body: {"branch": userbranchdetails!.bankBranchId.toString()});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      Map data1 = data["data"] as Map;
      data1.forEach((key, value) {
        if (key.toString() != "branch") {
          Map valuedata = value as Map;
          getratelistdata.add(valuedata);
        }
      });
      showLoading(false);
      update();
    }
  }

  Future<bool> newRequest(String weight, String time, String from, String to,
      String filePath) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(URLS.baseURL + URLS.newRequests),
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
    request.fields["approx_weight"] = weight;
    request.fields["slot_date_from"] = from;
    request.fields["slot_date_to"] = to;
    request.fields["slot_time"] = time;
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
      return false;
    }

    return true;
  }
}

class PickRequestModel {
  final String id,
      bankBranchId,
      requestedBy,
      requestNo,
      requestImage,
      approxWeight,
      slotTime,
      collectorId,
      rejectionRemarks,
      requestStatus,
      lcb,
      lct;
  final int pickRequestsType;
  final String slotDateFrom,
      slotDateTo,
      acceptanceDateTime,
      requestDateTime,
      pickupDateTime,
      rejectionDateTime;
  PickRequestModel(data)
      : id = data["id"],
        requestDateTime = (data["request_date_time"]),
        slotDateFrom = (data["slot_date_from"]),
        slotDateTo = (data["slot_date_to"]),
        acceptanceDateTime = (data["acceptance_date_time"]),
        pickupDateTime = (data["pickup_date_time"]),
        rejectionDateTime = (data["rejection_date_time"]),
        pickRequestsType = int.parse(data["request_status"] ?? "0"),
        requestImage = data["request_image"]?.toString() ?? "",
        approxWeight = data["approx_weight"]?.toString() ?? "",
        bankBranchId = data["bank_branch_id"]?.toString() ?? "",
        requestedBy = data["requested_by"]?.toString() ?? "",
        requestNo = data["request_no"]?.toString() ?? "",
        slotTime = data["slot_time"]?.toString() ?? "",
        collectorId = data["collector_id"]?.toString() ?? "",
        rejectionRemarks = data["rejection_remarks"]?.toString() ?? "",
        requestStatus = data["request_status"]?.toString() ?? "",
        lcb = data["lcb"]?.toString() ?? "",
        lct = data["lct"]?.toString() ?? "";
}
