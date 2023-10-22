import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zwc/controllers/dashboard_controller.dart';
import 'package:zwc/model/certificate_model.dart';
import 'package:zwc/screens/dashboard/certificate.dart';

class EnvironmentSavedWidget extends StatefulWidget {
  const EnvironmentSavedWidget(
      {super.key,
      required this.environmentSaving,
      required this.environmentSavingLifetime,
      required this.dateRange});
  final Map environmentSaving, environmentSavingLifetime;
  final DateTimeRange dateRange;
  @override
  State<EnvironmentSavedWidget> createState() => _EnvironmentSavedWidgetState();
}

class _EnvironmentSavedWidgetState extends State<EnvironmentSavedWidget> {
  Map currentSelection = {};
  @override
  void initState() {
    currentSelection = widget.environmentSaving;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Environmental Saving",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 18,
              ),
            ),
            currentSelection == widget.environmentSaving
                ? RichText(
                    text: TextSpan(
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                        children: [
                        TextSpan(
                            text: DateFormat("d MMMM")
                                .format(widget.dateRange.start)),
                        const TextSpan(text: " - "),
                        TextSpan(
                            text: DateFormat("d MMMM")
                                .format(widget.dateRange.end)),
                      ]))
                : RichText(
                    text: TextSpan(
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                        children: [
                        const TextSpan(text: "Your Lifetime savings"),
                      ])),
            currentSelection == widget.environmentSaving
                ? TextButton(
                    onPressed: () {
                      currentSelection = widget.environmentSavingLifetime;
                      setState(() {});
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.green.withOpacity(0.1))),
                    child: const Text("See Lifetime Savings"),
                  )
                : TextButton(
                    onPressed: () {
                      currentSelection = widget.environmentSaving;
                      setState(() {});
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.green.withOpacity(0.1))),
                    child: const Text("See Current Savings"),
                  ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EnvironmentalSavingWidgets(
                  title: "Carbon",
                  icon: Icons.local_fire_department,
                  value: currentSelection["Carbon Emmission"] ?? 0,
                  units: "KG",
                  color: Colors.orange,
                ),
                EnvironmentalSavingWidgets(
                  title: "Landfill",
                  icon: Icons.delete,
                  value: currentSelection["Landfill Saves"] ?? 0,
                  units: "M3",
                  color: Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EnvironmentalSavingWidgets(
                  title: "Oil",
                  icon: Icons.local_gas_station,
                  value: currentSelection["Oil Conserves"] ?? 0,
                  units: "Ltrs",
                  color: Colors.blueGrey,
                ),
                EnvironmentalSavingWidgets(
                  title: "Water",
                  icon: Icons.water_drop,
                  value: currentSelection["Water Saved"] ?? 0,
                  units: "Ltrs",
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EnvironmentalSavingWidgets(
                  title: "Trees",
                  icon: Icons.eco,
                  value: currentSelection["Trees Saved"] ?? 0,
                  units: "",
                  color: Colors.green,
                ),
                GetBuilder<DashboardController>(builder: (controller) {
                  if (controller.certificateLoading)
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  return Expanded(
                      child: TextButton.icon(
                    onPressed: () async {
                      CertificateModel? model =
                          await controller.getCertificate();
                      if (model == null) return;
                      Get.to(() => CertificateScreen(model));
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.green.withOpacity(0.1))),
                    label: const Text("Certificate"),
                    icon: Icon(Icons.workspace_premium),
                  ));
                })
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EnvironmentalSavingWidgets extends StatelessWidget {
  const EnvironmentalSavingWidgets({
    Key? key,
    required this.title,
    required this.icon,
    required this.units,
    required this.value,
    required this.color,
  }) : super(key: key);
  final String title, units;
  final IconData icon;
  final double value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(style: TextStyle(color: color), children: [
                      TextSpan(
                        text: value.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " $units",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ])),
                const SizedBox(width: 6),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      const TextSpan(
                        text: "of ",
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.black),
                      ),
                      TextSpan(
                        text: title,
                        style: GoogleFonts.montserrat(color: Colors.black),
                      ),
                    ])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
