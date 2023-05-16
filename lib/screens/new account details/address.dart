import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/custom_text_field.dart';
import 'new_account_reg.dart';

class Address extends StatefulWidget {
  const Address(
      {super.key,
      required this.nextPage,
      required this.prevPage,
      required this.addressController,
      required this.cityController,
      required this.pinCodeController});
  final VoidCallback nextPage, prevPage;
  final TextEditingController addressController,
      pinCodeController,
      cityController;

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  bool addressError = false, pincodeError = false, cityError = false;

  validateThennextPage() {
    addressError = widget.addressController.text.isEmpty;
    cityError = widget.cityController.text.isEmpty;
    pincodeError = widget.pinCodeController.text.isEmpty;
    setState(() {});
    if (!(addressError || pincodeError || cityError)) widget.nextPage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThePageStructure(
        nextPage: validateThennextPage,
        prevPage: widget.prevPage,
        isLastPage: true,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Text(
                  "Final Step!",
                  style: GoogleFonts.montserrat(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "This is it! The final step to complete your process is to enter your address below.",
                  style: GoogleFonts.montserrat(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: widget.addressController,
                  hint: "Address",
                  error: addressError ? "Address is required" : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: widget.cityController,
                        hint: "City",
                        error: cityError ? "City is required" : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: widget.pinCodeController,
                        hint: "Pincode",
                        inputType: TextInputType.phone,
                        onSubmitted: validateThennextPage,
                        error: pincodeError ? "Pincode is required" : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
