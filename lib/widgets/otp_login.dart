import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:zwc/controllers/login_ctrl.dart';
import 'package:zwc/widgets/custom_text_field.dart';
import 'package:zwc/widgets/password_login.dart';

import '../routes.dart';

class OTPLogin extends StatefulWidget {
  const OTPLogin({
    Key? key,
    required this.changeToPassword,
    required this.phoneNumberController,
    required this.otpController,
  }) : super(key: key);
  final VoidCallback changeToPassword;
  final TextEditingController phoneNumberController, otpController;

  @override
  State<OTPLogin> createState() => _OTPLoginState();
}

class _OTPLoginState extends State<OTPLogin> {
  String? phoneNumberError, otpError;

  editPhoneNumber() {
    Get.find<LoginController>().otpMode = false;
    setState(() {});
  }

  validatePhoneNumber() {
    phoneNumberError = widget.phoneNumberController.text.length != 10
        ? "Should be 10 digits"
        : null;

    setState(() {});
    return phoneNumberError == null;
  }

  getOTP() {
    if (!validatePhoneNumber()) return;
    Get.find<LoginController>().getOTP(widget.phoneNumberController.text);
  }

  validateOTP() {
    otpError = widget.otpController.text.isEmpty ? "OTP required" : null;
    setState(() {});
    return otpError == null;
  }

  logIn() {
    if (!validateOTP()) return;
    Get.find<LoginController>().verifyOTP(
        widget.phoneNumberController.text, widget.otpController.text);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) => Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              hint: "Phone Number",
              icon: Icons.phone,
              inputType: TextInputType.phone,
              enabled: !controller.otpMode,
              suffix: TextButton(
                onPressed:
                    controller.gettingOTP || controller.otpMode ? null : getOTP,
                child: const Text("Get OTP"),
              ),
              error: phoneNumberError,
              controller: widget.phoneNumberController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: "OTP",
              error: controller.errorMessage ?? otpError,
              suffix: controller.otpMode
                  ? ResendOTPWidget(widget.phoneNumberController)
                  : null,
              icon: Icons.lock_outline,
              inputType: TextInputType.phone,
              controller: widget.otpController,
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
                          onPressed: widget.changeToPassword,
                          child: const Text("Instead login with password"),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green[900]),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                          onPressed: logIn,
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
                        const AgreementSentence(),
                      ],
                    ),
                  ),
                ),
                if (controller.showLoading)
                  const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResendOTPWidget extends StatefulWidget {
  const ResendOTPWidget(this.phoneNumberController, {super.key});
  final TextEditingController phoneNumberController;
  @override
  State<ResendOTPWidget> createState() => _ResendOTPWidgetState();
}

class _ResendOTPWidgetState extends State<ResendOTPWidget> {
  bool showResendOTPButton = false;

  getOTP() async {
    if (!await Get.find<LoginController>()
        .getOTP(widget.phoneNumberController.text)) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "OTP has been sent!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[900],
      ),
    );
    setState(() => showResendOTPButton = false);
    setState(() {
      showResendOTPButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (controller) {
      return TextButton(
        onPressed: controller.gettingOTP
            ? null
            : (showResendOTPButton ? getOTP : null),
        child: showResendOTPButton
            ? const Text("Resend OTP")
            : Countdown(
                seconds: 60,
                build: (_, timer) => Text(
                  "${timer.toInt()}s",
                ),
                onFinished: () => setState(() => showResendOTPButton = true),
              ),
      );
    });
  }
}
