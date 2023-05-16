import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zwc/controllers/new_account_reg_ctrl.dart';
import 'package:zwc/screens/new%20account%20details/address.dart';
import 'package:zwc/screens/new%20account%20details/location.dart';
import 'package:zwc/screens/new%20account%20details/submitting.dart';
import 'package:zwc/screens/auth/welcome_screen.dart';

import 'email.dart';
import 'name.dart';

class NewUserProfileUpdate extends StatefulWidget {
  const NewUserProfileUpdate({super.key});

  @override
  State<NewUserProfileUpdate> createState() => _NewUserProfileUpdateState();
}

class _NewUserProfileUpdateState extends State<NewUserProfileUpdate> {
  final PageController pageControlller = PageController();
  final TextEditingController firstNameController = TextEditingController(),
      lastNameController = TextEditingController(),
      emailController = TextEditingController(),
      addressController = TextEditingController(),
      cityController = TextEditingController(),
      pinCodeController = TextEditingController();

  @override
  void initState() {
    Get.put(NewAccountRegisterationController());
    super.initState();
  }

  nextPage() => pageControlller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );

  prevPage() => pageControlller.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );

  submit() {
    Get.find<NewAccountRegisterationController>().submit(
      "${firstNameController.text} ${lastNameController.text}",
      emailController.text,
      "${addressController.text}, ${cityController.text}, ${pinCodeController.text}",
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageControlller,
        children: [
          Page1(nextPage),
          Name(
            nextPage,
            firstNameController: firstNameController,
            lastNameController: lastNameController,
          ),
          Email(
            prevPage,
            nextPage,
            emailController: emailController,
          ),
          LocationUI(
            prevPage: prevPage,
            nextPage: nextPage,
          ),
          Address(
            nextPage: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              await nextPage();
              submit();
            },
            prevPage: prevPage,
            addressController: addressController,
            cityController: cityController,
            pinCodeController: pinCodeController,
          ),
          SubmittingData(prevPage: prevPage),
        ],
      ),
    );
  }
}

class ThePageStructure extends StatelessWidget {
  const ThePageStructure({
    super.key,
    this.nextPage,
    this.prevPage,
    this.isLastPage,
    required this.body,
  });
  final VoidCallback? nextPage, prevPage;
  final Widget body;
  final bool? isLastPage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (prevPage != null)
              FloatingActionButton(
                heroTag: "prev",
                onPressed: prevPage,
                child: const Icon(Icons.arrow_back),
              ),
            const Spacer(),
            if (nextPage != null)
              FloatingActionButton(
                heroTag: "next",
                onPressed: nextPage,
                child: isLastPage == true
                    ? const Icon(Icons.done)
                    : const Icon(Icons.arrow_forward_rounded),
              ),
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1(this.nextPage, {super.key});
  final VoidCallback nextPage;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundGradient(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Text(
                  "Personalize Your Account for a Better Experience",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Complete your profile for full access to our app. Without it, you may miss out on important features. Let's get started!",
                  style: GoogleFonts.montserrat(
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 24),
                FloatingActionButton(
                  onPressed: nextPage,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  child: const Icon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
