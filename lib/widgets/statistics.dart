import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/dashboard_controller.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key, required this.dateRange});
  final DateTimeRange dateRange;
  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  int viewGraphIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Statistics",
              style: GoogleFonts.montserrat(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            RichText(
                text: TextSpan(
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                    children: [
                  TextSpan(
                      text:
                          DateFormat("d MMMM").format(widget.dateRange.start)),
                  const TextSpan(text: " - "),
                  TextSpan(
                      text: DateFormat("d MMMM").format(widget.dateRange.end)),
                ])),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      viewGraphIndex = 0;
                      setState(() {});
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          viewGraphIndex == 0 ? Colors.green : Colors.white),
                      foregroundColor: MaterialStateProperty.all(
                          viewGraphIndex == 0 ? Colors.white : Colors.green),
                    ),
                    child: const FittedBox(child: Text("Waste Deposited")),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      viewGraphIndex = 1;
                      setState(() {});
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          viewGraphIndex == 1 ? Colors.green : Colors.white),
                      foregroundColor: MaterialStateProperty.all(
                          viewGraphIndex == 1 ? Colors.white : Colors.green),
                    ),
                    child: const FittedBox(
                      child: Text(
                        "Category",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: viewGraphIndex == 0,
              child: SfCartesianChart(
                // Initialize category axis

                primaryXAxis: CategoryAxis(),
                series: [
                  LineSeries<WasteCollectedModel, String>(
                    color: Colors.green,
                    // Bind data source
                    dataSource: controller.wasteCollected,
                    xValueMapper: (WasteCollectedModel sales, _) =>
                        DateFormat("d/M").format(
                      DateTime(
                        int.parse(sales.label.substring(0, 4)),
                        int.parse(sales.label.substring(5, 7)),
                        int.parse(sales.label.substring(8)),
                      ),
                    ),
                    yValueMapper: (WasteCollectedModel sales, _) => sales.data,
                  )
                ],
              ),
            ),
            Visibility(
              visible: viewGraphIndex == 1,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: [
                  BarSeries<CollectionModel, String>(
                    color: Colors.green,
                    dataSource: controller.collection,
                    xValueMapper: (CollectionModel colections, _) =>
                        colections.label,
                    yValueMapper: (CollectionModel colections, _) =>
                        colections.data,
                  )
                ],
              ),
            ),
          ]),
        ),
      );
    });
  }
}
