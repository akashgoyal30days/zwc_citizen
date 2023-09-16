import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:zwc/api/api_client.dart';
import 'package:zwc/api/urls.dart';
import 'dart:developer';
import '../model/certificate_model.dart';

class DashboardController extends GetxController {
  bool showLoading = false, certificateLoading = false;
  String? errorText;
  String rewards = "0";
  CertificateModel? certificateModel;
  final List<WasteCollectedModel> wasteCollected = [];
  final List<CollectionModel> collection = [];
  final Map<String, double> environmentSaved = {},
      environmentSavedLifetime = {};
  DateTime? lastUpdatedOn;
  DashboardController();

  getDashboard(DateTimeRange dateRange) async {
    certificateModel = null;
    showLoading = true;
    errorText = null;
    wasteCollected.clear();
    collection.clear();
    environmentSaved.clear();
    environmentSavedLifetime.clear();
    update();

    var response = await APIClient.post(URLS.getDashboard, body: {
      "fromdate": DateFormat("y-MM-dd").format(dateRange.start).toString(),
      "todate": DateFormat("y-MM-dd").format(dateRange.end).toString()
    });

    if (response.statusCode != 200) {
      showLoading = false;
      update();
      return;
    }

    var body = json.decode(response.body);
    List labels, data;

    try {
      labels = body["data"]["waste_collection_graph"]["first"]["scaleLabels"]
          as List;
      data = body["data"]["waste_collection_graph"]["first"]["data"] as List;
      for (int i = 0; i < labels.length; ++i) {
        wasteCollected.add(WasteCollectedModel(labels[i], data[i].toDouble()));
      }
    } catch (e) {}

    try {
      labels = body["data"]["category_collection_graph"]["scaleLabels"] as List;
      data = body["data"]["category_collection_graph"]["data"] as List;

      for (int i = 0; i < labels.length; ++i) {
        collection.add(CollectionModel(labels[i], data[i].toDouble()));
      }
    } catch (e) {}

    try {
      labels = body["data"]["environment_saved_graph"]["scaleLabels"] as List;
      data = body["data"]["environment_saved_graph"]["data"] as List;

      for (int i = 0; i < labels.length; ++i) {
        environmentSaved.addAll({labels[i]: data[i]});
      }
    } catch (e) {}

    try {
      labels = body["data"]["environment_saved_graph_lifetime"]["scaleLabels"]
          as List;
      data = body["data"]["environment_saved_graph_lifetime"]["data"] as List;

      for (int i = 0; i < labels.length; ++i) {
        environmentSavedLifetime.addAll({labels[i]: data[i]});
      }
    } catch (e) {}

    rewards = body["data"]["wallet_balance"].toString();
    showLoading = false;
    lastUpdatedOn = DateTime.now();
    update();
  }

  getCertificate() async {
    if (certificateModel != null) return certificateModel;
    certificateLoading = true;
    update();
    try {
      var response = await APIClient.post(URLS.certificate);
      if (response.statusCode != 200) {
        throw "";
      }
      var body = json.decode(response.body);
      log(body.toString());

      var imageResponse = await get(Uri.parse(body["data"]["image"]));
      if (imageResponse.statusCode != 200) throw "";
      certificateLoading = false;
      update();
      certificateModel = CertificateModel(
        ImageBytes: imageResponse.bodyBytes,
        imageURL: body["data"]["image"],
        pdfURL: body["data"]["pdf"],
      );
      return certificateModel;
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        titleText: Text(
          "Error retrieving Certificate",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        messageText: Text(
          "Please try again",
          style: TextStyle(color: Colors.white),
        ),
      ));
      certificateLoading = false;
      update();
    }
  }
}

class WasteCollectedModel {
  final String label;
  final double data;
  const WasteCollectedModel(this.label, this.data);
}

class CollectionModel {
  final String label;
  final double data;
  const CollectionModel(this.label, this.data);
}
