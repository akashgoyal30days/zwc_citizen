import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      this.hint,
      this.title,
      this.icon,
      this.onSubmitted,
      this.enabled = true,
      this.suffix,
      this.error,
      this.maxLength,
      this.inputType = TextInputType.name,
      this.focusNode});
  final TextEditingController controller;
  final String? hint, title, error;
  final TextInputType? inputType;
  final IconData? icon;
  final VoidCallback? onSubmitted;
  final bool? enabled;
  final Widget? suffix;
  final int? maxLength;
  final FocusNode? focusNode;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      maxLength:
          widget.inputType == TextInputType.phone ? 10 : widget.maxLength,
      enabled: widget.enabled,
      controller: widget.controller,
      obscureText:
          obscureText && widget.inputType == TextInputType.visiblePassword,
      textInputAction: widget.onSubmitted != null
          ? TextInputAction.done
          : TextInputAction.next,
      onEditingComplete: widget.onSubmitted != null
          ?  () {
                widget.onSubmitted!();
              }
          : null,
      inputFormatters: [
        if (widget.inputType == TextInputType.phone)
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,,.]{0,1}[0-9]*')),
      ],
      keyboardType: widget.inputType,
      decoration: InputDecoration(
        counterText: "",
        hintText: widget.hint,
        errorText: widget.error,
        suffixIcon: widget.enabled == true ? widget.suffix : null,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
      ),
    );
  }
}
