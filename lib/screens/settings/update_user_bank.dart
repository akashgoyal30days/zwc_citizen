import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zwc/controllers/settings_controller.dart';
import 'package:zwc/widgets/text_field.dart';

import '../../model/locaiton_models.dart';

class UpdateBankDetailsScreen extends StatefulWidget {
  const UpdateBankDetailsScreen(this.bankModel, {super.key});
  final BankModel bankModel;
  @override
  State<UpdateBankDetailsScreen> createState() =>
      _UpdateBankDetailsScreenState();
}

class _UpdateBankDetailsScreenState extends State<UpdateBankDetailsScreen> {
  final accountNumberController = TextEditingController(),
      ifscController = TextEditingController(),
      UPIIdController = TextEditingController();
  bool showLoading = false, showError = false;

  @override
  void initState() {
    accountNumberController.text = widget.bankModel.accountNumber;
    ifscController.text = widget.bankModel.ifscCode;
    UPIIdController.text = widget.bankModel.upiID;
    super.initState();
  }

  submit() async {
    if (ifscController.text.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "IFSC Code should be 11 characters",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red));
      return;
    }
    showError =
        accountNumberController.text.isEmpty || ifscController.text.isEmpty;
    // || UPIIdController.text.isEmpty;
    setState(() {});
    if (showError) return;
    setState(() {
      showLoading = true;
    });
    await Get.find<SettingsController>().updateBankDetails(BankModel(data: {
      "account_no": accountNumberController.text,
      "ifsc_code": ifscController.text,
      "upi_id": UPIIdController.text,
    }));
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                UpdateProfileWidgets(
                  title: "Account Number",
                  hintText: "Enter your account Number",
                  textController: accountNumberController,
                ),
                UpdateProfileWidgets(
                  title: "IFSC Code",
                  hintText: "Enter your IFSC Code",
                  textController: ifscController,
                  inputType: TextInputType.emailAddress,
                ),
                UpdateProfileWidgets(
                  title: "UPI ID",
                  hintText: "Enter your UPI ID",
                  textController: UPIIdController,
                  inputType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
          showLoading
              ? Container(
                  height: 50,
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showError)
                      Text(
                        "Account No and Ifsc code is required",
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: submit,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        color: Colors.green,
                        child: Text(
                          "UPDATE CHANGES",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}

class UpdateProfileWidgets extends StatelessWidget {
  const UpdateProfileWidgets({
    super.key,
    required this.title,
    this.hintText = "",
    this.inputType,
    required this.textController,
  });
  final String title, hintText;
  final TextEditingController textController;
  final TextInputType? inputType;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          LoginTextField(
            hintText: hintText,
            inputType: inputType,
            controller: textController,
          )
        ],
      ),
    );
  }
}
