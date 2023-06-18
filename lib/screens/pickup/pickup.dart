import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:zwc/controllers/pickup_controller.dart';
import 'package:zwc/screens/pickup/new_pickup_request.dart';

import '../../widgets/pickup_request_widget.dart';

class PickUpRequest extends StatefulWidget {
  const PickUpRequest({super.key});

  @override
  State<PickUpRequest> createState() => _PickUpRequestState();
}

class _PickUpRequestState extends State<PickUpRequest> {
  Color indicatorColor = Colors.yellow;

  @override
  void initState() {
    Get.put<PickupController>(PickupController());
    super.initState();
  }

  newRequest() async {
    var controller = Get.find<PickupController>();
    if (await Get.to(const NewPickupRequest(), fullscreenDialog: true) ==
        true) {
      controller.getHistoryRequests();
    }
    controller.newRequestErrorText = "";
  }

  @override
Widget build(BuildContext context) {
    // return MyListPage();
    return GetBuilder<PickupController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Pickup Requests",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: newRequest,
            )
          ],
          centerTitle: true,
        ),
        body: controller.loadingHistory
            ? const LinearProgressIndicator()
            : DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    Card(
                      margin:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: TabBar(
                        indicatorColor: indicatorColor,
                        onTap: (index) {
                          if (index == 0) indicatorColor = Colors.amber;
                          if (index == 1) indicatorColor = Colors.green;
                          if (index == 2) indicatorColor = Colors.red;
                          if (index == 3) indicatorColor = Colors.green;
                          setState(() {});
                        },
                        tabs: const [
                          Tab(
                              child: FittedBox(
                                  child: Text(
                            "Pending",
                            style: TextStyle(color: Colors.amber),
                          ))),
                          Tab(child: FittedBox(child: Text("Accepted"))),
                          Tab(
                              child: FittedBox(
                                  child: Text(
                            "Rejected",
                            style: TextStyle(color: Colors.red),
                          ))),
                          Tab(child: FittedBox(child: Text("Completed"))),
                        ],
                        labelColor: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          controller.pendingRequests.isEmpty
                              ? const Center(
                                  child: Text(
                                    "There are no pending requests",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    left: 16,
                                    right: 16,
                                    bottom: 80,
                                  ),
                                  children: controller.pendingRequests
                                      .map<Widget>((pickupRequest) =>
                                          PickupRequestWidget(pickupRequest))
                                      .toList(),
                                ),
                          controller.acceptedRequests.isEmpty
                              ? const Center(
                                  child: Text(
                                    "There are no accepted requests",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    left: 16,
                                    right: 16,
                                    bottom: 80,
                                  ),
                                  children: controller.acceptedRequests
                                      .map<Widget>((pickupRequest) =>
                                          PickupRequestWidget(pickupRequest))
                                      .toList(),
                                ),
                          controller.rejectedRequests.isEmpty
                              ? const Center(
                                  child: Text(
                                    "There are no rejected requests",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    left: 16,
                                    right: 16,
                                    bottom: 80,
                                  ),
                                  children: controller.rejectedRequests
                                      .map<Widget>((pickupRequest) =>
                                          PickupRequestWidget(pickupRequest))
                                      .toList(),
                                ),
                          controller.completedRequests.isEmpty
                              ? const Center(
                                  child: Text(
                                    "There are no completed requests",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ListView(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    left: 16,
                                    right: 16,
                                    bottom: 80,
                                  ),
                                  children: controller.completedRequests
                                      .map<Widget>((pickupRequest) =>
                                          PickupRequestWidget(pickupRequest))
                                      .toList(),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: newRequest,
          icon: const Icon(Icons.add),
          label: const Text("Pickup"),
        ),
      );
    });
  }
}
