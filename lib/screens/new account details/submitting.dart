import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwc/controllers/new_account_reg_ctrl.dart';

import 'new_account_reg.dart';

class SubmittingData extends StatefulWidget {
  const SubmittingData({super.key, required this.prevPage});
  final VoidCallback prevPage;
  @override
  State<SubmittingData> createState() => _SubmittingDataState();
}

class _SubmittingDataState extends State<SubmittingData> {
  bool addressError = false, pincodeError = false, cityError = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewAccountRegisterationController>(builder: (controller) {
      return ThePageStructure(
          prevPage: controller.showLoading ? null : widget.prevPage,
          isLastPage: true,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Text(
                    "Updating!",
                    style: GoogleFonts.montserrat(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Keep the energy up, we're making great progress!",
                    style: GoogleFonts.montserrat(color: Colors.grey),
                  ),
                  Visibility(
                    visible: controller.errorMessage.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        controller.errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Visibility(
                    visible: controller.showLoading,
                    child: const CircularProgressIndicator(),
                  )
                ],
              ),
            ),
          ));
    });
  }
}
