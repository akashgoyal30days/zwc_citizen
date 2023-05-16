import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwc/controllers/log_in_success_controller.dart';

import '../../widgets/background_gradient.dart';

class LoginSuccess extends StatefulWidget {
  const LoginSuccess({super.key});

  @override
  State<LoginSuccess> createState() => _LoginSuccessState();
}

class _LoginSuccessState extends State<LoginSuccess> {
  @override
  void initState() {
    Get.put<LogInSuccessController>(LogInSuccessController()).getUserProfile(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.bottom,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            const Positioned.fill(
              child: BackgroundGradient(),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Image.asset(
                            "assets/images/logo_only.png",
                          ),
                        ),
                        const SizedBox(height: 40),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "You're now part of the revolution",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Request a pickup for your recyclable items, sit back and relax, and let us handle the rest. Together, we can create a greener tomorrow.",
                          style: GoogleFonts.montserrat(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            "Fetching your data",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontStyle: FontStyle.italic,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
