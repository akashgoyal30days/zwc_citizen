import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwc/controllers/settings_controller.dart';
import 'package:zwc/model/locaiton_models.dart';
import 'package:zwc/screens/settings/update_user_bank.dart';

class UserBankDetails extends StatefulWidget {
  const UserBankDetails({super.key});

  @override
  State<UserBankDetails> createState() => _UserBankDetailsState();
}

class _UserBankDetailsState extends State<UserBankDetails> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.green,
        ),
        body: controller.selectedBank == null
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "You didn't add bank details,\nadd your bank details for deposits",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() =>
                            UpdateBankDetailsScreen(BankModel(data: {})));
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add Bank Details"),
                    ),
                  ),
                ],
              )
            : ListView(
                children: [
                  Card(
                    elevation: 10,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Bank details",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 18,
                                  ),
                                ),
                              )),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => UpdateBankDetailsScreen(
                                      controller.selectedBank!));
                                },
                                icon: Icon(Icons.edit, size: 16),
                              ),
                            ],
                          ),
                          DetailWidget(
                            title: "UPI ID",
                            data: controller.selectedBank!.upiID,
                          ),
                          DetailWidget(
                            title: "Account Number",
                            data: controller.selectedBank!.accountNumber,
                          ),
                          DetailWidget(
                            title: "IFSC code",
                            data: controller.selectedBank!.ifscCode,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }
}

class DetailWidget extends StatelessWidget {
  const DetailWidget({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  final String title, data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        Text(
          data,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
