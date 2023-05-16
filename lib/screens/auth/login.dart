import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/login_ctrl.dart';
import '../../widgets/background_gradient.dart';
import '../../widgets/otp_login.dart';
import '../../widgets/password_login.dart';
import '../../widgets/top_part_for_auth_screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PageController pageController = PageController();

  final TextEditingController phoneNumberController = TextEditingController(),
      otpController = TextEditingController(),
      passwordController = TextEditingController();

  @override
  void initState() {
    Get.put<LoginController>(LoginController());
    super.initState();
  }

  changeLoginType() {
    Get.find<LoginController>()
      ..errorMessage = null
      ..gettingOTP = false
      ..showLoading = false;
    pageController.animateToPage(
      pageController.page == 1 ? 0 : 1,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
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
                      titleWord: "Welcome",
                      subTitleWord: "Back",
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          PasswordLogin(
                            changetoOTP: changeLoginType,
                            phoneNumberController: phoneNumberController,
                            passwordController: passwordController,
                          ),
                          OTPLogin(
                            changeToPassword: changeLoginType,
                            phoneNumberController: phoneNumberController,
                            otpController: otpController,
                          ),
                        ],
                      ),
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
