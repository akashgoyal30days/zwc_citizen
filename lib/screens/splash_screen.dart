import 'dart:developer';
import 'dart:io';

import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

import 'package:zwc/data/shared_preference.dart';
import 'package:zwc/routes.dart';

// This screen is visible for less than 500 ms
class SplashScreen extends StatefulWidget {
  SplashScreen({super.key}) {}

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  initializeApp() async {
    // Initialises Shared Preference Instance static variable
    await SharedPreferenceSingleTon.initialize();
    checkForUpdates(context);

    // Navigates to screens based on user authorisation status
    Get.offAllNamed(
      SharedPreferenceFunctions.isUserLoggedin()
          ? (SharedPreferenceFunctions.userNeedsRegistration()
              ? ZWCRoutes.toNewUserProfile
              : ZWCRoutes.toHomeScreen)
          : ZWCRoutes.toWelcomeScreen,
    );
  }

  void checkForUpdates(BuildContext context) async {
    if (Platform.isAndroid) {
      InAppUpdate.checkForUpdate().then((updateInfo) {
        if (updateInfo.updateAvailability ==
            UpdateAvailability.updateAvailable) {
          InAppUpdate.performImmediateUpdate().then((_) {
            // Show a progress indicator or custom UI during the update process
          }).catchError((error) {
            log(error.toString());
            // Handle error during the update process
          });
        }
      }).catchError((error) {
        log(error.toString());
        // Handle error while checking for updates
      });
    }
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
