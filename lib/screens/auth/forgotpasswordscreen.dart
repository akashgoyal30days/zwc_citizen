import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zwc/screens/auth/login.dart';
import 'package:zwc/widgets/text_field.dart';

import '../../controllers/change_password_controller.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final username = TextEditingController();
  final ChangePasswordController passwordcontroller =
      Get.put(ChangePasswordController());
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
    if (username.text.isEmpty) {
      errorText = "Username is Required";
      setState(() {});
      return;
    } else {
      passwordcontroller
          .forgotpassword(username: username.text.toString())
          .then((value) {
        if (value == true) {
          username.clear();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Your new password sent on your mail."),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              textColor: Colors.white,
              label: "Dismiss",
              onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
            ),
          ));
          Get.to(LoginScreen());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: GetBuilder<ChangePasswordController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Looks like you forgot your password !!",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Please enter your username and Proceed to get your password details.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green.shade300,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              LoginTextField(
                enabled: !controller.showLoading,
                hintText: "Enter your username",
                controller: username,
                obscureText: false,
              ),
              if (errorText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    errorText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              controller.showLoading
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
                          "PROCEED",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }
}
