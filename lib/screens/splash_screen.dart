import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:zwc/data/shared_preference.dart';
import 'package:zwc/routes.dart';

// This screen is visible for less than 500 ms
class SplashScreen extends StatelessWidget {
  
  SplashScreen({super.key}) {
    initializeApp();
  }

  initializeApp() async {
    // Initialises Shared Preference Instance static variable
    await SharedPreferenceSingleTon.initialize();

    // Navigates to screens based on user authorisation status
    Get.offAllNamed(
      SharedPreferenceFunctions.isUserLoggedin()
          ? (SharedPreferenceFunctions.userNeedsRegistration()
              ? ZWCRoutes.toNewUserProfile
              : ZWCRoutes.toHomeScreen)
          : ZWCRoutes.toWelcomeScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset("assets/images/logo.png"),
              Center(
                  child: ColorfulCircularProgressIndicator(colors: [
                Colors.green,
                Colors.lightGreen,
              ])),
            ],
          ),
        ),
      ),
    );
  }
}
