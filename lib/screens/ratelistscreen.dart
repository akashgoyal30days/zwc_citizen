import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwc/controllers/pickup_controller.dart';

class ratelistscreen extends StatefulWidget {
  const ratelistscreen({super.key});
  @override
  State<ratelistscreen> createState() => _StatisticsState();
}

final PickupController pickupcontroller = Get.put(PickupController());

class _StatisticsState extends State<ratelistscreen> {
  @override
  void initState() {
    super.initState();
    pickupcontroller.getratelist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Product Rate List",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(
          () {
            if (pickupcontroller.showLoading.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Product Name",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          "Purchase Price",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pickupcontroller.getratelistdata.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    pickupcontroller.getratelistdata[index]
                                        ["product_name"],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  pickupcontroller.getratelistdata[index]
                                      ["purchase_price"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(" / "),
                                Text(pickupcontroller.getratelistdata[index]
                                    ["unit"])
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ));
  }
}
