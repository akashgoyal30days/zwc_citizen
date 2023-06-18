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
    return Column(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.30,
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: CachedNetworkImage(
                    imageUrl: widget.model.requestImage,
                    placeholder: (__, _) =>
                        const Center(child: CircularProgressIndicator()),
                    fit: BoxFit.cover,
                  )),
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.green,
                      size: 14,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          " Requested on",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        Text(
                          widget.model.requestDateTime,
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ],
                ),
                if (widget.model.pickRequestsType == 1)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.recycling_outlined,
                        color: Colors.green,
                        size: 14,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            " Picked up on",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          Text(
                            widget.model.pickupDateTime,
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ],
                  ),
                if (widget.model.pickRequestsType == 2)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.remove_circle_outline_rounded,
                        color: Colors.green,
                        size: 14,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            " Rejected on",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          Text(
                            widget.model.rejectionDateTime,
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ],
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.scale,
                      color: Colors.green,
                      size: 14,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          " Weight",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        Text("${widget.model.approxWeight} KG(s)"),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ],
                ),
                if (widget.model.pickRequestsType == 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Your items are set to be picked up between ",
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        TextSpan(
                            text: widget.model.slotDateFrom,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                        const TextSpan(
                            text: " and ",
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        TextSpan(
                            text: widget.model.slotDateTo,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      ])),
                    ],
                  ),
                if (widget.model.pickRequestsType == 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Your items are picked up on ",
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        TextSpan(
                            text: widget.model.pickupDateTime,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      ])),
                    ],
                  ),
                if (widget.model.pickRequestsType == 2)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Your items are rejected because ",
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        TextSpan(
                            text: widget.model.rejectionRemarks,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      ])),
                    ],
                  ),
              ],
            ))
          ],
        ),
        const Divider(),
        const SizedBox(height: 8),
      ],
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
