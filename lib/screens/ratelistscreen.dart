import 'dart:math';

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

  List<Color> colorlist = [
    Colors.green.shade300,
    Colors.indigo.shade300,
    Colors.pink.shade300,
    Colors.teal.shade300,
    Colors.blue.shade300,
    Colors.deepPurple.shade300
  ];
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
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "List of Products (${pickupcontroller.getratelistdata.length})",
                    style: GoogleFonts.montserrat(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Text(
                  //           "Product Name",
                  //           style: TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.w500),
                  //         ),
                  //       ),
                  //       Text(
                  //         "Purchase Price",
                  //         style: TextStyle(
                  //             color: Colors.black,
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.w500),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: pickupcontroller.getratelistdata.length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return Container(
                  //         decoration: BoxDecoration(
                  //             border: Border.all(color: Colors.grey.shade200)),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Row(
                  //             children: [
                  //               Expanded(
                  //                 child: Text(
                  //                   pickupcontroller.getratelistdata[index]
                  //                       ["product_name"],
                  //                   style: TextStyle(
                  //                     fontSize: 16,
                  //                     color: Colors.black,
                  //                   ),
                  //                 ),
                  //               ),
                  //               Text(
                  //                 pickupcontroller.getratelistdata[index]
                  //                     ["purchase_price"],
                  //                 style: TextStyle(
                  //                     color: Colors.black,
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.bold),
                  //               ),
                  //               Text(" / "),
                  //               Text(pickupcontroller.getratelistdata[index]
                  //                   ["unit"])
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pickupcontroller.getratelistdata.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Container(
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                offset: Offset(10, 10),
                                blurRadius: 10,
                                color: Colors.grey.shade300,
                              )
                            ]),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        colorlist[Random().nextInt(6)],
                                    child: Text(
                                      pickupcontroller.getratelistdata[index]
                                              ["product_name"]
                                          .toString()
                                          .substring(0, 1),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            pickupcontroller
                                                    .getratelistdata[index]
                                                ["product_name"],
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Purchase Price : ",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "₹",
                                              style: GoogleFonts.montserrat(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              pickupcontroller
                                                      .getratelistdata[index]
                                                  ["purchase_price"],
                                              style: GoogleFonts.montserrat(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              " / ",
                                              style: GoogleFonts.montserrat(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              pickupcontroller
                                                      .getratelistdata[index]
                                                  ["unit"],
                                              style: GoogleFonts.montserrat(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
              );
            }
          },
        ));
  }
}
