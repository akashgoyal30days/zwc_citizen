import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zwc/controllers/deposits_controller.dart';

class DepositsScreen extends StatefulWidget {
  const DepositsScreen({super.key});

  @override
  State<DepositsScreen> createState() => _DepositsScreenState();
}

class _DepositsScreenState extends State<DepositsScreen> {
  DateTimeRange dateRange = DateTimeRange(
      start: DateTime(2023, DateTime.now().month, DateTime.now().day - 14),
      end: DateTime.now());

  @override
  void initState() {
    Get.put<DepositsController>(DepositsController(dateRange));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DepositsController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Deposits",
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
                  controller.getDeposits(dateRange);
                  setState(() {});
                }
              },
            )
          ],
          centerTitle: true,
        ),
        body: Column(
          children: [
            if (controller.depositsLoading) const LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Your Deposits",
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
            controller.depositsLoading
                ? ShimmerList()
                : Expanded(
                    child: ListView(
                      children: [
                        if (!controller.depositsLoading &&
                            controller.deposits.isEmpty)
                          const Center(
                              child: Text(
                            "You haven't made any deposits\nduring this period",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          )),
                        if (controller.deposits.isNotEmpty)
                          ...controller.deposits
                              .map<Widget>(
                                (deposit) => DepositWidget(deposit),
                              )
                              .toList()
                      ],
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
