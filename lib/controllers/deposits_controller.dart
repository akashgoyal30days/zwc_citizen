import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zwc/api/api_client.dart';
import 'package:zwc/api/urls.dart';

class DepositsController extends GetxController {
  bool depositsLoading = false;
  List<DepositModel> deposits = [];

  DepositsController(DateTimeRange timeRange) {
    getDeposits(timeRange);
  }

  getDeposits(DateTimeRange dateTimeRange) async {
    depositsLoading = true;
    deposits.clear();
    update();
    var response = await APIClient.post(URLS.deposits, body: {
      "fromdate":
          DateFormat('yyyy-MM-dd').format(dateTimeRange.start).toString(),
      "todate": DateFormat('yyyy-MM-dd').format(dateTimeRange.end).toString()
    });

    if (response.statusCode != 200) {
      depositsLoading = false;
      return;
    }

    var data = json.decode(response.body)["data"] as List;
    for (var transaction in data) {
      deposits.add(DepositModel(transaction));
    }

    depositsLoading = false;
    update();
  }
}

class DepositModel {
  final String id, transactionID, amount;
  final DateTime date;
  final bool isDonation;
  DepositModel(data)
      : id = data["id"].toString(),
        transactionID = data["transaction_id"].toString(),
        date = DateTime.parse(data["transaction_date"].toString()),
        amount = data["amount"].toString(),
        isDonation = data["is_donation"].toString() == "1";
}
