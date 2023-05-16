import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/custom_text_field.dart';
import 'new_account_reg.dart';

class Name extends StatefulWidget {
  const Name(this.nextPage,
      {super.key,
      required this.firstNameController,
      required this.lastNameController});
  final VoidCallback nextPage;
  final TextEditingController firstNameController, lastNameController;

  @override
  State<Name> createState() => _NameState();
}

class _NameState extends State<Name> {
  bool firstNameError = false, lastNameError = false;

  validateThennextPage() {
    firstNameError = widget.firstNameController.text.isEmpty;
    lastNameError = widget.lastNameController.text.isEmpty;
    setState(() {});
    if (!(firstNameError || lastNameError)) widget.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return ThePageStructure(
        nextPage: validateThennextPage,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Text(
                  "Let's start with your name",
                  style: GoogleFonts.montserrat(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter your Full Name",
                  style: GoogleFonts.montserrat(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: widget.firstNameController,
                  hint: "First name",
                  error: firstNameError? "Enter your first name":null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: widget.lastNameController,
                  hint: "Last name",
                  onSubmitted: validateThennextPage,
                  error: lastNameError? "Enter your last name":null,
                ),
              ],
            ),
          ),
        ));
  }
}
