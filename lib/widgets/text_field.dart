import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    Key? key,
    required this.hintText,
    this.errorText,
    this.inputType,
    this.maxLength,
    this.suffix,
    this.obscureText = false,
    this.prefix,
    this.minLines,
    this.enabled = true,
    this.onSubmitted,
    required this.controller,
  }) : super(key: key);
  final bool enabled, obscureText;
  final String? hintText, errorText;
  final Widget? prefix, suffix;
  final TextInputType? inputType;
  final int? maxLength, minLines;
  final TextEditingController controller;
  final VoidCallback? onSubmitted;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          if (prefix != null)
            Row(
              children: [
                prefix!,
                const SizedBox(width: 6),
              ],
            ),
          Expanded(
            child: TextField(
              enabled: enabled,
              textInputAction: onSubmitted != null
                  ? TextInputAction.done
                  : TextInputAction.next,
              onSubmitted: onSubmitted != null ? ((_) => onSubmitted!()) : null,
              obscureText: obscureText,
              controller: controller,
              maxLength: maxLength,
              keyboardType: inputType,
              style: TextStyle(color: enabled ? null : Colors.grey[600]),
              inputFormatters: [
                if (inputType == TextInputType.number)
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]+[,,.]{0,1}[0-9]*')),
              ],
              decoration: InputDecoration(
                errorText: errorText,
                counterText: "",
                fillColor: Colors.grey[200],
                filled: true,
                hintText: hintText,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                  gapPadding: 0,
                ),
              ),
            ),
          ),
          if (suffix != null)
            Row(
              children: [
                const SizedBox(width: 6),
                suffix!,
              ],
            ),
        ],
      ),
    );
  }
}
