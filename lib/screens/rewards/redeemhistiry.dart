import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zwc/controllers/deposits_controller.dart';
import 'package:zwc/controllers/rewards_controller.dart.dart';

class ReedemhistoryScreen extends StatefulWidget {
  const ReedemhistoryScreen({super.key});

  @override
  State<ReedemhistoryScreen> createState() => _DepositsScreenState();
}

class _DepositsScreenState extends State<ReedemhistoryScreen> {
  String errordatetimestring = "0000-00-00 00:00:00";
  DateFormat formattime = DateFormat("dd MMMM,y");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RewardsController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Reedem History",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            if (controller.showloading) const LinearProgressIndicator(),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Your Reedems History",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            controller.showloading
                ? ShimmerList()
                : Expanded(
                    child: controller.getallredeemrequestdata!.data!.isEmpty
                        ? ListView(
                            children: [
                              const Center(
                                  child: Text(
                                "You haven't made any Reedems \nduring this period",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              )),
                            ],
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 5,
                            ),
                            itemCount: controller
                                .getallredeemrequestdata!.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(color: Colors.green)),
                                elevation: 5,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "ID :" +
                                                  controller
                                                      .getallredeemrequestdata!
                                                      .data![index]
                                                      .userDetailId
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.grey
                                                      .withOpacity(0.8)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: controller
                                                          .getallredeemrequestdata!
                                                          .data![index]
                                                          .redeemAmount ==
                                                      ""
                                                  ? SizedBox()
                                                  : RichText(
                                                      text: TextSpan(children: [
                                                      const TextSpan(
                                                          text:
                                                              "Redeem Amount : ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      TextSpan(
                                                          text: controller
                                                              .getallredeemrequestdata!
                                                              .data![index]
                                                              .redeemAmount
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ])),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: controller
                                                          .getallredeemrequestdata!
                                                          .data![index]
                                                          .requestDateTime ==
                                                      errordatetimestring
                                                  ? SizedBox()
                                                  : RichText(
                                                      text: TextSpan(children: [
                                                      const TextSpan(
                                                          text: "Requested on ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey)),
                                                      TextSpan(
                                                          text: formattime.format(
                                                              DateTime.parse(controller
                                                                  .getallredeemrequestdata!
                                                                  .data![index]
                                                                  .requestDateTime
                                                                  .toString())),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ])),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: controller
                                                          .getallredeemrequestdata!
                                                          .data![index]
                                                          .requestStatus ==
                                                      ""
                                                  ? SizedBox()
                                                  : RichText(
                                                      text: TextSpan(children: [
                                                      const TextSpan(
                                                          text: "Status : ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey)),
                                                      TextSpan(
                                                          text: controller
                                                                      .getallredeemrequestdata!
                                                                      .data![
                                                                          index]
                                                                      .requestStatus
                                                                      .toString() ==
                                                                  "0"
                                                              ? "Pending"
                                                              : controller
                                                                          .getallredeemrequestdata!
                                                                          .data![
                                                                              index]
                                                                          .requestStatus
                                                                          .toString() ==
                                                                      "1"
                                                                  ? "Accepted"
                                                                  : "Unknown",
                                                          style: TextStyle(
                                                            color: controller
                                                                        .getallredeemrequestdata!
                                                                        .data![
                                                                            index]
                                                                        .requestStatus
                                                                        .toString() ==
                                                                    "0"
                                                                ? Colors.yellow
                                                                    .shade800
                                                                : controller
                                                                            .getallredeemrequestdata!
                                                                            .data![
                                                                                index]
                                                                            .requestStatus
                                                                            .toString() ==
                                                                        "1"
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors
                                                                        .grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ])),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: controller
                                                          .getallredeemrequestdata!
                                                          .data![index]
                                                          .statusRemark ==
                                                      ""
                                                  ? SizedBox()
                                                  : RichText(
                                                      text: TextSpan(children: [
                                                      const TextSpan(
                                                          text: "Remarks : ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey)),
                                                      TextSpan(
                                                          text: controller
                                                              .getallredeemrequestdata!
                                                              .data![index]
                                                              .statusRemark
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ])),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      );
    });
  }
}

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [for (int i = 0; i < 15; ++i) ShimmerWidget()],
      ),
    );
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 18,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: 18,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey,
                  ),
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

class DepositWidget extends StatelessWidget {
  const DepositWidget(this.model, {super.key});
  final DepositModel model;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.transactionID),
                    SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMMd().format(model.date),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      children: [
                        TextSpan(
                          text: "₹",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(text: model.amount),
                      ],
                    ),
                  ),
                  if (model.isDonation)
                    Card(
                      margin: EdgeInsets.only(top: 4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        child: Text(
                          "Donation",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      color: Colors.green,
                    )
                ],
              ),
            ],
          ),
          Divider(indent: 8, endIndent: 8),
        ],
      ),
    );
  }
}
