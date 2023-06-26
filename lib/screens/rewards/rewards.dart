import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zwc/api/api_client.dart';
import 'package:zwc/api/urls.dart';
import 'package:zwc/controllers/rewards_controller.dart.dart';
import 'package:zwc/screens/rewards/redeemhistiry.dart';
import 'package:zwc/widgets/transaction_widget.dart';

import 'deposits.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2023, DateTime.now().month, DateTime.now().day - 14),
    end: DateTime(2023, DateTime.now().month, DateTime.now().day + 1),
  );
  final reedempointscontroller = TextEditingController();

  @override
  void initState() {
    Get.put<RewardsController>(RewardsController(dateRange));
    super.initState();
  }

  Future<bool?> makeredeemrequest(String? amount) async {
    var response = await APIClient.post(URLS.makereedemrequest,
        body: {"amount": amount.toString()});
    var body = json.decode(response.body);
    if (response.statusCode == 200) {
      log(body.toString());
      if (body["status"].toString() == "true") {
        return true;
      } else {
        return false;
      }
    }
    return null;
  }

  redeempointspopup(
    BuildContext context,
  ) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: reedempointscontroller,
                    decoration: InputDecoration(
                      hintText: 'Enter Points To Redeem',
                      labelText: 'Enter Redeem Points',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 50,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        makeredeemrequest(
                                reedempointscontroller.text.toString())
                            .then((value) => {
                                  if (value == true)
                                    {
                                      Get.showSnackbar(const GetSnackBar(
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.blue,
                                        title: "Redeem Points",
                                        message: "Request Sent Successfully",
                                      )),
                                      Get.delete<RewardsController>(),
                                      Get.to(RewardsScreen())
                                    }
                                  else
                                    {
                                      Get.showSnackbar(const GetSnackBar(
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                        title: "Redeem Points",
                                        message: "Error,Please Try Later",
                                      ))
                                    }
                                });
                      },
                      child: const Text("Redeem Now"),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RewardsController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Rewards",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () async {
                var dates = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2010),
                  lastDate: DateTime.now(),
                  initialDateRange: dateRange,
                );
                if (dates == null) return;
                if (dateRange.start != dates.start ||
                    dateRange.end != dates.end) {
                  dateRange = dates;
                  controller.getTransactions(dateRange);
                  setState(() {});
                }
              },
            )
          ],
          centerTitle: true,
        ),
        body: ListView(
          physics: controller.transactionLoading
              ? NeverScrollableScrollPhysics()
              : null,
          children: [
            InkWell(
                onTap: () {
                  redeempointspopup(context);
                },
                child: const CurrentBalance()),
            if (controller.transactionLoading) const LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "History",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green),
                    ),
                  ),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                          children: [
                        TextSpan(
                            text: DateFormat("d MMMM").format(dateRange.start)),
                        const TextSpan(text: " - "),
                        TextSpan(
                            text: DateFormat("d MMMM").format(dateRange.end)),
                      ])),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (controller.transactionLoading)
              for (int i = 0; i < 15; ++i) ShimmerWidget(),
            if (!controller.transactionLoading &&
                controller.transactions.isEmpty)
              const Center(
                  child: Text(
                "You haven't made any transactions",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              )),
            if (controller.transactions.isNotEmpty)
              ...controller.transactions
                  .map<Widget>((transaction) => TransactionWidget(transaction))
                  .toList()
          ],
        ),
      );
    });
  }
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(
          indent: 8,
          endIndent: 8,
        ),
      ],
    );
  }
}

class CurrentBalance extends StatelessWidget {
  const CurrentBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RewardsController>(builder: (controller) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            "assets/images/confetti.jpeg",
          ),
          fit: BoxFit.cover,
        )),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Rewards Balance",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    controller.balanceLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : RichText(
                            text: TextSpan(
                              style: GoogleFonts.lato(color: Colors.white),
                              children: [
                                TextSpan(
                                    text: controller.balance,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const TextSpan(
                                    text: " Pts",
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Tap to Reedem Points",
                      style: GoogleFonts.montserrat(
                        letterSpacing: 2,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => ReedemhistoryScreen());
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Redeem History",
                    style: TextStyle(fontSize: 18),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(() => DepositsScreen());
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("View Deposits"),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
