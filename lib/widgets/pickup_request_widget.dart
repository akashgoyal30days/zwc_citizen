import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/pickup_controller.dart';

class PickupRequestWidget extends StatefulWidget {
  const PickupRequestWidget(this.model, {super.key});
  final PickRequestModel model;

  @override
  State<PickupRequestWidget> createState() => _PickupRequestWidgetState();
}

class _PickupRequestWidgetState extends State<PickupRequestWidget> {
  DateFormat formattime = DateFormat("dd MMMM,y");
  String errordatetimestring = "0000-00-00 00:00:00";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: widget.model.requestImage,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    StatusWidget(widget.model.pickRequestsType),
                    const SizedBox(height: 8),
                    if (widget.model.pickRequestsType == 3)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: "Pickup between ",
                              style: TextStyle(color: Colors.white)),
                          TextSpan(
                              text: widget.model.slotDateFrom,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          const TextSpan(
                              text: " and ",
                              style: TextStyle(color: Colors.white)),
                          TextSpan(
                              text: widget.model.slotDateTo,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ])),
                      ),
                    if (widget.model.pickRequestsType == 2)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.model.rejectionDateTime == errordatetimestring
                              ? SizedBox()
                              : RichText(
                                  text: TextSpan(children: [
                                    const TextSpan(
                                        text: "Rejected on ",
                                        style: TextStyle(color: Colors.white)),
                                    TextSpan(
                                        text: formattime.format(DateTime.parse(
                                            widget.model.rejectionDateTime)),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ]),
                                ),
                          if (widget.model.rejectionRemarks.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "Rejection Reason: ",
                                      style: TextStyle(color: Colors.white)),
                                  TextSpan(
                                      text: widget.model.rejectionRemarks
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ]),
                              ),
                            ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    if (widget.model.pickRequestsType == 1)
                      widget.model.pickupDateTime == errordatetimestring
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: RichText(
                                  text: TextSpan(children: [
                                const TextSpan(
                                    text: "Pickedup on ",
                                    style: TextStyle(color: Colors.white)),
                                TextSpan(
                                    text: formattime.format(DateTime.parse(
                                        widget.model.pickupDateTime)),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ])),
                            ),
                    Row(
                      children: [
                        Expanded(
                          child: widget.model.requestDateTime ==
                                  errordatetimestring
                              ? SizedBox()
                              : RichText(
                                  text: TextSpan(children: [
                                  const TextSpan(
                                      text: "Requested on ",
                                      style: TextStyle(color: Colors.grey)),
                                  TextSpan(
                                      text: formattime.format(DateTime.parse(
                                          widget.model.requestDateTime)),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ])),
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: widget.model.approxWeight,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: " kg"),
                        ])),
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class StatusWidget extends StatelessWidget {
  const StatusWidget(
    this.requestType, {
    Key? key,
  }) : super(key: key);
  final int requestType;
  @override
  Widget build(BuildContext context) {
    if (requestType == 0) {
      return Container(
        // decoration: BoxDecoration(
        //   color: Colors.yellow.withOpacity(0.5),
        //   borderRadius: BorderRadius.circular(8),
        // ),
        // padding: const EdgeInsets.symmetric(
        //   vertical: 4,
        //   horizontal: 8,
        // ),
        child: const Text(
          "Pending",
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    if (requestType == 1 || requestType == 3) {
      return Container(
        // decoration: BoxDecoration(
        //   color: Colors.green.withOpacity(0.5),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        // padding: const EdgeInsets.symmetric(
        //   vertical: 4,
        //   horizontal: 8,
        // ),
        child: requestType == 3
            ? const Text(
                "Accepted",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text(
                "Completed",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
      );
    }

    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.red.withOpacity(0.5),
      //   borderRadius: BorderRadius.circular(10),
      // ),
      // padding: const EdgeInsets.symmetric(
      //   vertical: 4,
      //   horizontal: 8,
      // ),
      child: const Text(
        "Rejected",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
