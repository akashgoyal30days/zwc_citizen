import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zwc/controllers/settings_controller.dart';
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
  @override
  void initState() {
    Get.put(SettingsController());
    super.initState();
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
                        showDivider: false,
                        onTap: () => Get.to(() => ChangePassword()),
                      ),
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
                      icon: Icon(Icons.whatsapp),
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
