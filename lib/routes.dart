import 'package:get/route_manager.dart';

import 'package:zwc/screens/app_structure_screen.dart';

import 'package:zwc/screens/auth/login.dart';
import 'package:zwc/screens/new%20account%20details/new_account_reg.dart';
import 'package:zwc/screens/auth/registeration.dart';
import 'package:zwc/screens/splash_screen.dart';
import 'package:zwc/screens/auth/welcome_screen.dart';

class ZWCRoutes {
  static const toLoginScreen = "/loginScreen",
      toWelcomeScreen = "/welcomeScreen",
      toRegistrationScreen = "/registrationScreen",
      toHomeScreen = "/homeScreen",
      toNewUserProfile = "/newUserProfile",
      toUpdateUserProfile = "/updateUserProfile";

  static final List<GetPage> getPages = [
    GetPage(
      name: "/",
      page: () => SplashScreen(),
    ),
    GetPage(
      name: ZWCRoutes.toWelcomeScreen,
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: ZWCRoutes.toLoginScreen,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: ZWCRoutes.toRegistrationScreen,
      page: () => const RegisterationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: ZWCRoutes.toNewUserProfile,
      page: () => const NewUserProfileUpdate(),
    ),
    GetPage(
      name: ZWCRoutes.toHomeScreen,
      page: () => const AppStructureScreen(),
    ),
  ];
}
