import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zwc/api/api_client.dart';
import 'package:zwc/controllers/settings_controller.dart';
import 'package:zwc/model/userassingedbranchmodel.dart';
import 'package:zwc/screens/settings/change_password.dart';
import 'package:zwc/screens/settings/user_bank.dart';
import 'package:zwc/screens/settings/user_location.dart';
import 'package:zwc/screens/settings/user_profile.dart';

import '../../api/urls.dart';
import '../../data/shared_preference.dart';
import '../../routes.dart';

class SettingsScreenNew extends StatefulWidget {
  const SettingsScreenNew({super.key});

  @override
  State<SettingsScreenNew> createState() => _SettingsScreenNewState();
}

class _SettingsScreenNewState extends State<SettingsScreenNew> {
  bool showPictureLoading = false;
  UserbranchassingeddataModel? userbranchdetails;
  final TextEditingController deleteotpcontroller = TextEditingController();
  @override
  void initState() {
    setbranchdata();
    Get.put(SettingsController());
    super.initState();
  }

  setbranchdata() {
    userbranchdetails = UserbranchassingeddataModel.fromJson(
        SharedPreferenceFunctions.getuserbranchdata());
  }

  showdeletepopup() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Delete Your Account",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please Enter OTP to confirm your account deletion process.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "This Process is not reversable , Please make sure you want to delete your account permantely.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    maxLength: 6,
                    controller: deleteotpcontroller,
                    decoration: InputDecoration(
                        hintText: "Enter OTP here",
                        hintStyle: TextStyle(color: Colors.grey)),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      if (deleteotpcontroller.text.toString().length == 6) {
                        var response = await APIClient.post(
                            URLS.confirm_delete_count,
                            body: {"otp": deleteotpcontroller.text.toString()});
                        var body = json.decode(response.body);
                        if (body["status"].toString() == "true") {
                          Get.showSnackbar(GetSnackBar(
                            duration: Duration(seconds: 2),
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red,
                            titleText: SizedBox(),
                            messageText: Text(
                              "Account Deleted",
                              style: TextStyle(color: Colors.white),
                            ),
                          ));
                          await SharedPreferenceFunctions.logout();
                          Get.offAllNamed(ZWCRoutes.toWelcomeScreen);
                        } else {
                          Get.showSnackbar(GetSnackBar(
                            duration: Duration(seconds: 2),
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red,
                            titleText: SizedBox(),
                            messageText: Text(
                              body["message"].toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ));
                        }
                      } else {
                        Get.showSnackbar(GetSnackBar(
                          duration: Duration(seconds: 2),
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          titleText: SizedBox(),
                          messageText: Text(
                            "OTP must be 6-digit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      width: Get.width,
                      child: Center(
                          child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  )
                ],
              ),
            ),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(8),
            children: [
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            backgroundImage:
                                showPictureLoading || controller.image.isEmpty
                                    ? null
                                    : CachedNetworkImageProvider(
                                        URLS.baseURL + controller.image,
                                      ),
                            child: showPictureLoading
                                ? CircularProgressIndicator()
                                : controller.image.isEmpty
                                    ? Icon(
                                        Icons.person,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        color: Colors.green,
                                      )
                                    : SizedBox(),
                            minRadius: MediaQuery.of(context).size.width * 0.15,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        controller.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        controller.email,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          "User Settings",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SettingsWidget(
                        iconData: Icons.person,
                        title: "Profile Information",
                        message: "View or update your information",
                        onTap: () => Get.to(() => UserProfile()),
                      ),
                      SettingsWidget(
                        iconData: Icons.location_city,
                        title: "Location",
                        message: "Manage your location",
                        onTap: () => Get.to(() => UserLocation()),
                      ),
                      SettingsWidget(
                        iconData: Icons.account_balance,
                        title: "Bank & UPI",
                        message: "Manage your bank details",
                        onTap: () => Get.to(() => UserBankDetails()),
                      ),
                      SettingsWidget(
                        iconData: Icons.key,
                        title: "Password",
                        message: "Update your password",
                        showDivider: true,
                        onTap: () => Get.to(() => ChangePassword()),
                      ),
                      if (userbranchdetails!.id != null)
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.headphones,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Contact Branch",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.business_sharp,
                                    color: Colors.grey.shade600,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    userbranchdetails!.branchName.toString(),
                                    style: GoogleFonts.montserrat(
                                      color: Colors.grey.shade600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        SocialIcons(
                                          iconData: FontAwesomeIcons.phone,
                                          color: Colors.black,
                                          callback: () {
                                            launchUrl(Uri.parse(
                                                "tel:+91${userbranchdetails!.branchContact.toString()}"));
                                          },
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Call",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      children: [
                                        SocialIcons(
                                          iconData: FontAwesomeIcons.envelope,
                                          color: Colors.black,
                                          callback: () {
                                            launchUrl(Uri.parse(
                                                "mailto:${userbranchdetails!.branchEmail.toString()}"));
                                          },
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Email",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SettingsWidget(
                        iconData: FontAwesomeIcons.personRays,
                        title: "Refer to a Friend",
                        message: "Invite your friends to join ZWC!",
                        onTap: () async {
                          Share.share(
                              r"Hey! Have you heard about our new recycling app? You can recycle items and get money in return! Check it out: https://play.google.com/store/apps/details?id=com.fctech.customer&hl=en_ZA&gl=US");
                        },
                      ),
                      ConnectWithUS(),
                      SettingsWidget(
                        iconData: Icons.adb_outlined,
                        title: "About ZWC",
                        message: "Privacy Policy, Terms & About ZWC",
                        showDivider: false,
                        onTap: () => launchUrl(
                          Uri.parse(
                            'https://www.zerowastecitizen.in/',
                          ),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SettingsWidget(
                    iconData: Icons.delete,
                    title: "Delete Account",
                    showDivider: false,
                    color: Colors.black,
                    onTap: () async {
                      var response = await APIClient.post(URLS.deleteaccount);
                      var body = json.decode(response.body);
                      if (body["status"].toString() == "true") {
                        Get.showSnackbar(GetSnackBar(
                          duration: Duration(seconds: 2),
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green,
                          titleText: SizedBox(),
                          messageText: Text(
                            body["message"].toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                        deleteotpcontroller.clear();
                        showdeletepopup();
                      }
                    },
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SettingsWidget(
                    iconData: Icons.logout,
                    title: "Logout",
                    showDivider: false,
                    color: Colors.red,
                    onTap: () async {
                      await SharedPreferenceFunctions.logout();
                      Get.offAllNamed(ZWCRoutes.toWelcomeScreen);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({
    Key? key,
    required this.iconData,
    required this.title,
    this.message,
    this.color = Colors.black,
    this.showDivider = true,
    this.onTap,
  }) : super(key: key);
  final IconData iconData;
  final String title;
  final String? message;
  final bool showDivider;
  final Color color;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(iconData, size: 20, color: color),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold, color: color),
                            ),
                            SizedBox(height: 8),
                            if (message != null)
                              Text(
                                message!,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            SizedBox(height: 2),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.grey, size: 16)
                    ],
                  ),
                  if (showDivider) Divider(),
                  if (showDivider) SizedBox(height: 8)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectWithUS extends StatelessWidget {
  const ConnectWithUS({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(FontAwesomeIcons.headset, size: 20, color: Colors.black),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Connect with us",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SocialIcons(
                    iconData: FontAwesomeIcons.globe,
                    color: Colors.black,
                    callback: () {
                      launchUrl(
                        Uri.parse("https://zerowastecitizen.in/"),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SocialIcons(
                                iconData: FontAwesomeIcons.phone,
                                color: Colors.black,
                                callback: () {
                                  launchUrl(Uri.parse("tel:+917827015365"));
                                },
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Call",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SocialIcons(
                                iconData: FontAwesomeIcons.envelope,
                                color: Colors.black,
                                callback: () {
                                  launchUrl(Uri.parse(
                                      "mailto:zwc@zerowastecitizen.in"));
                                },
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Email",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        launchUrl(
                            Uri.parse("whatsapp://send?phone=+917827015365"));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green.shade50)),
                      label: FittedBox(child: Text("Chat with us")),
                      icon: Icon(Icons.wechat),
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SocialIcons(
                                iconData: FontAwesomeIcons.facebook,
                                color: Colors.black,
                                callback: () {
                                  launchUrl(
                                    Uri.parse(
                                        "https://www.facebook.com/ZeroWasteCircularSolutions/"),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Facebook",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SocialIcons(
                                iconData: FontAwesomeIcons.linkedin,
                                color: Colors.black,
                                callback: () {
                                  launchUrl(
                                    Uri.parse(
                                        "https://www.linkedin.com/company/zwc-solutions/"),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                              ),
                              SizedBox(height: 4),
                              Text(
                                "LinkedIn",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SocialIcons(
                                iconData: FontAwesomeIcons.instagram,
                                color: Colors.black,
                                callback: () {
                                  launchUrl(
                                      Uri.parse(
                                          "https://www.instagram.com/zwcsolutions/"),
                                      mode: LaunchMode.externalApplication);
                                },
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Instagram",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SocialIcons(
                                iconData: FontAwesomeIcons.twitter,
                                color: Colors.black,
                                callback: () {
                                  launchUrl(
                                      Uri.parse(
                                          "https://twitter.com/ZWCSolutions"),
                                      mode: LaunchMode.externalApplication);
                                },
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Twitter",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SocialIcons(
                                iconData: FontAwesomeIcons.youtube,
                                color: Colors.black,
                                callback: () {
                                  launchUrl(
                                      Uri.parse(
                                          "https://www.youtube.com/@ZeroWasteSolution"),
                                      mode: LaunchMode.externalApplication);
                                },
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Youtube",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 8)
            ],
          ),
        ),
      ],
    );
  }
}

class SocialIcons extends StatelessWidget {
  const SocialIcons(
      {super.key,
      required this.iconData,
      required this.color,
      required this.callback});
  final IconData iconData;
  final Color color;
  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Icon(
        iconData,
        color: color,
        size: 18,
      ),
    );
  }
}
