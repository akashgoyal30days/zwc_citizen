import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_ctrl.dart';
import '../routes.dart';
import 'custom_text_field.dart';

class PasswordLogin extends StatefulWidget {
  const PasswordLogin({
    Key? key,
    required this.changetoOTP,
    required this.phoneNumberController,
    required this.passwordController,
  }) : super(key: key);
  final VoidCallback changetoOTP;
  final TextEditingController phoneNumberController, passwordController;

  @override
  State<PasswordLogin> createState() => _PasswordLoginState();
}

class _PasswordLoginState extends State<PasswordLogin> {
  String? phoneNumberError, passwordError;

  validateInputs() {
    phoneNumberError = widget.phoneNumberController.text.length != 10
        ? "Should be 10 digits"
        : null;
    passwordError =
        widget.passwordController.text.isEmpty ? "Password required" : null;
    setState(() {});
    return phoneNumberError == null && passwordError == null;
  }

  login() {
    if (!validateInputs()) return;
    var controller = Get.find<LoginController>();
    controller.passwordLogin(
      widget.phoneNumberController.text,
      widget.passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              hint: "Phone Number",
              icon: Icons.phone,
              inputType: TextInputType.name,
              error: phoneNumberError,
              enabled: !controller.showLoading,
              controller: widget.phoneNumberController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: "Password",
              icon: Icons.lock_outline,
              inputType: TextInputType.visiblePassword,
              controller: widget.passwordController,
              error: passwordError ?? controller.errorMessage,
              enabled: !controller.showLoading,
              onSubmitted: login,
            ),
            Stack(
              children: [
                Opacity(
                  opacity: controller.showLoading ? 0 : 1,
                  child: AbsorbPointer(
                    absorbing: controller.showLoading,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton(
                          onPressed: widget.changetoOTP,
                          child: const Text("Instead login with OTP"),
                        ),
                        // TextButton(
                        //   onPressed: () {
                        //     Get.to(Forgotpassword());
                        //   },
                        //   child: const Text("Forgot Password?"),
                        // ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green[900]),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          onPressed: login,
                          child: const Text("Log in"),
                        ),
                        Row(
                          children: const [
                            Expanded(child: Divider(endIndent: 8)),
                            Text("or", style: TextStyle(color: Colors.grey)),
                            Expanded(child: Divider(indent: 8)),
                          ],
                        ),
                        TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: const BorderSide(color: Colors.green)),
                            ),
                          ),
                          onPressed: () {
                            Get.offNamed(ZWCRoutes.toRegistrationScreen);
                          },
                          child: const Text("Sign up"),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                if (controller.showLoading)
                  const Positioned.fill(
                      child: Center(child: CircularProgressIndicator()))
              ],
            ),
            const AgreementSentence(),
          ],
        ),
      );
    });
  }
}

class AgreementSentence extends StatelessWidget {
  const AgreementSentence({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
            style: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
              fontSize: 12,
            ),
            children: [
              TextSpan(
                text: "By logging in, you are agreeing to our ",
              ),
              TextSpan(
                text: "Terms of Service",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: " and ",
              ),
              TextSpan(
                text: "Privacy Policy.",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ]));
  }
}
