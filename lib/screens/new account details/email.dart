import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/custom_text_field.dart';
import 'new_account_reg.dart';

class Email extends StatefulWidget {
  const Email(this.prevPage, this.nextPage,
      {super.key, required this.emailController});
  final VoidCallback prevPage, nextPage;
  final TextEditingController emailController;

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  bool showError = false;

  validateThennextPage() {
    showError = !widget.emailController.text.contains("@");
    setState(() {});
    if (!showError) widget.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    return ThePageStructure(
        nextPage: validateThennextPage,
        prevPage: widget.prevPage,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Text(
                  "Stay connected and never miss a beat!",
                  style: GoogleFonts.montserrat(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter your email below to receive important updates and news from our app.",
                  style: GoogleFonts.montserrat(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: widget.emailController,
                  hint: "Email",
                  error: showError ? "Enter a valid email address" : null,
                  inputType: TextInputType.emailAddress,
                  icon: Icons.alternate_email_outlined,
                  onSubmitted: validateThennextPage,
                ),
              ],
            ),
          ),
        ));
  }
}
