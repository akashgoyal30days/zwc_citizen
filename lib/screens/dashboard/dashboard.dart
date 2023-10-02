import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zwc/controllers/dashboard_controller.dart';

import '../../widgets/environment_saved.dart';
import '../../widgets/statistics.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.toWalletScreen});
  final VoidCallback toWalletScreen;
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTimeRange dateRange = DateTimeRange(
      start: DateTime(2023, DateTime.now().month, DateTime.now().day - 14),
      end: DateTime.now());
  @override
  void initState() {
    var controller = Get.find<DashboardController>();
    if (controller.wasteCollected.isEmpty) controller.getDashboard(dateRange);
    controller.updatefcmtoken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          // leading: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Image.asset(
          //     "assets/images/logo_only.png",
          //     color: Colors.white,
          //   ),
          // ),
          title: Text(
            "Dashboard",
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
                  controller.getDashboard(dateRange);
                  setState(() {});
                }
              },
            )
          ],
          centerTitle: true,
        ),
        body: SafeArea(
            child: controller.showLoading
                ? const Padding(
                    padding: EdgeInsets.only(top: 18.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : ListView(
                    children: [
                      const SizedBox(height: 16),
                      Wallet(
                        controller.rewards,
                        toWalletScreen: widget.toWalletScreen,
                      ),
                      EnvironmentSavedWidget(
                        dateRange: dateRange,
                        environmentSaving: controller.environmentSaved,
                        environmentSavingLifetime:
                            controller.environmentSavedLifetime,
                      ),
                      const SizedBox(height: 16),
                      Statistics(dateRange: dateRange),
                      if (controller.lastUpdatedOn != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, right: 16, bottom: 8),
                              child: Center(
                                child: Text(
                                  "last updated at ${DateFormat("hh:mm").format(controller.lastUpdatedOn!)}",
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  )),
      );
    });
  }
}

class Wallet extends StatelessWidget {
  const Wallet(
    this.rewards, {
    Key? key,
    required this.toWalletScreen,
  }) : super(key: key);
  final String rewards;
  final VoidCallback toWalletScreen;
  @override
  Widget build(BuildContext context) {
    try {
      if (double.parse(rewards) < 0.01) return SizedBox();
    } catch (e) {}
    return Card(
      color: Colors.green,
      elevation: 10,
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
      child: ListTile(
        onTap: toWalletScreen,
        leading: Icon(
          Icons.account_balance_wallet,
          color: Colors.white,
        ),
        title: Text(
          "My Rewards",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: RichText(
          text: TextSpan(
            style: GoogleFonts.lato(color: Colors.white),
            children: [
              TextSpan(
                text: rewards,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const TextSpan(text: " Pts"),
            ],
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
