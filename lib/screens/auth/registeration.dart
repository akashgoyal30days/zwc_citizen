import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../controllers/registeration_ctrl.dart';
import '../../routes.dart';
import '../../widgets/background_gradient.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/top_part_for_auth_screens.dart';

class RegisterationScreen extends StatefulWidget {
  const RegisterationScreen({super.key});

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  final TextEditingController phoneNumberController = TextEditingController(),
      otpController = TextEditingController(),
      nameController = TextEditingController();

  @override
  void initState() {
    Get.put<RegisterationController>(RegisterationController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: BackgroundGradient(),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.bottom -
                    MediaQuery.of(context).padding.top,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const TopPart(
                      titleWord: "Create",
                      subTitleWord: "Account",
                    ),
                    RegisterationPart(
                      phoneNumberController: phoneNumberController,
                      otpController: otpController,
                      nameController: nameController,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterationPart extends StatefulWidget {
  const RegisterationPart({
    Key? key,
    required this.phoneNumberController,
    required this.otpController,
    required this.nameController,
  }) : super(key: key);

  final TextEditingController phoneNumberController,
      nameController,
      otpController;

  @override
  State<RegisterationPart> createState() => _RegisterationPartState();
}

class _RegisterationPartState extends State<RegisterationPart> {
  String? phoneNumberError, otpError, nameError, userID;

  editPhoneNumber() {
    Get.find<RegisterationController>().otpMode = false;
    setState(() {});
  }

  validateFields() {
    phoneNumberError = widget.phoneNumberController.text.length != 10
        ? "Should be 10 digits"
        : null;
    nameError =
        widget.nameController.text.isEmpty ? "Full name required" : null;

    setState(() {});
    return phoneNumberError == null && nameError == null;
  }

  getOTP() async {
    if (!validateFields()) return;
    userID = await Get.find<RegisterationController>()
        .getOTP(widget.nameController.text, widget.phoneNumberController.text);
  }

  validateOTP() {
    otpError = widget.otpController.text.isEmpty ? "OTP required" : null;
    setState(() {});
    return otpError == null;
  }

  register() {
    if (!validateOTP()) return;
    Get.find<RegisterationController>()
        .verifyOTP(widget.otpController.text, userID ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterationController>(
      builder: (controller) => Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              hint: "Full Name",
              icon: Icons.person,
              inputType: TextInputType.name,
              enabled: !controller.otpMode,
              error: nameError,
              controller: widget.nameController,
            ),
            const SizedBox(height: 16),
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
              enabled: !controller.showLoading,
              error: controller.errorMessage ?? otpError,
              suffix: controller.otpMode
                  ? ResendOTPWidget(widget.phoneNumberController)
                  : null,
              icon: Icons.lock_outline,
              inputType: TextInputType.phone,
              controller: widget.otpController,
            ),
            const SizedBox(height: 18),
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
                          onPressed: register,
                          child: const Text("Create Account"),
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
                            Get.offNamed(ZWCRoutes.toLoginScreen);
                          },
                          child: const Text("Log In"),
                        ),
                      ],
                    ),
                  ),
                ),
                if (controller.showLoading)
                  const Positioned.fill(
                    child: Center(child: CircularProgressIndicator()),
                  )
              ],
            ),
            const SizedBox(height: 10),
            RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: "By signing up, you are agreeing to our ",
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
                    ]))
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
    if (!await Get.find<RegisterationController>()
        .resendOTP(widget.phoneNumberController.text)) {
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
    return GetBuilder<RegisterationController>(builder: (controller) {
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
