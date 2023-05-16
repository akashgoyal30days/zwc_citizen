import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zwc/controllers/settings_controller.dart';
import 'package:zwc/widgets/text_field.dart';

import '../../controllers/change_password_controller.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final newPassword = TextEditingController(),
      confirmPassword = TextEditingController();
  String errorText = "";
  bool loading = false;

  @override
  void initState() {
    Get.put<ChangePasswordController>(ChangePasswordController());
    super.initState();
  }

  submit() async {
    errorText = "";
    setState(() {});
    if (newPassword.text.isEmpty || confirmPassword.text.isEmpty) {
      errorText = "All fields should be attempted";
      setState(() {});
      return;
    }
    if (newPassword.text != confirmPassword.text) {
      errorText = "New password and Confirm password must match";
      setState(() {});
      return;
    }
    setState(() => loading = true);
    if (await Get.find<SettingsController>().updatePassword(newPassword.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Password has been changed Succesfully"),
        backgroundColor: Colors.green,
      ));
      Get.back();
      return;
    }
    setState(() => loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Password has been changed Succesfully"),
      backgroundColor: Colors.green,
      action: SnackBarAction(
        textColor: Colors.white,
        label: "Dismiss",
        onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Password")),
      body: GetBuilder<ChangePasswordController>(builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Text(
                    "New Password",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LoginTextField(
                    enabled: !controller.showLoading,
                    hintText: "Enter your new Password",
                    controller: newPassword,
                    obscureText: true,
                  ),
                  _PasswordInformation(newPassword),
                  const Text(
                    "Confirm Password",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LoginTextField(
                    enabled: !controller.showLoading,
                    hintText: "Confirm new Password",
                    controller: confirmPassword,
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  if (errorText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        errorText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            loading
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
                : GestureDetector(
                    onTap: submit,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      color: Colors.green,
                      child: Text(
                        "UPDATE PASSWORD",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
          ],
        );
      }),
    );
  }
}

class _PasswordInformation extends StatefulWidget {
  const _PasswordInformation(
    this.controller, {
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<_PasswordInformation> createState() => _PasswordInformationState();
}

class _PasswordInformationState extends State<_PasswordInformation> {
  bool passwordLengthError = false,
      alphanumericError = false,
      characterCheckError = false;
  @override
  void initState() {
    widget.controller.addListener(() {
      passwordLengthError = widget.controller.text.length < 8 ||
          widget.controller.text.length > 12;
      alphanumericError = !(widget.controller.text[0].isAlphabetOnly ||
          widget.controller.text[0].isNumericOnly);
      print(passwordLengthError);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        _PasswordInformationWidgets(
          "Password should be 8 to 12 characters long",
          color: passwordLengthError ? Colors.red : Colors.grey,
        ),
        _PasswordInformationWidgets(
          "Password should should start with Alphanumeric Character",
          color: alphanumericError ? Colors.red : Colors.grey,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class _PasswordInformationWidgets extends StatelessWidget {
  const _PasswordInformationWidgets(
    this.data, {
    Key? key,
    this.color = Colors.grey,
  }) : super(key: key);
  final String data;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.do_disturb_on_rounded, color: color, size: 12),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              data,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
